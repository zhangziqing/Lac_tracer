#include <elf.h>
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include <debug.h>
typedef struct
{
    char name[64];
    uintptr_t base_addr;
    uintptr_t size;
}sym_tlb;
typedef struct
{
    sym_tlb *sym_tab;
    uint64_t hash_value;
}str_hashtab;
str_hashtab str_hash_table[65536];

static sym_tlb symtlb[512];
static sym_tlb *addr_hash_table[65536];

static int nr_sym = 0;

static uint64_t get_hash(const char * str){
    const char *ptr = str;
    uint64_t hash_value = 0;
    while(*ptr != '\0'){
        hash_value = hash_value * 128 + *(ptr++);
    }
    hash_value = hash_value % 1000000007;
    return hash_value;
}

static void add_sym_by_addr(int count){
    uint16_t base = symtlb[count].base_addr & 0xffff;
    while (addr_hash_table[base] != NULL){
        base += 17;
    }
    addr_hash_table[base] = &symtlb[count];
}

static void add_sym_by_name(int count){
    uint64_t hash = get_hash(symtlb[count].name);
    int base = hash & 0xffff;
    while(str_hash_table[base].sym_tab != NULL){
        base += 17;
    }
    str_hash_table[base].sym_tab = &symtlb[count];
    str_hash_table[base].hash_value = hash;
}

static void add_symtlb_entr(char *name,uintptr_t base_addr, uint64_t size){
    sprintf(symtlb[nr_sym].name, "%s", name);
    symtlb[nr_sym].base_addr = base_addr;
    symtlb[nr_sym].size = size;
    add_sym_by_addr(nr_sym);
    add_sym_by_name(nr_sym);
    ++nr_sym;
}
sym_tlb* get_sym_by_addr(uintptr_t base_addr){
    uint16_t base = base_addr & 0xffff;
    while (addr_hash_table[base] != NULL){
        if (addr_hash_table[base]->base_addr == base_addr){
            return addr_hash_table[base];
        } else {
            base += 17;
        } 
    }
    return NULL;
}

sym_tlb* get_sym_by_name(const char * name){
    uint64_t hash = get_hash(name);
    int base = hash & 0xffff;
    while(str_hash_table[base].sym_tab != NULL){
        if (str_hash_table[base].hash_value == hash && strcmp(name,str_hash_table[base].sym_tab->name) == 0){
            return str_hash_table[base].sym_tab;
        } else {
            base += 17;
        }
    }
    return NULL;
}

uintptr_t get_sym_addr(const char* name,bool *status){
    sym_tlb* sym = get_sym_by_name(name);
    if (sym == NULL){
        *status = false;
        return -1;
    } else {
        return sym->base_addr;
    }
}

int get_sym_name(char *name,uintptr_t addr){
    sym_tlb* sym = get_sym_by_addr(addr);
    if (sym != NULL){
        strcpy(name, sym->name);
        return 0;
    }
    return -1;
}

void init_elf_resolve(const char * file){
    if (file == NULL){
        return ;
    }
    int status;
    FILE *fp = fopen(file,"r");
    Assert(fp != NULL, "cannot open file %s",file);
    Log("Open elf file %s",file);
    Elf64_Ehdr elfHdr;
    status = fread(&elfHdr, sizeof(Elf64_Ehdr), 1, fp);

    if (status == 0){
        printf("error\n");
    }
    fseek(fp, elfHdr.e_shoff, SEEK_SET);
    Elf64_Shdr sym_shdr;
    Elf64_Off symtab_off = 0, strtab_off = 0;
    Elf64_Shdr *shdr_ptr = &sym_shdr;
    uint64_t symtab_sz = 0,strtab_sz,symtab_ent_sz = 0;
    char *strtab = NULL;
    Elf64_Sym * symtab = NULL;
    int cond = 0;
    int index = 0;
    while(cond < 2){
        status = fread(shdr_ptr, sizeof(Elf64_Shdr), 1, fp);
        if (status == 0){
            printf("error\n");
        }
        if (shdr_ptr->sh_type == SHT_SYMTAB){
            symtab_off = shdr_ptr->sh_offset;
            symtab_sz = shdr_ptr->sh_size;
            symtab_ent_sz = shdr_ptr->sh_entsize;
            symtab = (Elf64_Sym*)malloc(shdr_ptr->sh_size);
            ++cond;
        }else if (shdr_ptr->sh_type == SHT_STRTAB){
            if(index != elfHdr.e_shstrndx){
                strtab_off = shdr_ptr->sh_offset;
                strtab_sz = shdr_ptr->sh_size;
                strtab = malloc(shdr_ptr->sh_size);
                ++cond;
            }
        }
        ++index;
    }
    Assert(strtab != NULL && symtab != NULL, "Cannot find strtab and symtab");
    fseek(fp,symtab_off,SEEK_SET);
    status = fread(symtab, sizeof(char), symtab_sz, fp);
    if (status == 0){
        printf("error\n");
    }
    fseek(fp,strtab_off,SEEK_SET);
    status = fread(strtab, sizeof(char), strtab_sz, fp);
    if (status == 0){
        printf("error\n");
    }

    for (int i = 0; i < symtab_sz / symtab_ent_sz; i++){
        if (ELF64_ST_TYPE(symtab[i].st_info) == STT_FUNC){
            add_symtlb_entr(strtab + symtab[i].st_name, symtab[i].st_value, symtab[i].st_size);
        }
    }
    free(strtab);
    free(symtab);
}

void get_function_name(char *name, uint64_t addr){
    for (int i = 0; i < nr_sym; i++){
        if (addr >= symtlb[i].base_addr && addr < symtlb[i].size){
            sprintf(name,"%s",symtlb[i].name);
            return ;
        }
    }
}