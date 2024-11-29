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
#include "sdb.h"

#include "reg.h"
#include "debug.h"
#include <macro.h>
#include "hart_exec.h"
#include <readline/readline.h>
#include <readline/history.h>

static int is_batch_mode = false;

extern void init_regex();
extern void init_wp_pool();

/* We use the `readline' library to provide more flexibility to read from stdin. */
static char* rl_gets() {
  static char *line_read = NULL;

  if (line_read) {
    free(line_read);
    line_read = NULL;
  }

  line_read = readline("(npc sim) ");

  if (line_read && *line_read) {
    add_history(line_read);
  }

  return line_read;
}

static int cmd_c(char *args) {
  hart_exec(-1);
  return 0;
}


static int cmd_q(char *args) {
  return -1;
}

static int cmd_help(char *args);

static int cmd_si(char *args) {
  int step_n = 0;
  if (args == NULL) {
    step_n = 1;
    Log("[default execute] si 1");
  }
  else {
    char *endptr;
    errno = 0;
    step_n = strtol(args, &endptr, 10); // convert string to decimal number(10)
    // converted number over range 
    if((errno == ERANGE && (step_n == LONG_MAX || step_n == LONG_MIN)) || (errno != 0 && step_n == 0)) {
      perror("strtol");
      Log("Error occur in convert si command's args to decimal number, perhaps enter a number out of 'long int' range.");
      return 0;
    }
    // args start with character which cannot convert to number, so endptr stop at the head of args
    if(endptr == args) {
      Log("No digits were found in args.\nUsage: si [N]\nAnd N must be a decimal number.");
      return 0;
    }
    // enter 0 or negtive number
    if(step_n <= 0) {
      Log("Please enter a positive number.");
      return 0;
    }
    // strtol successfully
    Log("[execute] si %d", step_n);
  }

  // TODO: support execute N instructions
  hart_exec(1);

  return 0;
}

static int cmd_info(char *args) {
  if (args == NULL) {
    Log("Usage: \n\tinfo r : print register state. \n\tinfo w : print watchpoint message");
    return 0;
  }
  if(args[0] == 'r'){
    dump_all_reg();
  }
  else if (args[0] == 'w') {
	// TODO:
    info_watchpoint();
  }
  else if (args[0] == 'i') {
    if(args[1] == 'r') {
      display_IRStatus();
    }
  }
  else {
    Log("Unknown argument '%s'", args);
    Log("Usage: \n\tinfo r : print register state. \n\tinfo w : print watchpoint message");
  }
  return 0;
}

static int cmd_x(char *args) {
  if (args == NULL) {
    Log("Usage: x N EXPR");
    return 0;
  }
  char *n_byte_arg = NULL;
  long n_byte;
  char *start_addr_expr = NULL;
  word_t start_addr; // long type in my machine is 8-byte size, which is enough to deliver to paddr_t(uint32_t) addr argument
  
  bool success;

  n_byte_arg = strtok_r(args, " ", &start_addr_expr);
  if(n_byte_arg == NULL || start_addr_expr == NULL) {
    Log("Usage: x N EXPR");
    return 0;
  }
  start_addr = expr(start_addr_expr, &success);
  if (success == false) {
    Log("display memory get bad expression");
    return 0;
  }

  char *endptr_1;
  errno = 0;
  // byte number printed
  n_byte = strtol(n_byte_arg, &endptr_1, 10);
  if(endptr_1 == n_byte_arg) {
    Log("No digits were found in args.\nUsage: x N EXPR\nAnd N must be a decimal number.");
    return 0;
  }
  // enter 0 or negtive number
  if(n_byte <= 0) {
    Log("Usage: x N EXPR\nAnd N must be positive number.");
    return 0;
  }

  // if (!in_pmem(start_addr)) {
  //   Log("address = " FMT_PADDR " is out of bound of pmem [" FMT_PADDR ", " FMT_PADDR "]",
  //     (paddr_t)start_addr, (paddr_t)CONFIG_MBASE, (paddr_t)CONFIG_MBASE + CONFIG_MSIZE - 1);
  //   return 0;
  // }

  // for(int i = 0; i < n_byte; i++)
  //   printf("0x%.*lx\t", 2, paddr_read(start_addr+i, 1));
  printf("\n");

  return 0;
}

static int cmd_p(char *args) {
  bool success;
  word_t result_val = expr(args, &success);
  printf("EXPR = %lu (0x%lx)\n", result_val, result_val);
  Log("success return : %s", (success == 1) ? "true" : "false");
  return 0;
}

static int cmd_w(char *args) {
  if (args == NULL) {
    Log("Usage: w EXPR");
    return 0;
  }
  bool success;
  WP *get_wp = new_wp();
  strcpy(get_wp->expression, args);
  get_wp->old_val = expr(args, &success);
  if (success == false) {
    Log("watchpoint %d get bad expression", get_wp->NO);
    free_wp(get_wp);
  }
  return 0;
}

static int cmd_d(char *args) {
  char *endptr;
  errno = 0;
  // byte number printed
  int delete_watchpoint_NO = strtol(args, &endptr, 10);
  if(endptr == args) {
    Log("No digits were found in args.\nUsage: d N\nAnd N must be a positive decimal number.");
    return 0;
  }
  delete_wp_by_NO(delete_watchpoint_NO);
  return 0;
}

static struct {
  const char *name;
  const char *description;
  int (*handler) (char *);
} cmd_table [] = {
  { "help", "Display informations about all supported commands", cmd_help },
  { "c", "Continue the execution of the program", cmd_c },
  { "q", "Exit NPC SIM", cmd_q },
  { "si", "Step execute instruction", cmd_si},
  { "info", "Print register state or watchpoint message", cmd_info},
  { "x", "Print N byte memory with expression as start address", cmd_x},
  { "p", "Evaluate EXPR", cmd_p},
  { "w", "Set EXPR expression as a watchpoint", cmd_w},
  { "d", "Delete a watchpoint by a N number", cmd_d},

  /* TODO: Add more commands */

};

#define NR_CMD ARRLEN(cmd_table)

static int cmd_help(char *args) {
  /* extract the first argument */
  char *arg = strtok(NULL, " ");
  int i;

  if (arg == NULL) {
    /* no argument given */
    for (i = 0; i < NR_CMD; i ++) {
      printf("%s - %s\n", cmd_table[i].name, cmd_table[i].description);
    }
  }
  else {
    for (i = 0; i < NR_CMD; i ++) {
      if (strcmp(arg, cmd_table[i].name) == 0) {
        printf("%s - %s\n", cmd_table[i].name, cmd_table[i].description);
        return 0;
      }
    }
    printf("Unknown command '%s'\n", arg);
  }
  return 0;
}

void sdb_set_batch_mode() {
  is_batch_mode = true;
}

void sdb_mainloop() {
  if (is_batch_mode) {
    cmd_c(NULL);
    return;
  }

  for (char *str; (str = rl_gets()) != NULL; ) {
    char *str_end = str + strlen(str);

    /* extract the first token as the command */
    char *cmd = strtok(str, " ");
    if (cmd == NULL) { continue; }

    /* treat the remaining string as the arguments,
     * which may need further parsing
     */
    char *args = cmd + strlen(cmd) + 1;
    if (args >= str_end) {
      args = NULL;
    }

#ifdef CONFIG_DEVICE
    extern void sdl_clear_event_queue();
    sdl_clear_event_queue();
#endif

    int i;
    for (i = 0; i < NR_CMD; i ++) {
      if (strcmp(cmd, cmd_table[i].name) == 0) {
        if (cmd_table[i].handler(args) < 0) { 
          Log("Exit NPC SIM");
		      sim_state.state = SIM_QUIT;
          return; 
        }
        break;
      }
    }

    if (i == NR_CMD) { printf("Unknown command '%s'\n", cmd); }
  }
}

void init_sdb() {
  /* Compile the regular expressions. */
  init_regex();

  /* Initialize the watchpoint pool. */
  init_wp_pool();
}
