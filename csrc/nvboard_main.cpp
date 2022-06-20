#ifdef NV_BOARD_ENABLE 
#include "nvboard.h"
#include<stdio.h>
#include "Vtop.h"
#include "verilated_vcd_c.h"



static TOP_NAME *top=nullptr;
static VerilatedContext* contextp=nullptr;
static VerilatedVcdC *fp=nullptr;
#endif // DEBUG
#ifdef TRACE 
void trace_init(){
	printf("trace_enable");
	contextp->traceEverOn(true);
	fp = new VerilatedVcdC;
	top->trace(fp,99);
	fp->open("./build/vcd_dump.vcd");
	fp->dump(0);
}
void dump(int index) {
	fp->dump(index);
}
#endif

#ifndef TRACE
void trace_init(){}
void dump(int index) {}
#endif 
#ifdef NV_BOARD_ENABLE
static int  time_index=0;
void nvboard_bind_all_pins(Vtop* top);

static void verilator_init(int argc,char** argv){
	//	if (argc > 1)
	//		trace_enable = true;
	//	else 
	//		trace_enable = false;

	contextp = new VerilatedContext;
	contextp->commandArgs(argc,argv);
	top = new TOP_NAME {contextp};
	trace_init();
}
static void single_cycle(){
	top->clk = 0;
	top->eval();

	dump(2*time_index);

	top->clk = 1;
	top->eval();

	dump(2*time_index+1);
	++time_index;
}
static void reset(int n) {
	top->rst = 1;
	while( --n >= 0)
		single_cycle();
	top->rst = 0;
}

static void clean_up(){
	if (top != nullptr)
		delete top;
	if (contextp != nullptr)
		delete contextp;
	if (fp != nullptr)
		delete fp;
}

int main(int argc,char **argv) {
	verilator_init(argc,argv);
	nvboard_bind_all_pins(top);
	nvboard_init();
	time_index = 0;
	reset(10);
	while(1) {
		nvboard_update();
		single_cycle();
	}
	clean_up();
	return 0;
}

#endif // #ifdef NV_BOARD_ENABLE
#ifndef NV_BOARD_ENABLE 
#include "stdio.h"
int nvboard() {
	printf("No def");
	return 0;
}
#endif
