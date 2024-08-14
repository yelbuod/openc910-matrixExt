/***************************************************************************************
* Copyright (c) 2014-2022 Zihao Yu, Nanjing University
*
* NEMU is licensed under Mulan PSL v2.
* You can use this software according to the terms and conditions of the Mulan PSL v2.
* You may obtain a copy of Mulan PSL v2 at:
*          http://license.coscl.org.cn/MulanPSL2
*
* THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
* EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
* MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
*
* See the Mulan PSL v2 for more details.
***************************************************************************************/

/* We use the POSIX regex functions to process regular expressions.
 * Type 'man regex' for more information about POSIX regex functions.
 */
#include <regex.h>
#include <debug.h>
#include <macro.h>
#include "reg.h"

enum {
  TK_NOTYPE = 256, TK_DEC_INTEGER, TK_HEX_INTEGER, TK_REG_NAME, TK_EQ, TK_UEQ, TK_AND, TK_DEREF,

  /* TODO: Add more token types */

};

static struct rule {
  const char *regex;
  int token_type;
} rules[] = {

  /* TODO: Add more rules.
   * Pay attention to the precedence level of different rules.
   */

  {" +", TK_NOTYPE},    // spaces
  {"\\+", '+'},         // plus
  {"\\-", '-'},         // sub
  {"\\*", '*'},         // multiplication
  {"/", '/'},       // division
  {"0x[0-9A-Fa-f]+", TK_HEX_INTEGER}, // hexadecimal integer
  {"[0-9]+", TK_DEC_INTEGER}, // decimal integer
  {"[\\$]{1}[\\$a-z]{1}[0-9a-z]{1}[0-9]{,1}", TK_REG_NAME}, // register name
  {"\\(", '('},         // (
  {"\\)", ')'},         // )
  {"==", TK_EQ},        // equal
  {"!=", TK_UEQ},        // unequal
  {"&&", TK_AND},        // and 
};

#define NR_REGEX ARRLEN(rules)

static regex_t re[NR_REGEX] = {};

/* Rules are used for many times.
 * Therefore we compile them only once before any usage.
 */
void init_regex() {
  int i;
  char error_msg[128];
  int ret;

  for (i = 0; i < NR_REGEX; i ++) {
    ret = regcomp(&re[i], rules[i].regex, REG_EXTENDED);
    if (ret != 0) {
      regerror(ret, &re[i], error_msg, 128);
      panic("regex compilation failed: %s\n%s", error_msg, rules[i].regex);
    }
  }
}

typedef struct token {
  int type;
  char str[32];
} Token;

static Token tokens[65536] __attribute__((used)) = {};
static int nr_token __attribute__((used))  = 0;

static bool make_token(char *e) {

  int position = 0;
  int i;
  regmatch_t pmatch;

  nr_token = 0;
  
  while (e[position] != '\0') {
    if(nr_token >= 65536) // the access of tokens array will overflow
      assert(0);
    /* Try all rules one by one. */
    for (i = 0; i < NR_REGEX; i ++) {
      if (regexec(&re[i], e + position, 1, &pmatch, 0) == 0 && pmatch.rm_so == 0) {
        char *substr_start = e + position;
        int substr_len = pmatch.rm_eo;

        // Log("match rules[%d] = \"%s\" at position %d with len %d: %.*s",
        //     i, rules[i].regex, position, substr_len, substr_len, substr_start);

        position += substr_len;

        /* TODO: Now a new token is recognized with rules[i]. Add codes
         * to record the token in the array `tokens'. For certain types
         * of tokens, some extra actions should be performed.
         */

        switch (rules[i].token_type) {
          case TK_NOTYPE:
            break; // Blank String is not recorded
          case TK_DEC_INTEGER: case TK_HEX_INTEGER: case TK_REG_NAME:
            if(substr_len <= 32) {
              memset(tokens[nr_token].str, '\0', sizeof(tokens[nr_token].str));
              // tokens[nr_token].str no need to be null-terminated because 'strtol' func no need nptr param to be null-terminated
              strncpy(tokens[nr_token].str, substr_start, substr_len); 
              tokens[nr_token].type = rules[i].token_type;
              nr_token++;
              break;
            }
            else
              assert(0); // Keep It Simple, Stupid
          default: 
            tokens[nr_token].type = rules[i].token_type;
            nr_token++;
            break;
        }

        break;
      }
    }

    if (i == NR_REGEX) {
      printf("no match at position %d\n%s\n%*.s^\n", position, e, position, "");
      return false;
    }
  }
  // // test make_token
  // for(int i = 0; i < nr_token; i++) {
  //   char temp_str[33];
  //   temp_str[32] = '\0';
  //   printf("#%d: %d type, %s\n", i, tokens[i].type, strncpy(temp_str, tokens[i].str, 32));
  // }
  // // test make_token
  return true;
}

static int stack[32768];
int top = 0;

void push(int num) {
  stack[top++] = num;
}

int pop(int num) {
  int ret = stack[--top];
  return ret;
}

int is_empty() {
  return (top == 0);
}

void clean_stack() {
  top = 0;
}

bool bad_expr = false;

static bool check_parentheses(int substr_start, int substr_end) {
  clean_stack();
  bad_expr = false;
  bool return_ = true;

  if ((tokens[substr_start].type != '(') || (tokens[substr_end].type != ')')) {
    // if(check_flag) return false;
    return_ = false;
  }
  else {
    for(int i = substr_start; i <= substr_end; i++) {
      if (tokens[i].type == '(')
        push(i);
      else if (tokens[i].type == ')') {
        if(is_empty()) {
          bad_expr = true;
          return false;
        }
        pop(i);
      }
      else 
        continue;
      
      if (i != substr_end && is_empty()) 
        return_ = false;
    }

    if (!is_empty()) {
      bad_expr = true;
      return false;
    }
  }

  return return_;
}


word_t eval(int p, int q) {
  if (p > q) {
    // Bad expression
    Log("Bad expression");
    assert(0);
  }
  else if (p == q) {
    /* Single token.
     * For now this token should be a number.
     * Return the value of the number.
    */
    if (tokens[p].type == TK_DEC_INTEGER)
      return (word_t)atoi(tokens[p].str); // temporarily use atoi, KISS
    else if (tokens[p].type == TK_HEX_INTEGER)
      return (word_t)strtol(tokens[p].str, NULL, 16);
    else if (tokens[p].type == TK_REG_NAME) {
      bool success;
      word_t reg_val = 0; //reg_str2val(tokens[p].str+1, &success); // +1 for ignoring character '$' in reg name
      if(success)
        return reg_val;
      else {
        Log("Register does not exist, get default zero");
        return 0;
      }
    }
    else return 0;
  }
  else if (check_parentheses(p, q) == true) {
    /* The expression is surrounded by a matched pair of parentheses.
     * If that is the case, just throw away the parentheses.
     */
    return eval(p + 1, q - 1);
  }
  else {
    if(bad_expr == true) {
      Log("Bad expression");
      return 0;
    }

    int main_op = -1;
    /* We need to find 主运算符 and use it to split a long expression into two subexpression. */
    for(int i = p; i <= q; i++) {
      if(tokens[i].type == TK_DEC_INTEGER || tokens[i].type == TK_HEX_INTEGER || 
         tokens[i].type == TK_REG_NAME || tokens[i].type == '(' || tokens[i].type == ')')
        continue;
      else {
        int no_main_op = 0;
        for(int j = p; j < i; j++) {
          if( tokens[j].type == '(' ) {
            for(int k = i+1; k <= q; k++) {
              if( tokens[k].type == ')' && check_parentheses(j, k) == true ) { 
                // operator being between '(' and ')' and '(' and ')' are matched 
                // means that this operator is no the main operator
                no_main_op = 1;
                break;
              }
            }

            if(no_main_op)
              break;
          }
        }

        if (no_main_op != 1) {
          if (main_op == -1)
            main_op = i;
          else {
            switch (tokens[main_op].type) {
              case TK_AND: 
                if (tokens[i].type == TK_AND) main_op = i;
                break;
              case TK_EQ: case TK_UEQ: 
                if (tokens[i].type == TK_AND || tokens[i].type == TK_EQ || tokens[i].type == TK_UEQ) main_op = i;
                break;
              case '+': case '-':
                if (tokens[i].type != '*' && tokens[i].type != '/' && tokens[i].type != TK_DEREF) main_op = i;
                break;
              case '*': case '/':
                if (tokens[i].type != TK_DEREF) main_op = i;
                break;
              case TK_DEREF:
                main_op = i;
                break;
              default: assert(0);
            }
          }
        }
      }
    }

    if (main_op == -1) {
      bad_expr = true;
      Log("Bad expression");
      return 0;
    }
    // printf("p: %d, main_op: %d, q: %d\n", p, main_op, q);
    word_t val1 = 0;
    if (tokens[main_op].type != TK_DEREF)
      val1 = eval(p, main_op - 1); 
    
    word_t val2 = eval(main_op + 1, q);

    switch (tokens[main_op].type) {
      case '+': return (val1 + val2);
      case '-': return (val1 - val2);
      case '*': return (val1 * val2);
      case '/': return (val1 / val2);
      case TK_EQ: return (val1 == val2);
      case TK_UEQ: return (val1 != val2);
      case TK_AND: return (val1 && val2);
      // case TK_DEREF: 
      //   if (!in_pmem(val2)) {
      //     Log("address = " FMT_PADDR " is out of bound of pmem [" FMT_PADDR ", " FMT_PADDR "]",
      //       (paddr_t)val2, (paddr_t)CONFIG_MBASE, (paddr_t)CONFIG_MBASE + CONFIG_MSIZE - 1);
      //     return 0;
      //   }
      //   else
      //     return (word_t)paddr_read(val2, 4);
      default: assert(0);
    }

  }
}

word_t expr(char *e, bool *success) {

  *success = true;

  if (!make_token(e)) {
    *success = false;
    return 0;
  }

  for (int i = 0; i < nr_token; i++) {
    if (tokens[i].type == '*' && 
        (i == 0 || 
        tokens[i - 1].type == '+' || tokens[i - 1].type == '-' || 
        tokens[i - 1].type == '*' || tokens[i - 1].type == '/' ||
        tokens[i - 1].type == '(' || tokens[i - 1].type == TK_EQ ||
        tokens[i - 1].type == TK_UEQ || tokens[i - 1].type == TK_AND)
       )
    {
      tokens[i].type = TK_DEREF;
    }
  }

  /* TODO: Insert codes to evaluate the expression. */
  word_t result_val = eval(0, nr_token-1);
  // printf("EXPR = %d\n", result_val);
  if(bad_expr == true) {
    *success = false;
    return 0;
  }

  return result_val;
}
