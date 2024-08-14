#ifndef __UTILS_H__
#define __UTILS_H__

#include "common.h"

// ------------ state -----------
enum { SIM_RUNNING, SIM_STOP, SIM_END, SIM_ABORT, SIM_QUIT };

typedef struct {
  int state;
  vaddr_t halt_pc;
  word_t halt_ret;
} SIMState;

extern SIMState sim_state;

uint64_t get_time();

// ----------- log -----------

#define ANSI_FG_BLACK   "\33[1;30m"
#define ANSI_FG_RED     "\33[1;31m"
#define ANSI_FG_GREEN   "\33[1;32m"
#define ANSI_FG_YELLOW  "\33[1;33m"
#define ANSI_FG_BLUE    "\33[1;34m"
#define ANSI_FG_MAGENTA "\33[1;35m"
#define ANSI_FG_CYAN    "\33[1;36m"
#define ANSI_FG_WHITE   "\33[1;37m"
#define ANSI_BG_BLACK   "\33[1;40m"
#define ANSI_BG_RED     "\33[1;41m"
#define ANSI_BG_GREEN   "\33[1;42m"
#define ANSI_BG_YELLOW  "\33[1;43m"
#define ANSI_BG_BLUE    "\33[1;44m"
#define ANSI_BG_MAGENTA "\33[1;35m"
#define ANSI_BG_CYAN    "\33[1;46m"
#define ANSI_BG_WHITE   "\33[1;47m"
#define ANSI_NONE       "\33[0m"

#define ANSI_FMT(str, fmt) fmt str ANSI_NONE

#define log_write(...) \
  do { \
    extern FILE* log_fp; \
    extern bool log_enable(); \
    if (log_enable()) { \
      fprintf(log_fp, __VA_ARGS__); \
      fflush(log_fp); \
    } \
  } while (0)

#define _Log(...) \
  do { \
    printf(__VA_ARGS__); \
    log_write(__VA_ARGS__); \
  } while (0)

// ------------ useful macro --------------
// #define ARRLEN(arr) (int)(sizeof(arr) / sizeof(arr[0]))

// #define concat_temp(x, y) x ## y
// #define concat(x, y) concat_temp(x, y)
// #define concat3(x, y, z) concat(concat(x, y), z)
// #define concat4(x, y, z, w) concat3(concat(x, y), z, w)
// #define concat5(x, y, z, v, w) concat4(concat(x, y), z, v, w)

// #define CHOOSE2nd(a, b, ...) b
// #define MUX_WITH_COMMA(contain_comma, a, b) CHOOSE2nd(contain_comma a, b)
// #define MUX_MACRO_PROPERTY(p, macro, a, b) MUX_WITH_COMMA(concat(p, macro), a, b)
// // define placeholders for some property
// #define __P_DEF_0  X,
// #define __P_DEF_1  X,
// #define __P_ONE_1  X,
// #define __P_ZERO_0 X,
// // define some selection functions based on the properties of BOOLEAN macro
// #define MUXDEF(macro, X, Y)  MUX_MACRO_PROPERTY(__P_DEF_, macro, X, Y)
// #define ISDEF(macro) MUXDEF(macro, 1, 0)
// #define __IGNORE(...)
// #define __KEEP(...) __VA_ARGS__
// // keep the code if a boolean macro is defined
// #define IFDEF(macro, ...) MUXDEF(macro, __KEEP, __IGNORE)(__VA_ARGS__)

// #define BITMASK(bits) ((1ull << (bits)) - 1)
// #define BITS(x, hi, lo) (((x) >> (lo)) & BITMASK((hi) - (lo) + 1)) // similar to x[hi:lo] in verilog

// #if !defined(likely)
// #define likely(cond)   __builtin_expect(cond, 1)
// #define unlikely(cond) __builtin_expect(cond, 0)
// #endif

#endif


