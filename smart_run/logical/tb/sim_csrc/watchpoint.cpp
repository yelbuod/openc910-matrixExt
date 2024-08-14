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
#include "debug.h"

#define NR_WP 32

static WP wp_pool[NR_WP] = {};
static WP *head = NULL, *free_ = NULL;

void init_wp_pool() {
  int i;
  for (i = 0; i < NR_WP; i ++) {
    wp_pool[i].NO = i;
    wp_pool[i].next = (i == NR_WP - 1 ? NULL : &wp_pool[i + 1]);
  }

  head = NULL;
  free_ = wp_pool;
}

/* TODO: Implement the functionality of watchpoint */
WP* new_wp() {
  if (free_ == NULL)
    assert(0);
  WP *get_free_wp = free_; // free_ 作为头元素指针，获取空闲监视点就每次返回头元素
  free_ = get_free_wp->next; // 头元素被分配，因此需要将 free_ 指向下一个元素，也就是 head->next
  get_free_wp->next = head; // 将分配出去的结构体加入 head （使用中）链表
  head = get_free_wp; 
  return get_free_wp;
}

void free_wp(WP *wp) {
  // 归还的wp从 head 链表中删除
  if (wp == head)
    head = wp->next;
  else {
    WP *temp;
    for (temp = head; temp; temp = temp->next)
      if (temp->next == wp)
        temp->next = wp->next;
  }
  // 归还到 free_ 链表
  wp->next = free_;
  free_ = wp;
}

bool traverse_check_trigger() {
  WP *temp;
  bool success;
  bool trigger = false;
  for (temp = head; temp; temp = temp->next) {
    word_t expr_eval = expr(temp->expression, &success);
    if (success == false) {
      Log("watchpoint %d get bad expression", temp->NO);
      continue;
    }
    else {
      if (expr_eval != temp->old_val) {
        trigger = true;
        printf("watchpoint %d: %s\n\n", temp->NO, temp->expression);
        printf("Old value = %lu(0x%lx)\nNew value = %lu(0x%lx)\n", temp->old_val, temp->old_val, expr_eval, expr_eval);
        temp->old_val = expr_eval;
      }
    }
  }
  return trigger;
}

void info_watchpoint() {
  printf("Num\tExpression\n");  
  WP *temp;
  for (temp = head; temp; temp = temp->next) {
    printf("%-3d\t%s\n", temp->NO, temp->expression);
  }
  return;
}

void delete_wp_by_NO(int number_of_wp) {
  WP *temp;
  for (temp = head; temp; temp = temp->next) {
    if (temp->NO == number_of_wp) {
      printf("Delete watchpoint %d\n", number_of_wp);
      free_wp(temp);
      return;
    }      
  }
  printf("watchpoint %d does not exist\n", number_of_wp);
  return;
}