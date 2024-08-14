#ifndef __FTRACE_H__
#define __FTRACE_H__

#ifdef CONFIG_FTRACE

/* -------------------------------- ELF ANALYSIS -------------------------------- */
typedef struct symbolNode *symbol_link;
struct symbolNode {
    symbol_link left;
    symbol_link right;
    uint64_t value;
    uint64_t size;
    char name[128];
};

extern symbol_link root_symbol_bst;

char *search_symbol(symbol_link p, vaddr_t addr);

/* -------------------------------- FTRACE -------------------------------- */
typedef enum jump_type {call_type, ret_type} jump_T;

typedef struct ftraceLink *link_ftrace;
struct ftraceLink {
  link_ftrace next;
  jump_T jtype;
  uint16_t depth;
  vaddr_t pc;
  vaddr_t target;
  char func_name[128];
};

link_ftrace make_ftracenode(jump_T jtype, vaddr_t pc, vaddr_t target, char *func_name);

void insert_ftracelink(link_ftrace p);

void traverse_ftracelink();

#endif

#endif
