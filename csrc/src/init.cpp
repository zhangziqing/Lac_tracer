#include <npc.h>
#include <unistd.h>
#include <getopt.h>
#include <memory/memory.h>
#include <init.h>
#include <sdb.h>
#include <difftest.h>
#include <verilator-def.h>
#include <string>
char *img_file;
char *log_file;
char *vcd_file;
char *difftest_file;
char *elf_file;
FILE *log_fp;
char default_vcd_file[] = "build/vcd_dump.vcd";
char tri_tuple[] = "riscv64-pc-linux-gnu";
VerilatedContext *contextp;
VerilatedVcdC * fp;
Vtop *top;


extern "C" void sdb_set_batch_mode();

static void init_log(){
	log_fp = stdout;
	if (log_file != NULL){
		log_fp = fopen(log_file, "w");
		Assert(log_fp, "can not open file %s",log_file);
	}
}
extern uint8_t *mem;

static int parse_args(int argc, char **argv)
{
	const static struct option long_options[] = {
		{"log", required_argument, NULL, 'l'},
		{"help", no_argument, NULL, 'h'},
		{"diff", required_argument, NULL, 'd'},
		{"vcd", required_argument, NULL, 'v'},
		{"batch",no_argument, NULL, 'b'},
		{"elf", no_argument, NULL , 'e'},
		{0, 0, NULL, 0},
	};
	int opt;
	while ((opt = getopt_long(argc, argv, "-l:v:hd:e:b", long_options, NULL)) != -1)
	{
		switch (opt)
		{
		case 'l':
			log_file = optarg;
			break;
		case 'v':
			vcd_file = optarg;
			break;
		case 'b':
			sdb_set_batch_mode();
			break;
		case 'd':
			difftest_file = optarg;
			break;
		case 'e':
			elf_file = optarg;
			break;
		case 1:
			img_file = optarg;
			return optind - 1;
		}
	}
	return 0;
}

static void verilator_init(int argc,char**argv){
	contextp = new VerilatedContext;
	contextp->commandArgs(argc, argv);
	top = new Vtop{contextp};
	contextp->traceEverOn(true);
	fp = new VerilatedVcdC;
	top->trace(fp,99);
	if(vcd_file == NULL){
		vcd_file = default_vcd_file;
	}
	fp->open(vcd_file);
	fp->dump(0);
}

extern "C" void init_disasm(char*);
extern "C" void init_elf_resolve(const char * file);

extern "C" int init(int argc, char **argv)
{
    int ret = parse_args(argc, argv);
    verilator_init(argc, argv);
	long size = read_inst(img_file);
	init_sdb();
	init_log();
	npc_reset(5);
	init_elf_resolve(elf_file);	
	init_disasm(tri_tuple);
#ifdef CONFIG_DIFFTEST
	init_difftest(difftest_file, size, 0);
#endif
    return 0;
}

extern "C" void clean_up() {
	if (fp != nullptr)
		delete fp;
	if (contextp != nullptr)
		delete contextp;
	if (top != nullptr)
		delete top;
}