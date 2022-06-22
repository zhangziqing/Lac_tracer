#include "svdpi.h"
#include "Vtop__Dpi.h"
#include "npc.h"
#include "common.h"
extern "C" {
#include "memory/memory.h"
#include "difftest.h"
}

extern CPU_State cpu_state; 
extern NPC_State npc_state;
void trap(int inst,int res){
    //printf("immj = %x\n" , immj);
    if (inst == 0x80000000){
    #ifdef CONFIG_DIFFTEST
        difftest_skip_ref();
    #endif        
        npc_state.state = res != 0 ? NPC_ABORT : NPC_EXIT;
    }
}

void print(int inst,int pc){
    //printf("inst = 0x%08x,pc = 0x%016llx\n", inst, pc);
    npc_state.pc = pc;
    npc_state.inst = inst;
    cpu_state.pc = pc;
}
void reg_update(int data, int index){
    cpu_state.gpr[index] = data;
}
void dpi_pmem_read(int* data, int addr, svBit en, const svBitVecVal* rd_size){
    if (en){
        *data = (int)pmem_read(addr,4);
    }
}
void dpi_pmem_write(int data, int addr, svBit en, const svBitVecVal* wr_size){
    if (en){
        pmem_write((word_t)addr, *wr_size, 4);
    }
}