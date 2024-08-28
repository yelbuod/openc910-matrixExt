#include "common.h"
#include "reg.h"
#include "debug.h"
#include "difftest.h"
#include "hart_exec.h"
#include "utils.h"
#include "sdb.h"
#include <macro.h>

/* ------------------ simulation ------------------ */
VerilatedContext* contextp = NULL;
VerilatedVcdC* tfp = NULL;
static Vtop *top;
static int is_batch_mode = false;

void tick_step_dump() {
  top->clk = !top->clk;
  top->eval();
  contextp->timeInc(1);
#ifdef CONFIG_WAVETRACE
  tfp->dump(contextp->time());
#endif
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
#ifdef CONFIG_WAVETRACE
  Log("Wave dump: %s", ANSI_FMT("ON", ANSI_FG_GREEN));
  Log("Remember to turn off this before run a Large program! ");

  tfp = new VerilatedVcdC;
  top->trace(tfp, 0);
  tfp->open("dump.vcd");
#endif
  // clk & reset init
  top->clk = 0;
  smartrun_tb_reset();
}

void sim_exit() {
  tick_step_dump();
#ifdef CONFIG_WAVETRACE
  tfp->close();
#endif
}

/* ------------------ execute ------------------ */

void assert_fail_msg() {
	// dump_gpr();
}

extern "C" void ebreak(uint64_t pc) {
  sim_state.state = SIM_END;
  sim_state.halt_pc = pc;
  sim_state.halt_ret = read_gpr(10);
}

extern "C" void invalid(uint64_t pc) {
  sim_state.state = SIM_ABORT;
  sim_state.halt_pc = pc;
  sim_state.halt_ret = -1;
}

extern "C" void illegal(uint64_t pc) {
  sim_state.state = SIM_ABORT;
  sim_state.halt_pc = pc;
  sim_state.halt_ret = -1;

  // uint32_t temp[2];
  // pmem_read(pc, temp[0]);
  // pmem_read(pc, temp[1]);

  // uint8_t *p = (uint8_t *)temp;
  // printf("invalid opcode(PC = " FMT_WORD "):\n"
  //     "\t%02x %02x %02x %02x %02x %02x %02x %02x ...\n"
  //     "\t%08x %08x...\n",
  //     pc, p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7], temp[0], temp[1]);

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
  uint64_t retire_pc
){
  
  if(!is_batch_mode) { // no batch mode, single instruction step then STOP
    Log("[Hart] Instruction of PC 0x%08lx retired", retire_pc);
    Log("[Simulation] single step mode: STOP");
    sim_state.state = SIM_STOP;
  }
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
      // dump_gpr();
      printf("QUIT SIMULATION\n");
      // TODO
  }
}	