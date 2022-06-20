#ifndef __SDB_H__
#define __SDB_H__

#include <stdio.h>
#include <common.h>

#define EXPR_LEN 128
typedef struct watchpoint {
  int NO;
  struct watchpoint *next;
  word_t val;
  char expr[EXPR_LEN];
  /* TODO: Add more members if necessary */

} WP;


typedef struct breakpoint {
  int NO;
  struct breakpoint *next;
  word_t address;
} BP;

extern CPU_State cpu_state;
extern NPC_State npc_state;
#ifdef __cplusplus
extern "C"{
#endif
word_t expr(char *e, bool *success);
void init_sdb();
bool new_wp(WP** res);
void free_wp(int N);
void info_watchpoint();
bool check_watchpoint();
bool new_bp(BP** res);
void free_bp(int N);
void info_breakpoint();
bool check_breakpoint(uint64_t addr);

void sdb_mainloop();
#ifdef __cplusplus
}
#endif


#endif
