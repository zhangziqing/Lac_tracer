#if defined(__GNUC__) && !defined(__clang__)
#pragma GCC diagnostic pop
#endif
#include <stdint.h>
extern "C" void init_disasm(const char *triple)
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
extern "C" void disassemble(char *str, int size, uint64_t pc, uint8_t *code, int nbyte)
{
}
