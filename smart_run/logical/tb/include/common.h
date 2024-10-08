#ifndef __COMMON_H__
#define __COMMON_H__

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <assert.h>
#include <iostream>
#include <string.h>
#include <getopt.h>
#include "verilated.h"
#include "verilated_dpi.h"
#include "verilated_vpi.h"
#ifdef ENABLE_FST
#include <verilated_fst_c.h>
#else
#include <verilated_vcd_c.h>    // Trace file format header
#endif
#include "Vtop.h" // ../build_verilate/obj_dir/

#define FMT_WORD "0x%016lx"
#define FMT_PADDR "0x%08x"

typedef uint64_t word_t;
typedef word_t vaddr_t;
typedef uint32_t paddr_t;

#endif