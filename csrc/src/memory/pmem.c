#include <memory/memory.h>
uint8_t mem[CONFIG_MEM_SIZE];
#ifdef __cplusplus
extern "C" {
#endif
uint8_t* guest_to_host(paddr_t addr){
    return mem + addr - CONFIG_MEM_BASE;
}
paddr_t host_to_guest(uint8_t* index){
    return index + CONFIG_MEM_BASE - mem;
}
bool out_of_bound(paddr_t addr){
    return (paddr_t)addr < (paddr_t)CONFIG_MEM_BASE || addr >= (paddr_t)(CONFIG_MEM_BASE + CONFIG_MEM_SIZE);
}
static word_t host_read(uint8_t* addr, int len ){
    switch (len)
    {
        case 1: return *(uint8_t *)addr;break;
        case 2: return *(uint16_t *)addr;break;
        case 4: return *(uint32_t *)addr;break;
        case 8: return *(uint64_t *)addr;break;
        default:
            panic("Invaild length,0x%lx,0x%lx,0x%lx,0x%x",CONFIG_MEM_BASE,CONFIG_MEM_BASE + CONFIG_MEM_SIZE,(uint64_t)addr,len);
    }
    return 0;
}
static void host_write(uint8_t* addr, int mask, word_t data){
    *(uint32_t*)addr = (*(uint32_t*)addr & ~mask) |  (data & mask);
}
word_t pmem_read(paddr_t addr, int len){
#ifdef CONFIG_MTRACE
    log_write("Read Addr:%x,size:%d\n", addr, len);
#endif
    if(!out_of_bound(addr)){
        return host_read(guest_to_host(addr), len);
    }
    panic("out of bound\n");
    return 0;
}
void pmem_write(paddr_t addr, int len, word_t data){
#ifdef CONFIG_MTRACE
    log_write("Write Addr:%x,mask:%x,write:%x\n", addr, len, data);
#endif
    if(!out_of_bound(addr)){
        host_write(guest_to_host(addr), len, data);
        return;
    }
    panic("Memory out of bound");
}

word_t pinst_fetch(paddr_t addr){
#ifdef CONFIG_MTRACE
    log_write("read inst ==");
#endif
    return pmem_read(addr,4);

}
word_t vaddr_read(vaddr_t addr, int len) {
    return pmem_read(addr,len);
}
void vaddr_write(vaddr_t addr, int len, word_t data){
    pmem_write(addr,len,data); 
}

size_t read_inst(char *img_file) {
    if (img_file == NULL) {
        static const uint32_t img [] = {
          0x1c000003,  // pcaddu12i sp,0
          0x28805064,  // ld  a0,16(sp)
          0x29805060,  // sd  zero,16(sp)
          0x02800004,  // addi.w a0,zero,0
          0x80000000,  // ebreak (used as npc_trap)
          0xdeadbeef,  // some data
        };
        memcpy(mem,img,sizeof(img));
        return sizeof(img);
    }
	FILE * fp = fopen(img_file,"rb");
	Assert(fp !=NULL, "Can not open this file:%s\n",img_file);
	
	fseek(fp, 0, SEEK_END);
	size_t size = ftell(fp);
	fseek(fp, 0, SEEK_SET);
	size_t res = fread(mem, size, 1, fp);
    assert(res == 1);
    fclose(fp);
    return size;
}
#ifdef __cplusplus
}
#endif