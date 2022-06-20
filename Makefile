BUILD_DIR = ./build
OBJ_DIR = $(BUILD_DIR)/obj
CHISEL_BUILD_DIR=./chisel_out
TOPNAME = top
NXDC_FILES = constr/top.nxdc

include $(NVBOARD_HOME)/scripts/nvboard.mk

CXX = g++
CC = gcc
VSRCS=$(shell find $(abspath ./vsrc) -name "*.v")
CSRCS ?=
CSRC := $(shell find csrc/src -name "*.c")
CCSRC := $(shell find csrc/ -name "*.cpp" -or -name "*.cc")
OBJS=$(CSRC:%.c=$(OBJ_DIR)/%.o) #$(CCSRC:%.cpp=$(OBJ_DIR)/%.o)
INC_PATH := $(abspath ./csrc/include/)
SRC_AUTO_BIND=$(abspath $(BUILD_DIR)/auto_bind.cpp)
CFLAGS += $(addprefix -I, $(INC_PATH))  -MMD -Wall -Werror #-fsanitize=address
SDBLIB=$(abspath ./lib)/libsdb.a
CXXFLAGS += $(shell llvm-config --cxxflags)
LIBS += $(shell llvm-config --libs) -lreadline -ldl
VERILATING_FLAG = -W

DIFFTEST_SO = $(NEMU_HOME)/build/riscv64-nemu-interpreter-so

override ARGS += --diff=$(DIFFTEST_SO) #--diff=/home/zakia/ysyx-workbench/nemu/tools/spike-diff/build/riscv64-spike-so 
$(SRC_AUTO_BIND): $(NXDC_FILES)
	python $(NVBOARD_HOME)/scripts/auto_pin_bind.py $^ $@

test:
	mill -i __.test

verilog:
	$(call git_commit, "generate verilog")
	mkdir -p $(CHISEL_BUILD_DIR)
	mill -i __.test.runMain Elaborate -td $(CHISEL_BUILD_DIR)

help:
	mill -i __.test.runMain Elaborate --help

compile:
	mill -i __.compile

bsp:
	mill -i mill.bsp.BSP/install

reformat:
	mill -i __.reformat

checkformat:
	mill -i __.checkFormat

clean:
	-rm -rf $(BUILD_DIR)
	-rm -rf $(CHISEL_BUILD_DIR)

.PHONY: test verilog help compile bsp reformat checkformat clean nvboard sdb run gdb
$(OBJ_DIR)/%.o:%.c
	@echo + CC $<
	@mkdir -p $(dir $@)
	@$(CC) $(CFLAGS) -c -o $@ $<

# $(OBJ_DIR)/%.o:%.cpp
# 	@echo + CXX $<
# 	@mkdir -p $(dir $@)
# 	@echo $(CXX) $(CFLAGS) -fPIC -c -o $@ $<
# 	$(CXX) $(CFLAGS) -fPIC -c -o $@ $<
# 	$(call call_fixdep, $(@:.o=.d), $@)

sim:$(VSRCS) $(CCSRC)
	@echo "==============verilating the module================="
	mkdir -p $(BUILD_DIR)
	verilator --cc --exe --trace --build -Mdir $(BUILD_DIR) $(VSRC_INC) $(VSRCS) $(CCSRC)\
		-CFLAGS -g $(addprefix -CFLAGS ,$(addprefix ,-I $(INC_PATH)))
	@echo "============excute the excutable file==============="
	./build/Vtop #> /dev/null
	$(call git_commit, "sim RTL") # DO NOT REMOVE THIS LINE!!!
	@echo ""
	@echo "done"
nvboard:$(VSRCS) $(CCSRC) $(SRC_AUTO_BIND) $(NVBOARD_ARCHIVE)
	@echo $(NVBOARD_ARCHIVE)
	@echo "==============verilating the module================="
	mkdir -p $(BUILD_DIR)
	verilator --cc -MMD -O3 --build -x-assign fast --x-initial fast --noassert\
		-Mdir $(BUILD_DIR) \
		$(VSRCS) $(NVBOARD_ARCHIVE) $(SRC_AUTO_BIND) csrc/nvboard_main.cpp\
		$(addprefix -CFLAGS ,$(addprefix -I,$(INC_PATH)))\
		-CFLAGS -DNV_BOARD_ENABLE -CFLAGS -DTOP_NAME=Vtop\
		-LDFLAGS -lSDL2 -LDFLAGS -lSDL2_image\
		--exe 
	@echo "============excute the excutable file==============="
	./build/Vtop
	$(call git_commit, "launch nvboard") # DO NOT REMOVE THIS LINE!!!
	@echo ""
	@echo "done"

nvboard_trace:$(VSRCS) $(CCSRC) $(SRC_AUTO_BIND) $(NVBOARD_ARCHIVE)
	@echo $(NVBOARD_ARCHIVE)
	@echo "==============verilating the module================="
	mkdir -p $(BUILD_DIR)
	verilator --cc -MMD --trace -O3 --build -x-assign fast --x-initial fast --noassert\
		-Mdir $(BUILD_DIR) \
		$(VSRCS) $(NVBOARD_ARCHIVE) $(SRC_AUTO_BIND) csrc/nvboard_main.cpp\
		$(addprefix -CFLAGS ,$(addprefix -I,$(INC_PATH)))\
		-CFLAGS -DNV_BOARD_ENABLE -CFLAGS -DTOP_NAME=Vtop -CFLAGS -DTRACE\
		-LDFLAGS -lSDL2 -LDFLAGS -lSDL2_image\
		--exe 
	@echo "============excute the excutable file==============="
	./build/Vtop
	$(call git_commit, "launch nvboard") # DO NOT REMOVE THIS LINE!!!
	@echo ""
	@echo "done"

sdb: $(OBJS)
	@echo $(OBJ_DIR)
	@echo $(CSRC)
	@echo $(OBJS)
#gcc -fPIC -shared -dynamic $(OBJS) -o lib/libsdb.so	
#	$(AR) -rcs $(SDBLIB) $(OBJS)
run:sdb #verilog
	cat  temp/dpi.v $(CHISEL_BUILD_DIR)/Core.v > vsrc/top.v
#	cp $(CHISEL_BUILD_DIR)/Core.v vsrc/top.v
	$(call git_commit, "build npc")
	@mkdir -p $(BUILD_DIR)
	verilator --cc --exe --trace --build -Wno-fatal -Mdir $(BUILD_DIR) $(VSRCS) $(CCSRC) $(abspath $(OBJS))\
		-CFLAGS -g -CFLAGS "-I$(INC_PATH)" $(addprefix -CFLAGS ,$(CXXFLAGS)) $(addprefix -LDFLAGS , $(LIBS))
	@echo $(ARGS) $(IMG)
	./build/Vtop $(ARGS) $(IMG) 
gdb:verilog
	cat  temp/dpi.v $(CHISEL_BUILD_DIR)/Core.v > vsrc/top.v
	$(call git_commit, "build npc")
	@mkdir -p $(BUILD_DIR)
	verilator --cc --exe --trace --build -Wno-fatal -Mdir $(BUILD_DIR) $(VSRCS) $(CCSRC) $(abspath $(OBJS))\
		-CFLAGS -g -CFLAGS "-I$(INC_PATH)" $(addprefix -CFLAGS ,$(CXXFLAGS)) $(addprefix -LDFLAGS , $(LIBS))
	@echo $(ARGS) $(IMG)
	gdb -s build/Vtop --args build/Vtop $(ARGS) $(IMG) 
include ../Makefile

