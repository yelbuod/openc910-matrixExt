// for elf read
#include <elf.h>
#include <common.h>
#include <debug.h>
#include <ftrace.h>

#ifdef CONFIG_FTRACE

/* -------------------------------- ELF ANALYSIS -------------------------------- */

/* Binary tree builds a linker list of structures constructed by function name and its address, 
   making it easy to look up function names when a function call is encountered. */

symbol_link root_symbol_bst = NULL;

symbol_link make_symbol_node(uint64_t value, uint64_t size, char *name) {
    symbol_link p_sym = (symbol_link)malloc(sizeof(*p_sym));
    p_sym->left = p_sym->right = NULL;
    p_sym->value = value;
    p_sym->size = size;
    strncpy(p_sym->name, name, sizeof(p_sym->name));
    return p_sym;
}

symbol_link insert_symbol_link(symbol_link p, uint64_t value, uint64_t size, char *name) {
    if(p == NULL) 
        return make_symbol_node(value, size, name);
    if(p->value > value) 
        p->left = insert_symbol_link(p->left, value, size, name);
    else /* if(p->value <= value)  */
        p->right = insert_symbol_link(p->right, value, size, name);
    return p;
}

char *search_symbol(symbol_link p, vaddr_t addr) {
    if(p == NULL) 
        return NULL;
    // addr must < value + size, otherwise into another function
    if(addr < p->value+p->size && addr >= p->value)
        return p->name;
    else if(addr >= p->value+p->size)
        return search_symbol(p->right, addr);
    else
        return search_symbol(p->left, addr);
}

void traverse_symbol_link(symbol_link p) {
    if(p) {
        printf("(");
        printf("[0x%08lx, 0x%08lx]", p->value, p->value+p->size);
        traverse_symbol_link(p->left);
        traverse_symbol_link(p->right);
        printf(")");
    }
    else
        printf("()");
}

static void read_elf_header(const char *elfFile) {
  Elf64_Ehdr elf_header;
  // ELF64_Shdr elf_shdr[];
  Assert(elfFile, "elf file input is NULL");

  FILE *elfFile_p = fopen(elfFile, "rb");
  if(elfFile) {
    size_t readnum = fread(&elf_header, sizeof(elf_header), 1, elfFile_p);
    if(memcmp(elf_header.e_ident, ELFMAG, (long unsigned int)SELFMAG) != 0) {
      Assert(0, "Invalid elf file input. read %lu item.", readnum);
      fclose(elfFile_p);
    }
    else {
        // important! use "fseek" jump to the position of the sectin header in elf
        fseek(elfFile_p, elf_header.e_shoff, SEEK_SET); 

        const int shdr_num = elf_header.e_shnum;
        Elf64_Shdr elf_shdr[shdr_num];
        size_t read_shdr_num = fread(elf_shdr, sizeof(Elf64_Shdr), shdr_num, elfFile_p);

        uint64_t strtab_off = 0, strtab_size = 0;
        uint64_t symtab_off = 0, symtab_size = 0, symtab_entsize = 1;
        bool strtab_flag = false;
        bool symtab_flag = false;
        for(size_t i = 0; i < read_shdr_num; i++) {
            if(elf_shdr[i].sh_type == SHT_SYMTAB && symtab_flag == false) {
                symtab_off = elf_shdr[i].sh_offset;
                symtab_size = elf_shdr[i].sh_size;
                symtab_entsize = elf_shdr[i].sh_entsize;
                symtab_flag = true;
                printf("symtab offset: 0x%08lx; size: 0x%08lx; entsize: 0x%08lx\n", 
                   symtab_off, symtab_size, symtab_entsize);
                if(strtab_flag == true)
                    break;
            }
            if(elf_shdr[i].sh_type == SHT_STRTAB && strtab_flag == false) {
                strtab_off = elf_shdr[i].sh_offset;
                strtab_size = elf_shdr[i].sh_size;
                strtab_flag = true;
                printf("strtab offset: 0x%08lx\n", strtab_off);
                if(symtab_flag == true)
                    break;
            }
        }
        Assert(strtab_flag == true && symtab_flag == true, "cannot find symbol table and string table");
        // important! use "fseek" jump to the position of the symbol table in elf
        fseek(elfFile_p, symtab_off, SEEK_SET);
        const int sym_num = symtab_size / symtab_entsize;
        Elf64_Sym elf_sym[sym_num];
        size_t read_sym_num = fread(elf_sym, sizeof(Elf64_Sym), sym_num, elfFile_p);
        
        fseek(elfFile_p, strtab_off, SEEK_SET);
        char total_string[1280];
        size_t read_string_num = fread(total_string, sizeof(*total_string), strtab_size, elfFile_p);
        Assert(read_string_num != 0, "get string from strtab error"); 
        for(size_t i = 0; i < read_sym_num; i++) {
            // important! use macro "ELF64_ST_TYPE" to extract a type from an "st_info" value.
            if(ELF64_ST_TYPE(elf_sym[i].st_info)== STT_FUNC) {
                char *temp_name = total_string+elf_sym[i].st_name;
                printf("#%lu value: 0x%08lx; name: %s\n", i, elf_sym[i].st_value, temp_name);
                root_symbol_bst = insert_symbol_link(root_symbol_bst, elf_sym[i].st_value, elf_sym[i].st_size, temp_name);
            }
        } 
    }
  }
}

void init_ftrace(const char *elfFile) {
    read_elf_header(elfFile);
    // traverse_symbol_link(root_symbol_bst);
}

/* -------------------------------- ELF ANALYSIS -------------------------------- */


/* -------------------------------- FTRACE -------------------------------- */

link_ftrace head_ftracelink = NULL;

link_ftrace make_ftracenode(jump_T jtype, vaddr_t pc, vaddr_t target, char *func_name) {
  static uint16_t depth = 0;
  static bool more_deeper = false;
  link_ftrace p = (link_ftrace)malloc(sizeof(*p));
  p->jtype = jtype;
  if(more_deeper == false && jtype == call_type)
    more_deeper = true; // depth no change
  else if (more_deeper == true && jtype == ret_type)
    more_deeper = false; // depth no change
  else if (more_deeper == true && jtype == call_type)
    depth++;
  else if (more_deeper == false && jtype == ret_type)
    depth--;
  else 
    assert(0);

  p->depth = depth;
  p->pc = pc;
  p->target = target;
  strncpy(p->func_name, func_name, sizeof(p->func_name));
  return p;
}

void insert_ftracelink(link_ftrace p) {
  p->next = head_ftracelink;
  head_ftracelink = p;
}

void traverse_ftracelink() {
  link_ftrace p;
  for(p = head_ftracelink; p != NULL; p = p->next) {
    printf("0x%08lx: ", p->pc);
    const char * call_or_ret = (p->jtype == call_type) ? "call" : "ret ";
    printf("%*.s%s [%s", p->depth, "", call_or_ret, p->func_name);
    if(p->jtype == call_type)
      printf("@0x%08lx]\n", p->target);
    else 
      printf("]\n");
  }
}

/* -------------------------------- FTRACE -------------------------------- */


#endif