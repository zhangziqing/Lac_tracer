#ifndef __UTILS_H__
#define __UTILS_H__


#include <config.h>
#include <log.h>
#include <common.h>

#define log_write(...) do { \
    if (log_fp != NULL) { \
        fprintf(log_fp, ##__VA_ARGS__); \
        fflush(log_fp); \
    } \
} while(0)

#define _Log(fmt,format,...) do { \
    printf(ASNI_FMT(format,fmt),##__VA_ARGS__);\
    log_write(format, ##__VA_ARGS__);\
    }while(0)

#endif // __UTILS_H__
