#include <npc.h>
#include <memory/memory.h>
#include <common.h>
#include <difftest.h>
#include <verilator-def.h>
#include <sdb.h>
CPU_State cpu_state = {};
NPC_State npc_state = {.global_time = 0};

#ifdef CONFIG_IRING_TRACE
static char itrace_ring_buf[16][128] = {};
static const int itrace_ring_buf_size = 16;
static int itrace_ring_buf_idx = 0;
#endif

extern "C" void npc_step_half(int reset)
{
	int index = npc_state.global_time++;
	top -> reset = reset;
	if ((index % 2) == 0){
		top -> clock = 0;
		top->eval();
	}else {
		top -> clock = 1;
		// if (!reset)top -> io_instMem_data = pinst_fetch(top -> io_instMem_addr);
		top -> eval();
	}
	fp->dump(index);
}
extern "C" void npc_reset(int period)
{
	for (int i = 0; i < period; ++i){
		npc_step_half(1);
		npc_step_half(1);
	}
	npc_step_half(0);
	// top->io_instMem_data = pinst_fetch(top->io_instMem_addr);
	// top->eval();
	// cpu_state.pc = top->io_instMem_addr;
	npc_state.state = NPC_STOP;
}
extern "C" void exec_instruction()
{
	// npc_state.inst = top->io_instMem_data;
	npc_step_half(0);	
	npc_step_half(0);
	// cpu_state.pc = top->io_instMem_addr;
	
}
extern "C" void disassemble(char *str, int size, uint64_t pc, uint8_t *code, int nbyte);
void npc_step()
{
	word_t pc = npc_state.pc;
	memset(npc_state.log, '\0', sizeof(npc_state.log));
	char *p = npc_state.log;
	p += snprintf(p, sizeof(npc_state.log), "0x%08x: ", pc);
	uint8_t *inst = (uint8_t *)&npc_state.inst;
	for (int i = 3; i >= 0; i--)
		p += snprintf(p, sizeof(npc_state.log), "0x%02x ", inst[i]);
	disassemble(p, sizeof(npc_state.log) + p - npc_state.log, pc, inst, 4);
#ifdef CONFIG_ITRACE
	log_write("%s\n", npc_state.log);
#endif
#ifdef CONFIG_IRING_TRACE
	sprintf(itrace_ring_buf[(itrace_ring_buf_idx++) & (itrace_ring_buf_size - 1)], "%s", npc_state.log);
#endif
	exec_instruction();
#ifdef CONFIG_DIFFTEST
	difftest_step();
#endif
	if(!check_watchpoint()){
		npc_state.state = NPC_STOP;
	}
	if (check_breakpoint(npc_state.pc)){
		npc_state.state = NPC_STOP;
	}
}
extern "C" void trap_handler()
{
	if (npc_state.state == NPC_EXIT)
	{
		printf(ASNI_FMT("Hit Good Trap\n", ASNI_FG_GREEN));
	}
	else if (npc_state.state == NPC_ABORT)
	{
		printf(ASNI_FMT("Hit Bad Trap\n", ASNI_FG_RED));
	}
}
extern "C" int cpu_exec(int times)
{
	if (npc_state.state == NPC_STOP)
		npc_state.state = NPC_RUNNING;
	else
	{
		printf("End of the program\n");
		return 0;
	}
	while (times-- > 0)
	{
		npc_step();
		if (npc_state.state != NPC_RUNNING)
		{
#ifdef CONFIG_IRING_TRACE
			const char *emptyStr = "";
			const char *arrow = "-->";
			if (npc_state.state == NPC_ABORT)
			{
				if (itrace_ring_buf_idx < 16)
				{
					for (int i = 0; i < itrace_ring_buf_idx; i++)
					{
						printf("\t%s\n", itrace_ring_buf[i]);
					}
				}
				else
				{
					for (int i = itrace_ring_buf_idx - 15; i < itrace_ring_buf_idx; i++)
					{
						printf("%s\t%s\n", i == itrace_ring_buf_idx - 1 ? arrow : emptyStr,
							   itrace_ring_buf[i & (itrace_ring_buf_size - 1)]);
					}
				}
			}
#endif
			trap_handler();
			return 0;
		}
	}
	npc_state.state = NPC_STOP;
	return 0;
}