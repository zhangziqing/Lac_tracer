#include <stdint.h>
#include <isa/loongArch.h>
#include <debug.h>
#include <macro.h>

extern const char **regs;
#define R(i) reg_2_str(i)
#define Rd(i) BITS(i,4,0)
#define Rj(i) BITS(i,9,5)
#define Rk(i) BITS(i,14,10)
//encode pattern
#define R2 ""
#define R3 "%s,%s,%s"

__attribute__((always_inline))
static inline void pattern_decode(const char *str,int len, uint32_t* key,uint32_t* mask,uint32_t* shift){
    uint32_t __key = 0,__mask = 0,__shift = 0;
    #define macro(i)\
    if ((i) >= len) goto finish;\
    else {\
        char c= str[i];\
        if (c != '_'){\
            Assert(c == '1' || c == '0' || c == '?',\
                "Invalid pattern string with invalid character c = '%c'",c);\
            __key  = (__key << 1) | (c == '1' ? 1 : 0);\
            __mask = (__mask << 1) | (c == '?' ? 0 : 1);\
            __shift = (c == '?' ? __shift + 1:0);\
        }\
    }

    #define macro2(i)  macro(i);   macro((i) + 1)
    #define macro4(i)  macro2(i);  macro2((i) + 2)
    #define macro8(i)  macro4(i);  macro4((i) + 4)
    #define macro16(i) macro8(i);  macro8((i) + 8)
    #define macro32(i) macro16(i); macro16((i) + 16)
    #define macro64(i) macro32(i); macro32((i) + 32)
        macro64(0);
    #undef macro
    finish:
        *key = __key >> __shift;
        *mask = __mask >> __shift;
        *shift = __shift;
}

#define INSTPAT(pattern, name, fmt,...)do {\
    uint32_t key,mask,shift;\
    pattern_decode(pattern,STRLEN(pattern),&key,&mask,&shift);\
    if (((inst >> shift) & mask) == key){\
        sprintf(str,"  " #name "  " fmt, ##__VA_ARGS__);\
        goto *(__instpat_end);\
    }\
}while(0)

#define INSPAT_START() { const void * __instpat_end = &&__instpat_end_;
#define INSPAT_END() __instpat_end_:;}

void init_disasm(const char *triple)
{
}
/**
 * @brief
 *  This function is used for disassemble the instruction
 * @param str
 *  The string buffer to output the info
 * @param size
 *  The size is the valid length remain in string buffer
 * @param pc
 *  The Program counter of cpu
 * @param code
 *  The Instruction code
 * @param nbyte
 *  The length of instruction
 */
void disassemble(char *str, int size, uint64_t pc, uint8_t *code, int nbyte)
{
    uint32_t inst = *(uint32_t *)code;
    INSPAT_START()
    INSTPAT("000000_00000_100000_?????_?????_?????",add.w   ,R3, R(Rd(inst)),R(Rj(inst)),R(Rk(inst)));
    INSTPAT("000000_00000_100010_?????_?????_?????",sub.w   ,R3, R(Rd(inst)),R(Rj(inst)),R(Rk(inst)));
    INSTPAT("000000_00000_100100_?????_?????_?????",slt     ,R3, R(Rd(inst)),R(Rj(inst)),R(Rk(inst)));
    INSTPAT("000000_00000_100101_?????_?????_?????",sltu    ,R3, R(Rd(inst)),R(Rj(inst)),R(Rk(inst)));
    INSTPAT("000000_00000_101000_?????_?????_?????",nor     ,R3, R(Rd(inst)),R(Rj(inst)),R(Rk(inst)));
    INSTPAT("000000_00000_101001_?????_?????_?????",and     ,R3, R(Rd(inst)),R(Rj(inst)),R(Rk(inst)));
    INSTPAT("000000_00000_101010_?????_?????_?????",or      ,R3, R(Rd(inst)),R(Rj(inst)),R(Rk(inst)));
    INSTPAT("000000_00000_101011_?????_?????_?????",xor     ,R3, R(Rd(inst)),R(Rj(inst)),R(Rk(inst)));
    INSTPAT("000000_00000_101110_?????_?????_?????",sll.w   ,R3, R(Rd(inst)),R(Rj(inst)),R(Rk(inst)));
    INSTPAT("000000_00000_101111_?????_?????_?????",srl.w   ,R3, R(Rd(inst)),R(Rj(inst)),R(Rk(inst)));
    INSTPAT("000000_00000_110000_?????_?????_?????",sra.w   ,R3, R(Rd(inst)),R(Rj(inst)),R(Rk(inst)));
    INSTPAT("000000_00000_111000_?????_?????_?????",mul.w   ,R3, R(Rd(inst)),R(Rj(inst)),R(Rk(inst)));
    INSTPAT("000000_00000_111001_?????_?????_?????",mulh.w  ,R3, R(Rd(inst)),R(Rj(inst)),R(Rk(inst)));
    INSTPAT("000000_00000_111010_?????_?????_?????",mulh.wu ,R3, R(Rd(inst)),R(Rj(inst)),R(Rk(inst)));
    INSTPAT("000000_00001_000000_?????_?????_?????",div.w   ,R3, R(Rd(inst)),R(Rj(inst)),R(Rk(inst)));
    INSTPAT("000000_00001_000001_?????_?????_?????",mod.w   ,R3, R(Rd(inst)),R(Rj(inst)),R(Rk(inst)));
    INSTPAT("000000_00001_000010_?????_?????_?????",div.wu  ,R3, R(Rd(inst)),R(Rj(inst)),R(Rk(inst)));
    INSTPAT("000000_00001_000011_?????_?????_?????",mod.wu  ,R3, R(Rd(inst)),R(Rj(inst)),R(Rk(inst)));
    INSTPAT("000000_00001_010100_?????_?????_?????",break   ,"%ld",BITS(inst,14,0));
    INSTPAT("000000_00001_010100_?????_?????_?????",syscall ,"%ld",BITS(inst,14,0));
    INSTPAT("000101_0????_??????_?????_?????_?????",lu12i.w ,"%s,%ld",R(Rd(inst)),BITS(inst,14,0));
    INSTPAT("000111_0????_??????_?????_?????_?????",pcaddu12i.w ,"%s,%ld",R(Rd(inst)),BITS(inst,14,0));
    INSTPAT("100000_00000_000000_00000_00000_00000",halt,"");
    INSTPAT("??????_?????_??????_?????_?????_?????",inv,"Invalid Inst");
    INSPAT_END()
}
