#include "Vtop.h"
#include <stdio.h>
#include <assert.h>
#include <verilated.h>
#include <verilated_vcd_c.h>
#include <stdlib.h>


VerilatedVcdC *fp;

int main(int argc, char** argv, char** env) {
	VerilatedContext* contextp = new VerilatedContext;
	contextp->commandArgs(argc, argv);
	Vtop* top = new Vtop{contextp};
	contextp->traceEverOn(true);
	int cnt = 20;
	fp = new VerilatedVcdC;
	top->trace(fp,99);
	fp->open("vcd_dump.vcd");
	fp->dump(0);
	while (--cnt!=0) { 
		contextp->timeInc(1);
		int a = rand()&1;
		int b = rand()&1;
		top->a = a;
		top->b = b;
		top->eval();
		printf("f = %d\n",top->f);
		fp->dump(20-cnt);
		assert(top->f == a^b);
	}
	delete top;
	delete fp;
	delete contextp;
	return 0;
}
