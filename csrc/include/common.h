#ifndef __COMMON_H__
#define __COMMON_H__

#include <config.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <stdbool.h>

typedef uint32_t word_t;
typedef uint32_t paddr_t;
typedef uint32_t vaddr_t;

typedef struct 
{
    int state;
    int global_time;
    int inst;
    word_t pc;
    char rst;
    char log[128];
}NPC_State;
typedef struct
{
    word_t* gpr;
    word_t pc;
}CPU_State;
enum
{
    NPC_RUNNING,
    NPC_ABORT,
    NPC_STOP,
    NPC_EXIT,
};
// ----------- log -----------

#define ASNI_FG_BLACK "\33[1;30m"
#define ASNI_FG_RED "\33[1;31m"
#define ASNI_FG_GREEN "\33[1;32m"
#define ASNI_FG_YELLOW "\33[1;33m"
#define ASNI_FG_BLUE "\33[1;34m"
#define ASNI_FG_MAGENTA "\33[1;35m"
#define ASNI_FG_CYAN "\33[1;36m"
#define ASNI_FG_WHITE "\33[1;37m"
#define ASNI_BG_BLACK "\33[1;40m"
#define ASNI_BG_RED "\33[1;41m"
#define ASNI_BG_GREEN "\33[1;42m"
#define ASNI_BG_YELLOW "\33[1;43m"
#define ASNI_BG_BLUE "\33[1;44m"
#define ASNI_BG_MAGENTA "\33[1;35m"
#define ASNI_BG_CYAN "\33[1;46m"
#define ASNI_BG_WHITE "\33[1;47m"
#define ASNI_NONE "\33[0m"

#define ASNI_FMT(str, fmt) fmt str ASNI_NONE

#define ARRLEN(arr) (int)sizeof(arr)/sizeof(arr[0]) 
#endif //__COMMON_H__