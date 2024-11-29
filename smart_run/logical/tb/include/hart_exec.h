#ifndef __HART_EXEC_H__
#define __HART_EXEC_H__
#include "common.h"

/* ------------------ simulation ------------------ */
void tick_step_dump();

void smartrun_tb_reset();

void sim_init();

void sim_exit();

// Message print when Assert fail
void assert_fail_msg();

void display_IRStatus();

// npc execute N step
void execute();

void hart_exec(uint64_t inst_num);

#endif