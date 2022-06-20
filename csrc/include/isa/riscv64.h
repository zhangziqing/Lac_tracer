#ifndef __RISCV64_H__
#define __RISCV64_H__
#include <common.h>

#ifdef __cplusplus
extern "C" {
#endif
void isa_reg_display();

word_t isa_reg_str2val(const char *s, bool *success);
bool isa_check_regs(CPU_State *);
#ifdef __cplusplus
}
#endif

#endif //__RISCV64_H__