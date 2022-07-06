#ifndef __DEBUG_H__
#define __DEBUG_H__

#include <assert.h>
#include <utils.h>
#include <common.h>
#include <isa/loongArch.h>

#define Log(format, ...) _Log(ASNI_FG_BLUE,"[%s:%d %s]" format "\n", __FILE__, __LINE__, __func__, ##__VA_ARGS__)
#define Assert(cond,fmt,...) do {\
    if(!(cond)){\
        _Log(ASNI_FG_RED,"[%s:%d %s]" fmt "\n", __FILE__, __LINE__, __func__, ##__VA_ARGS__);\
        isa_reg_display();\
        assert(0);\
    }\
}while(0)
#define panic(fmt,...) Assert(0,fmt,##__VA_ARGS__)
#endif // __DEBUG_H__