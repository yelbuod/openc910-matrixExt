

TOPNAME = top 
VCDNAME = dump.vcd

WORK_DIR = $(shell pwd)

VERILATOR = verilator
VERILATOR_CFLAGS += --build -cc --exe \
				-Os -x-assign 0 -Wno-fatal --notiming 

#				--x-assign fast --x-initial fast --noassert

ifdef CONFIG_WAVETRACE
VERILATOR_CFLAGS += --trace
endif

# rules for verilator
LDFLAGS += -lreadline -ldl

#use to replace "%" to %, which is just as its name: remove_quote
#such as "true" to true, then can use in C code
remove_quote = $(patsubst "%",%,$(1))

# build verilator sim
BUILD_V_DIR = ./build_verilate
BUILD_V_OBJ_DIR = $(BUILD_V_DIR)/obj_dir
BUILD_V = $(BUILD_V_DIR)/$(TOPNAME)
BUILD_V_INC_PATH_REL := ./include/ $(BUILD_V_OBJ_DIR)
BUILD_V_INC_PATH = $(abspath $(BUILD_V_INC_PATH_REL))
BUILD_V_INCFLAGS = $(addprefix -I, $(BUILD_V_INC_PATH))
BUIlD_V_CFLAGS += $(BUILD_V_INCFLAGS)
$(shell mkdir -p $(BUILD_V_DIR))

# project source
BUILD_V_CSRCS = $(shell find $(abspath ./sim_csrc) -name "*.cpp" | grep -v "disasm.cpp")
SIM_FILELIST := $(SIM_FILELIST) -f ./sim_verilator.fl

# llvm for disasm
ifdef CONFIG_ITRACE
BUILD_V_DISASM_CSRCS = $(shell find $(abspath ./verilate_csrc) -name "disasm.cpp")
CXXFLAGS += $(shell llvm-config --cxxflags) -fPIE
LIBS += $(shell llvm-config --libs)

BUILD_V_CSRCS += $(BUILD_V_DISASM_CSRCS)
BUIlD_V_CFLAGS += $(CXXFLAGS)
LDFLAGS += $(LIBS)
endif
# llvm for disasm

$(BUILD_V): $(BUILD_V_CSRCS)
	@rm -rf $(BUILD_V_OBJ_DIR)
	$(VERILATOR) $(VERILATOR_CFLAGS) \
	--top-module $(TOPNAME) $(SIM_FILELIST) $^ \
	$(addprefix -CFLAGS , $(BUIlD_V_CFLAGS)) $(addprefix -LDFLAGS , $(LDFLAGS)) \
	-DTOP_NAME="\"V$(TOPNAME)\"" \
	--Mdir $(BUILD_V_OBJ_DIR) --exe -o $(abspath $(BUILD_V)) 

#-o $(abspath $(BUILD_V)) 

DIFF_NEMU_PATH = $(NEMU_HOME)/build/riscv64-nemu-interpreter-so
ARGS_DIFF = --diff=$(DIFF_NEMU_PATH)

override ARGS ?= --log=$(BUILD_V_DIR)/npc-log.txt --image=$(WORK_DIR)/default_dummy.bin
override ARGS += $(ARGS_DIFF)

run_verilator: $(BUILD_V) $(BUILD_V_INC_PATH)
	@$^ $(ARGS)

gdb_verilator: $(BUILD_V)
	@gdb --args $^ $(ARGS)

wave_verilated:
	gtkwave $(VCDNAME)

clean_verilated:
	rm -rf $(BUILD_V_DIR)

.PHONY: run_verilator gdb_verilator wave_verilated clean_verilated

.DEFAULT_GOAL = $(BUILD_V)
