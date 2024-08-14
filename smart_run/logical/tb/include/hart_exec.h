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

// npc execute one **step**
// each **step** may be at a Low or High Level of the NPC clock
// NPC will be stimulated in Low clock and response in the Rising edge when clock jumps from Low to High
void exec_once_cycle();

// npc execute N step
void execute();

void hart_exec(uint64_t inst_num);

#endif