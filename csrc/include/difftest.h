#ifndef __DIFFTEST_H__
#define __DIFFTEST_H__

#include <common.h>

#ifdef __cplusplus
extern "C"{
#endif
    extern void (*ref_difftest_memcpy)(paddr_t addr, void *buf, size_t n, bool direction);
    extern void (*ref_difftest_regcpy)(void *dut, bool direction);
    extern void (*ref_difftest_exec)(uint64_t n);
    extern void (*ref_difftest_raise_intr)(uint64_t NO);
#ifdef __cplusplus
}
#endif

enum
{
    DIFFTEST_TO_DUT,
    DIFFTEST_TO_REF
};
#ifdef CONFIG_DIFFTEST

#ifdef __cplusplus
extern "C"{
#endif
void init_difftest(char *,long, int);
void difftest_step();
void difftest_skip_ref();
void ref_isa_reg_display(CPU_State *cpu_state);
#ifdef __cplusplus
}
#endif
#endif
#endif // !__DIFFTEST_H__