#ifndef __SDB_H__
#define __SDB_H__

#include "common.h"
#include <limits.h>
#include <errno.h>

void sdb_set_batch_mode();
void sdb_mainloop();

typedef struct watchpoint {
  int NO;
  struct watchpoint *next;

  /* TODO: Add more members if necessary */
  word_t old_val; // 保存表达式旧值，用于比较
  char expression[65536]; // 保存表达式

} WP;

word_t expr(char *e, bool *success);
// watchpoint
WP* new_wp();
void free_wp(WP *wp);
bool traverse_check_trigger();
void delete_wp_by_NO(int number_of_wp);
void info_watchpoint();

#endif