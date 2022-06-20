#ifndef __MEMORY_H__
#define __MEMORY_H__
#ifdef __cplusplus
extern "C" {
#endif
#include <common.h>
#include <debug.h>
#include <log.h>

word_t pmem_read(paddr_t addr, int len);
word_t pinst_fetch(paddr_t);
void pmem_write(paddr_t addr, int len, word_t data);
word_t vaddr_read(vaddr_t addr, int len);
void vaddr_write(vaddr_t addr, int len, word_t data);
size_t read_inst(char *);
bool out_of_bound(paddr_t addr);
uint8_t* guest_to_host(paddr_t addr);
paddr_t host_to_guest(uint8_t* index);
#ifdef __cplusplus
}
#endif
#endif //__MEMORY_H__