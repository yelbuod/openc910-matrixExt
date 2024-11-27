#include "reg.h"
#include "debug.h"

#define INT_PHY_REG_NUM 96
#define FP_PHY_REG_NUM 64
#define INT_ARCH_REG_NUM 32
#define FP_ARCH_REG_NUM 32

static uint64_t hart_pc = 0;

static struct {
  uint64_t int_regfile[INT_PHY_REG_NUM];
  uint64_t fp_regfile[FP_PHY_REG_NUM];
} hart_physical_regfile = {{0}, {0}};

static struct {
  int int_renameTable[INT_ARCH_REG_NUM];
  int fp_renameTable[FP_ARCH_REG_NUM];
} hart_rename_table = {{0}, {0}};
 
// sync write physical register file to sim env
extern "C" void write_int_phyRegfile(
  uint64_t idx,
  uint64_t value
) {
  Assert(idx < INT_PHY_REG_NUM, "write int regifile index out of range");
  hart_physical_regfile.int_regfile[idx] = value;
}

extern "C" void write_fp_phyRegfile(
  uint64_t idx,
  uint64_t value
) {
  Assert(idx < FP_PHY_REG_NUM, "write float-point regifile index out of range");
  hart_physical_regfile.fp_regfile[idx] = value;
}

extern "C" void sync_int_rename_table(
  uint32_t arch_regIdx,
  uint32_t phy_regIdx
) {
  Assert((arch_regIdx < INT_ARCH_REG_NUM && arch_regIdx > 0), "sync int rename table arch index out of range");
  Assert((phy_regIdx < INT_PHY_REG_NUM && phy_regIdx > 0), "sync int rename table phy index out of range");
  hart_rename_table.int_renameTable[arch_regIdx] = phy_regIdx;
}

extern "C" void sync_fp_rename_table(
  uint32_t arch_regIdx,
  uint32_t phy_regIdx
) {
  Assert((arch_regIdx < FP_ARCH_REG_NUM && arch_regIdx >= 0), "sync fp rename table arch index out of range");
  Assert((phy_regIdx < FP_PHY_REG_NUM && phy_regIdx >= 0), "sync fp rename table phy index out of range");
  hart_rename_table.fp_renameTable[arch_regIdx] = phy_regIdx;
}

void sync_hart_pc(uint64_t pc) {
  hart_pc = pc;
}

uint64_t read_hart_reg(int index, bool fp) {
	Assert((index >= 0 && index < 32), "Illegal gpr or fpr index, RISCV-64 support 0~31 gpr and fpr");
	int phy_regIdx;
  if(!fp) {
    phy_regIdx = hart_rename_table.int_renameTable[index];
    return hart_physical_regfile.int_regfile[phy_regIdx];
  }
  else {
    phy_regIdx = hart_rename_table.fp_renameTable[index];
    return hart_physical_regfile.fp_regfile[phy_regIdx];
  }
    
}

const char *int_regs[] = {
  "$0", "ra", "sp", "gp", "tp", "t0", "t1", "t2",
  "s0", "s1", "a0", "a1", "a2", "a3", "a4", "a5",
  "a6", "a7", "s2", "s3", "s4", "s5", "s6", "s7",
  "s8", "s9", "s10", "s11", "t3", "t4", "t5", "t6"
};

const char *fp_regs[] = {
"f0", "f1", "f2", "f3", "f4", "f5", "f6", "f7", 
"f8","f9", "f10", "f11", "f12", "f13", "f14", "f15", 
"f16", "f17", "f18", "f19", "f20", "f21", "f22", "f23", 
"f24", "f25", "f26", "f27", "f28", "f29", "f30", "f31"
};

uint64_t reg_str2val(const char *s, bool *success) {
  if (strcmp("pc", s) == 0) {
    *success = true;
    return hart_pc;
  }

  for (int i = 0; i < 32; i++) {
    if (strcmp(int_regs[i], s) == 0) {
      *success = true;
      return read_hart_reg(i, false);
    }
  }
  for (int i = 0; i < 32; i++) {
    if (strcmp(fp_regs[i], s) == 0) {
      *success = true;
      return read_hart_reg(i, true);
    }
  }
  // if (strcmp("pc", s) == 0) {
  //   *success = true;
  //   return cpu.pc;
  // }
  *success = false;
  return 0;
}

void dump_all_reg() {
  int i;
  for (i = 0; i < 32; i++) {
    printf("(x%d) %s = 0x%lx\n", i, int_regs[i], read_hart_reg(i, false));
  }
  
  printf("pc = 0x%lx\n", hart_pc);

  for (i = 0; i < 32; i++) {
    printf("(f%d) %s = 0x%lx\n", i, fp_regs[i], read_hart_reg(i, true));
  }
}
