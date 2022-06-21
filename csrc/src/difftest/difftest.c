#include <difftest.h>
#include <common.h>
#include <memory/memory.h>
#include <dlfcn.h>
#include <debug.h>
#include <isa/loongArch.h>

extern CPU_State cpu_state;
extern NPC_State npc_state;
#ifdef __cplusplus
extern "C"{
#endif
void (*ref_difftest_memcpy)(paddr_t addr, void* buf, size_t n, bool direction) = NULL;
void (*ref_difftest_regcpy)(void *dut, bool direction) = NULL;
void (*ref_difftest_exec)(uint64_t n) = NULL;
void (*ref_difftest_raise_intr)(uint64_t NO) = NULL;
#ifdef __cplusplus
}
#endif

#ifdef CONFIG_DIFFTEST
bool is_skip_ref = false;
int  is_skip_dut = 0;

#ifdef __cplusplus
extern "C"{
#endif
void init_difftest(char *ref_so_file, long img_size, int port){
    Assert(ref_so_file != NULL, "ref_file_so is empty");
    void *handle  = dlopen(ref_so_file, RTLD_LAZY);
    Assert(handle != NULL, "fail to obtain the handle of ref:%sn " ,dlerror());

    ref_difftest_memcpy = dlsym(handle, "difftest_memcpy");
    Assert(ref_difftest_memcpy,"ref memcpy fail to get");

    ref_difftest_regcpy = dlsym(handle, "difftest_regcpy");
    Assert(ref_difftest_regcpy, "ref memcpy fail to get");

    ref_difftest_raise_intr = dlsym(handle, "difftest_raise_intr");
    Assert(ref_difftest_raise_intr, "ref raise_intr fail to get");

    ref_difftest_exec = dlsym(handle, "difftest_exec");
    Assert(ref_difftest_exec, "ref exec fail to get");

    void (*ref_difftest_init)(int) = dlsym(handle, "difftest_init");
    Assert(ref_difftest_init, "ref init faild to get");
    ref_difftest_init(0);
    ref_difftest_memcpy(RESET_VECTOR, (void *)guest_to_host(RESET_VECTOR), img_size, DIFFTEST_TO_REF);
    ref_difftest_regcpy(&cpu_state, DIFFTEST_TO_REF);
}

void difftest_skip_ref(){
    is_skip_ref = true;
    is_skip_dut = 0;
} 

void difftest_skip_dut(int ref_n, int dut_n){
    is_skip_dut += dut_n;
    while (ref_n --) {
        ref_difftest_exec(1);
    } 
}
void checkregs(CPU_State *ref_cpu){
    if(!isa_check_regs(ref_cpu)){
        npc_state.state = NPC_ABORT;
        isa_reg_display();
        printf("pc:0x%08lx\n",cpu_state.pc);
        ref_isa_reg_display(ref_cpu);
    }
}
void difftest_step(){
    CPU_State ref_cpu;
    if(is_skip_ref){
        ref_difftest_regcpy(&cpu_state,DIFFTEST_TO_REF);
        is_skip_ref = 0;
        return;
    }
    ref_difftest_exec(1);
    ref_difftest_regcpy(&ref_cpu, DIFFTEST_TO_DUT);
    checkregs(&ref_cpu);

}
void ref_isa_reg_display(CPU_State * ref_cpu_state) {
    extern const char *regs[];
	for (int i = 0; i < 16; i++){
		printf(ASNI_FMT("%4s", ASNI_FG_GREEN) ":0x%016lx\t" ASNI_FMT("%4s",ASNI_FG_GREEN)":0x%016lx\n",regs[i*2],ref_cpu_state->gpr[i*2],regs[i*2+1],ref_cpu_state->gpr[i*2+1]);
	}
    printf("ref_pc:0x%08lx\n",ref_cpu_state->pc);
}
#ifdef __cplusplus
}
#endif
#endif 
