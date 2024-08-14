
#include <dlfcn.h>

#include "difftest.h"
#include "reg.h"
#include "debug.h"

typedef void (*ref_difftest_memcpy_t)(paddr_t addr, void *buf, size_t n, bool direction);
ref_difftest_memcpy_t ref_difftest_memcpy = NULL;

typedef void (*ref_difftest_regcpy_t)(void *dut, bool direction);
ref_difftest_regcpy_t ref_difftest_regcpy = NULL;

typedef void (*ref_difftest_exec_t)(uint64_t n);
ref_difftest_exec_t ref_difftest_exec = NULL;

typedef void (*ref_difftest_raise_intr_t)(uint64_t NO);
ref_difftest_raise_intr_t ref_difftest_raise_intr = NULL;

typedef void (*ref_difftest_init_t)(int);

static bool is_skip_ref = false;
static int skip_dut_nr_inst = 0;

// this is used to let ref skip instructions which
// can not produce consistent behavior with NEMU
void difftest_skip_ref() {
  is_skip_ref = true;
  // If such an instruction is one of the instruction packing in QEMU
  // (see below), we end the process of catching up with QEMU's pc to
  // keep the consistent behavior in our best.
  // Note that this is still not perfect: if the packed instructions
  // already write some memory, and the incoming instruction in NEMU
  // will load that memory, we will encounter false negative. But such
  // situation is infrequent.
  skip_dut_nr_inst = 0;
}

// this is used to deal with instruction packing in QEMU.
// Sometimes letting QEMU step once will execute multiple instructions.
// We should skip checking until NEMU's pc catches up with QEMU's pc.
// The semantic is
//   Let REF run `nr_ref` instructions first.
//   We expect that DUT will catch up with REF within `nr_dut` instructions.
// void difftest_skip_dut(int nr_ref, int nr_dut) {
//   skip_dut_nr_inst += nr_dut;

//   while (nr_ref -- > 0) {
//     ref_difftest_exec(1);
//   }
// }

void init_difftest(char *ref_so_file, long img_size, int port) {
  assert(ref_so_file != NULL);

  void *handle;
  handle = dlopen(ref_so_file, RTLD_LAZY);
  assert(handle);

  ref_difftest_memcpy = (ref_difftest_memcpy_t) dlsym(handle, "difftest_memcpy");
  assert(ref_difftest_memcpy);

  ref_difftest_regcpy = (ref_difftest_regcpy_t) dlsym(handle, "difftest_regcpy");
  assert(ref_difftest_regcpy);

  ref_difftest_exec = (ref_difftest_exec_t) dlsym(handle, "difftest_exec");
  assert(ref_difftest_exec);

  ref_difftest_raise_intr = (ref_difftest_raise_intr_t) dlsym(handle, "difftest_raise_intr");
  assert(ref_difftest_raise_intr);

  ref_difftest_init_t ref_difftest_init = NULL;
  ref_difftest_init = (ref_difftest_init_t) dlsym(handle, "difftest_init");
  assert(ref_difftest_init);

  Log("Differential testing: %s", ANSI_FMT("ON", ANSI_FG_GREEN));
  Log("The result of every instruction will be compared with %s. "
      "This will help you a lot for debugging, but also significantly reduce the performance. "
      "If it is not necessary, you can turn it off in menuconfig.", ref_so_file);

  ref_difftest_init(port);
  // ref_difftest_memcpy(RESET_VECTOR, guest_to_host(RESET_VECTOR), img_size, DIFFTEST_TO_REF);
  // ref_difftest_regcpy(&cpu, DIFFTEST_TO_REF);
}

// bool isa_difftest_checkregs(CPU_state *ref_r, vaddr_t pc) {
//   // reg number is definitely 32 because this file is under isa/riscv64
//   for (int i = 0; i < 32; i++) {
//     if(ref_r->gpr[i] != cpu.gpr[i]) {
//       Log("%d gpr Differential test FAILED!", i);
//       return false;
//     }
//   }
//   if(ref_r->pc != cpu.pc)
//     return false;
//   return true;
// }

// static void checkregs(CPU_state *ref, vaddr_t pc) {
//   if (!isa_difftest_checkregs(ref, pc)) {
//     sim_state.state = SIM_ABORT;
//     sim_state.halt_pc = pc;
//     printf("--------------- NPC & NEMU State ---------------\n");
//     for (int i = 0; i < 32; i++) {
//       printf("NEMU gpr[%d]: %016lx\tNPC gpr[%d]: %016lx\n", i, ref->gpr[i], i, cpu.gpr[i]);
//     }
//     printf("NPC PC: %016lx\n", pc);
//     printf("NEMU PC: %016lx\n", ref->pc);
//   }
// }

// void difftest_step(vaddr_t pc) {
//   CPU_state ref_r;

//   if (is_skip_ref) {
//     // printf("skip at 0x%016lx, cpu.pc is 0x%016lx\n", pc, cpu.pc);
//     // to skip the checking of an instruction, just copy the reg state to reference design
//     ref_difftest_regcpy(&cpu, DIFFTEST_TO_REF);
//     is_skip_ref = false;
//     return;
//   }
//   // printf("NO skip at 0x%016lx\n", pc);
//   ref_difftest_exec(1);
//   ref_difftest_regcpy(&ref_r, DIFFTEST_TO_DUT);

//   checkregs(&ref_r, pc);
// }