#include "reg.h"
#include "debug.h"

static struct {
  uint64_t int_regfile[96];
  uint64_t fp_regfile[64];
} hart_physical_regfile = {{0}, {0}};

// sync write physical register file to sim env
// extern "C" void write_

uint64_t read_gpr(int index) {
	Assert((index >= 0 && index < 32), "Illegal gpr index, RISCV-64 support 0~31 gpr");
	// return cpu_gpr[index];
}

const char *regs[] = {
  "$0", "ra", "sp", "gp", "tp", "t0", "t1", "t2",
  "s0", "s1", "a0", "a1", "a2", "a3", "a4", "a5",
  "a6", "a7", "s2", "s3", "s4", "s5", "s6", "s7",
  "s8", "s9", "s10", "s11", "t3", "t4", "t5", "t6"
};

/*
word_t reg_str2val(const char *s, bool *success) {
  for (int i = 0; i < 32; i++) {
    if (strcmp(regs[i], s) == 0) {
      *success = true;
      return cpu.gpr[i];
    }
  }
  if (strcmp("pc", s) == 0) {
    *success = true;
    return cpu.pc;
  }
  *success = false;
  return 0;
}
*/


