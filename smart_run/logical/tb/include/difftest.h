#ifndef __DIFFTEST_H__
#define __DIFFTEST_H__

#include "common.h"

#ifdef CONFIG_DIFFTEST

enum { DIFFTEST_TO_DUT, DIFFTEST_TO_REF };
void difftest_skip_ref();
void init_difftest(char *ref_so_file, long img_size, int port);
void difftest_step(vaddr_t pc);
#endif

#endif