#include "common.h"
#include "difftest.h"
#include "hart_exec.h"
#include "reg.h"
#include "debug.h"
#include "macro.h"
#include "sdb.h"
#include "utils.h"

extern void sdb_set_batch_mode();
extern void init_log(const char *log_file);
extern void init_sdb();
extern void init_disasm(const char *triple);
extern void init_ftrace(const char *elfFile);

SIMState sim_state = { .state = SIM_STOP };

int is_exit_status_bad() {
  int good = (sim_state.state == SIM_END && sim_state.halt_ret == 0) ||
    (sim_state.state == SIM_QUIT);
  return !good;
}

static char *diff_so_file = NULL;
static char *log_file = NULL;
static char *elf_file = NULL;
static int difftest_port = 1234; // for qemu debug port

static int parse_args(int argc, char *argv[]) {
  const struct option table[] = {
    {"batch"    , no_argument      , NULL, 'b'},
    {"diff"     , required_argument, NULL, 'd'},
    {"log"      , required_argument, NULL, 'l'},
    {"elf"      , required_argument, NULL, 'e'},
    {0          , 0                , NULL,  0 },
  };
  int o;
  while ( (o = getopt_long(argc, argv, "bd:l:e:", table, NULL)) != -1) {
    switch (o) {
      case 'b': sdb_set_batch_mode(); break;
      case 'l': log_file = optarg; break;
      case 'd': diff_so_file = optarg; break;
      case 'e': elf_file = optarg; break;
      default:
        printf("Usage: %s [OPTION...]\n\n", argv[0]);
        printf("\t-b,--batch                     run with batch mode\n");
        printf("\t-d,--diff=REF_SO               run DiffTest with reference REF_SO\n");
        printf("\t-l,--log=FILE                  output log to FILE\n");
        printf("\t-e,--elf=FILE                  input elf for ftrace analysis\n");
        printf("\n");
        exit(0);
    }
  }
  return 0;
}

int main(int argc, char *argv[]) {

  parse_args(argc, argv);

  init_log(log_file);

  sim_init();

  IFDEF(CONFIG_DIFFTEST, init_difftest(diff_so_file, img_size, difftest_port));

  init_sdb();

  IFDEF(CONFIG_ITRACE, init_disasm("riscv64-pc-linux-gnu"));

  sdb_mainloop();
  
  sim_exit();

  return is_exit_status_bad();
}
