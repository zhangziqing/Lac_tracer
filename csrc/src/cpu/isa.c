#include <isa/riscv64.h>
#include <npc.h>
#include <common.h>

extern CPU_State cpu_state;
const char *regs[] = {
  "$0", "ra", "sp", "gp", "tp", "t0", "t1", "t2",
  "s0", "s1", "a0", "a1", "a2", "a3", "a4", "a5",
  "a6", "a7", "s2", "s3", "s4", "s5", "s6", "s7",
  "s8", "s9", "s10", "s11", "t3", "t4", "t5", "t6"
};

void isa_reg_display() {
	for (int i = 0; i < 16; i++){
		printf(ASNI_FMT("%4s", ASNI_FG_GREEN) ":0x%016lx\t" ASNI_FMT("%4s",ASNI_FG_GREEN)":0x%016lx\n",regs[i*2],cpu_state.gpr[i*2],regs[i*2+1],cpu_state.gpr[i*2+1]);
	}
}

word_t isa_reg_str2val(const char *s, bool *success) {
  for (int i = 0; i < 32; i++){
    if (strcmp(regs[i],s) == 0){
      *success = true;
      return cpu_state.gpr[i];
    }
  }

  if (strcmp("pc",s) == 0 || strcmp("PC",s) == 0 || strcmp("Pc",s) == 0){
    *success = true;
    return cpu_state.pc;
  }
  *success = false;
  return 0;
}
bool isa_check_regs(CPU_State *ref) {
   for(int i = 0; i < 32; i++) {
     if(ref->gpr[i] != cpu_state.gpr[i])
      return false; 
   }
   if (ref->pc != cpu_state.pc) {
     return false;
   }
   return true;
}