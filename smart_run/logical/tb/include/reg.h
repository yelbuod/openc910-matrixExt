#ifndef __REG_H__
#define __REG_H__
#include "common.h"
#include "instTrace.h"

extern "C" void set_gpr_ptr(const svOpenArrayHandle r);

struct riscv64_cpu_regfile{
  union
  {
    uint64_t _64;
  } gpr[32];

  uint64_t pc;

  union
  {
    uint64_t _64;
  } fpr[32];
};




// Read register by index
uint64_t read_gpr(int index);

// Read register by register name(string)
word_t reg_str2val(const char *s, bool *success);

#endif