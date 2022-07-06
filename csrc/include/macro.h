#ifndef __MACRO_H__
#define __MARCRO_H__

#define BITMASK(bits) ((1ul << (bits)) - 1)
#define BITS(x,hi,lo) (((x) >> (lo)) & BITMASK((hi) - (lo) + 1))
#define SEXT(x,len) ({struct {int32_t n :len;}__x = {.n = x};(int64_t)__x.n;})
#define STRLEN(STR) (sizeof(STR) - 1) 
#endif //__MARCO_H__