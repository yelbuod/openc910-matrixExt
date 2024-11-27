#include "common.h"
#include "reg.h"
#include "debug.h"
#include "difftest.h"
#include "hart_exec.h"
#include "utils.h"
#include "sdb.h"
#include <macro.h>
#define ENABLE_FST

/* ------------------ simulation ------------------ */
VerilatedContext* contextp = NULL;
#ifdef ENABLE_FST
VerilatedFstC* tfp = NULL;
#else
VerilatedVcdC* tfp = NULL;
#endif
static Vtop *top;
static int is_batch_mode = false;

void tick_step_dump() {
  top->clk = !top->clk;
  top->eval();
  contextp->timeInc(1);
// #ifdef CONFIG_WAVETRACE
  tfp->dump(contextp->time());
// #endif
}

void cycle_step() {
  tick_step_dump(); // clk high
  tick_step_dump(); // clk down
}

void smartrun_tb_reset() {
  printf("------------------ reset 20 cycle ------------------\n");
  for(int i = 0; i < 20; i++) {
    cycle_step();
  }
}

void sim_init() {
  contextp = new VerilatedContext;
  top = new Vtop;
  contextp->traceEverOn(true);
// #ifdef CONFIG_WAVETRACE
  Log("Wave dump: %s", ANSI_FMT("ON", ANSI_FG_GREEN));
  Log("Remember to turn off this before run a Large program! ");

#ifdef ENABLE_FST
  tfp = new VerilatedFstC;
  top->trace(tfp, 0);
  tfp->open("dump.fst");
#else
  tfp = new VerilatedVcdC; 
  top->trace(tfp, 0);
  tfp->open("dump.vcd");
#endif

// #endif

  // clk & reset init
  top->clk = 0;
  smartrun_tb_reset();
}

void sim_exit() {
  tick_step_dump();
// #ifdef CONFIG_WAVETRACE
  tfp->close();
// #endif
}

/* ------------------ execute ------------------ */

void assert_fail_msg() {
	dump_all_reg();
}

// extern "C" void ebreak(uint64_t pc) {
//   sim_state.state = SIM_END;
//   sim_state.halt_pc = pc;
//   sim_state.halt_ret = read_gpr(10);
// }

// extern "C" void invalid(uint64_t pc) {
//   sim_state.state = SIM_ABORT;
//   sim_state.halt_pc = pc;
//   sim_state.halt_ret = -1;
// }

extern "C" void illegal(
  uint32_t ir_decd_idx,
  uint32_t opcode
) {
  sim_state.state = SIM_ABORT;
  sim_state.halt_pc = 0;
  sim_state.halt_ret = -1;

  printf("invalid opcode:"
      "\t%08x at IR Decoder %d\n",
      opcode, ir_decd_idx);

  // printf("There are two cases which will trigger this unexpected exception:\n"
  //     "1. The instruction at PC = " FMT_WORD " is not implemented.\n"
  //     "2. Something is implemented incorrectly.\n", pc);
  // printf("Find this PC(" FMT_WORD ") in the disassembling result to distinguish which case it is.\n\n", pc);
  // printf(ANSI_FMT("If it is the first case, see\nriscv-64 manual\nfor more details.\n\n"
  //       "If it is the second case, remember:\n"
  //       "* The machine is always right!\n"
  //       "* Every line of untested code is always wrong!\n\n", ANSI_FG_RED));
}

extern "C" void hart_commitInst(
  uint32_t retire_idx,
  uint64_t retire_pc
){
  if(!is_batch_mode) { // no batch mode, single instruction step then STOP
    Log("[Hart] Instruction at PC 0x%08lx retired (index%d)", retire_pc, retire_idx);
    if(sim_state.state != SIM_STOP) {
      Log("[Simulation] single step mode: STOP");
      sim_state.state = SIM_STOP;
    }
  }
  sync_hart_pc(retire_pc);
}

static struct {
  uint8_t inst_pipeInst_vld;

  union {
    struct {
      unsigned int val0 : 7;  // 第0个7-bit数
      unsigned int val1 : 7;  // 第1个7-bit数
      unsigned int val2 : 7;  // 第2个7-bit数
      unsigned int val3 : 7;  // 第3个7-bit数
    } bitfield;
    uint32_t wordfield;
  } renamePhyRegs;

  union {
    struct {
      unsigned int val0 : 4;  // 第0个4-bit数
      unsigned int val1 : 4;  // 第1个4-bit数
      unsigned int val2 : 4;  // 第2个4-bit数
      unsigned int val3 : 4;  // 第3个4-bit数
      unsigned int val4 : 4;  // 第4个4-bit数
      unsigned int val5 : 4;  // 第5个4-bit数
    } bitfield;
    uint32_t wordfield;
  } dependencies;
} IRStatus;

extern "C" void hart_IRCtrlStatSync(
  const svLogicVecVal* instAndPipeInstVld, // 2 * 4-bit = 8-bit
){
  IRStatus.inst_pipeInst_vld = *(uint8_t*)instAndPipeInstVld;
}

extern "C" void hart_IRDpStatusSync(
  const svLogicVecVal* renameStatInstPack, // 4 * 7-bit = 28-bit
  const svLogicVecVal* depInsideInstPack // 6 * 4-bit = 24-bit

){
  IRStatus.renamePhyRegs.wordfield = *(uint32_t*)renameStatInstPack;
  IRStatus.dependencies.wordfield = *(uint32_t*)depInsideInstPack;

  // uint8_t* buf;
  // buf = (uint8_t*)depInsideInstPack;
  // for(int i = 0; i < 4; i++)
  //   printf("0x%02x", buf[i]);
  // printf("\n");

  // uint8_t buf_val;
  // for(int i = 0; i < 4; i++) {
  //   buf_val = *((uint8_t*)(renameStatInstPack+(i*7))) & 0x7F;
  //   printf("0x%02x", buf_val);
  // }
  // printf("\n");
}

// traverse all watchpoint elements in head link array
void WP_trigcheck() {
  bool trigger = traverse_check_trigger();
  if (trigger == true) {
    sim_state.state = SIM_STOP;
  }
}

void execute() {
  while(1) {
    /* cycle execute */
    cycle_step();
    WP_trigcheck();
    if (sim_state.state != SIM_RUNNING) break;
  }
}

void hart_exec(uint64_t inst_num) {
  switch (sim_state.state) {
    case SIM_END: case SIM_ABORT:
      printf("Program execution has ended. To restart the program, exit NPC sdb and run again.\n");
      return;
    default: sim_state.state = SIM_RUNNING;
  }

  if(inst_num == uint64_t(-1)) 
    is_batch_mode = true; // "continue" command, batch mode turn on

  execute();

  switch(sim_state.state) {
    case SIM_RUNNING: sim_state.state = SIM_STOP; break;

    case SIM_END: case SIM_ABORT:
      Log("npc: %s at pc = " FMT_WORD,
       (sim_state.state == SIM_ABORT ? ANSI_FMT("ABORT", ANSI_FG_RED) :
        (sim_state.halt_ret == 0 ? ANSI_FMT("HIT GOOD TRAP", ANSI_FG_GREEN) :
          ANSI_FMT("HIT BAD TRAP", ANSI_FG_RED))),
        sim_state.halt_pc);
    // fall through
    case SIM_QUIT:
      dump_all_reg();
      printf("QUIT SIMULATION\n");
      // TODO
  }
}	