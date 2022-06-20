#ifndef __NPC_H__
#define __NPC_H__

#include <stdio.h>
#include <assert.h>
#include <stdlib.h>
#include <stdlib.h>
#include <stdint.h>
#include <debug.h>
#include <common.h>

#ifdef __cplusplus
extern "C" {
#endif
int cpu_exec(int time);
void npc_reset(int);
#ifdef __cplusplus
}
#endif
#endif // !__NPC_H__