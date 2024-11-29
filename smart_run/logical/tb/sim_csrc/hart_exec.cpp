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
  union {
    struct {
      unsigned int inst3 : 1;  // 第3个1-bit inst valid (low space)
      unsigned int inst2 : 1;  // 第2个1-bit inst valid
      unsigned int inst1 : 1;  // 第1个1-bit inst valid
      unsigned int inst0 : 1;  // 第0个1-bit inst valid
      unsigned int pipeinst3 : 1;  // 第3个1-bit pipedown inst valid
      unsigned int pipeinst2 : 1;  // 第2个1-bit pipedown inst valid
      unsigned int pipeinst1 : 1;  // 第1个1-bit pipedown inst valid
      unsigned int pipeinst0 : 1;  // 第0个1-bit pipedown inst valid (high space)
    } bitfield;    
    uint8_t bytefield;
  } inst_pipeInst_vld;

  struct {
      uint32_t inst3;  // 第0个32-bit inst 
      uint32_t inst2;  // 第1个32-bit inst 
      uint32_t inst1;  // 第2个32-bit inst 
      uint32_t inst0;  // 第3个32-bit inst 
  } instPacket;

  union {
    struct {
      unsigned int inst3 : 7;  // 第0个7-bit rename phy reg
      unsigned int inst2 : 7;  // 第1个7-bit rename phy reg
      unsigned int inst1 : 7;  // 第2个7-bit rename phy reg
      unsigned int inst0 : 7;  // 第3个7-bit rename phy reg
    } bitfield;
    uint32_t wordfield;
  } renamePhyRegs;

  union {
    struct {
      unsigned int inst23 : 4;  // 第5个4-bit inst dependency (low)
      unsigned int inst13 : 4;  // 第4个4-bit inst dependency
      unsigned int inst12 : 4;  // 第3个4-bit inst dependency
      unsigned int inst03 : 4;  // 第2个4-bit inst dependency
      unsigned int inst02 : 4;  // 第1个4-bit inst dependency
      unsigned int inst01 : 4;  // 第0个4-bit inst dependency (high)
    } bitfield;
    uint32_t wordfield;
  } dependencies;
} IRStatus;

void display_IRStatus() {
    printf("IR inst valid: \n");
    printf("\tinst0: %u, inst1: %u, inst2: %u, inst3: %u\n",
           IRStatus.inst_pipeInst_vld.bitfield.inst0,
           IRStatus.inst_pipeInst_vld.bitfield.inst1,
           IRStatus.inst_pipeInst_vld.bitfield.inst2,
           IRStatus.inst_pipeInst_vld.bitfield.inst3);
    printf("IR pipedown inst valid: \n");
    printf("\tinst0: %u, inst1: %u, inst2: %u, inst3: %u\n",
           IRStatus.inst_pipeInst_vld.bitfield.pipeinst0,
           IRStatus.inst_pipeInst_vld.bitfield.pipeinst1,
           IRStatus.inst_pipeInst_vld.bitfield.pipeinst2,
           IRStatus.inst_pipeInst_vld.bitfield.pipeinst3);

    printf("IR inst packet opcode: \n");
    printf("\tinst0: %08x, inst1: %08x, inst2: %08x, inst3: %08x\n", 
           IRStatus.instPacket.inst0,
           IRStatus.instPacket.inst1,
           IRStatus.instPacket.inst2,
           IRStatus.instPacket.inst3);

    printf("IR inst rename physical regs: \n");
    printf("\tinst0: %02x, inst1: %02x, inst2: %02x, inst3: %02x\n",
           IRStatus.renamePhyRegs.bitfield.inst0,
           IRStatus.renamePhyRegs.bitfield.inst1,
           IRStatus.renamePhyRegs.bitfield.inst2,
           IRStatus.renamePhyRegs.bitfield.inst3);

    printf("IR inst packet dependencies: \n");
    printf("\tinst01: %01x, inst02: %01x, inst03: %01x, inst12: %01x, inst13: %01x, inst23: %01x\n",
           IRStatus.dependencies.bitfield.inst01,
           IRStatus.dependencies.bitfield.inst02,
           IRStatus.dependencies.bitfield.inst03,
           IRStatus.dependencies.bitfield.inst12,
           IRStatus.dependencies.bitfield.inst13,
           IRStatus.dependencies.bitfield.inst23);
}

extern "C" void hart_IRCtrlStatSync(
  const svLogicVecVal* instAndPipeInstVld // 2 * 4-bit = 8-bit
){
  uint8_t buf  = *(uint8_t*)instAndPipeInstVld;
  // printf("hart_IRCtrlStatSync inst valid info buf: %02x\n", buf);
  IRStatus.inst_pipeInst_vld.bytefield = buf;
  // printf("IR inst valid: ");
  // printf("inst0: %u, inst1: %u, inst2: %u, inst3: %u\n",
  //         IRStatus.inst_pipeInst_vld.bitfield.inst0,
  //         IRStatus.inst_pipeInst_vld.bitfield.inst1,
  //         IRStatus.inst_pipeInst_vld.bitfield.inst2,
  //         IRStatus.inst_pipeInst_vld.bitfield.inst3);
}

extern "C" void hart_IRDpStatusSync(
  const svLogicVecVal* inst0,
  const svLogicVecVal* inst1,
  const svLogicVecVal* inst2,
  const svLogicVecVal* inst3,
  const svLogicVecVal* renameStatInstPack, // 4 * 7-bit = 28-bit
  const svLogicVecVal* depInsideInstPack // 6 * 4-bit = 24-bit
){
  IRStatus.instPacket.inst0 = *(uint32_t*)inst0;
  IRStatus.instPacket.inst1 = *(uint32_t*)inst1;
  IRStatus.instPacket.inst2 = *(uint32_t*)inst2;
  IRStatus.instPacket.inst3 = *(uint32_t*)inst3;
  
  // printf("hart_IRDpStatusSync inst0 opcode: %08x\n", IRStatus.instPacket.inst0);
  IRStatus.renamePhyRegs.wordfield = *(uint32_t*)renameStatInstPack;
  IRStatus.dependencies.wordfield = *(uint32_t*)depInsideInstPack;
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
  else 
    is_batch_mode = false; // maybe continue break then wanna "si" (single step)

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