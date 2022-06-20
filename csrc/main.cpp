#include <npc.h>
#include <stdio.h>
#include <assert.h>
#include <stdlib.h>
#include <stdlib.h>
#include <unistd.h>
#include <getopt.h>
#include <sdb.h>
#include <init.h>

extern "C"{
	int init(int argc, char **argv);
	void sdb_mainloop();
	void clean_up();	
}

int main(int argc, char** argv) {

	int cnt = 0;
	init(argc, argv);
	sdb_mainloop();
	clean_up();
	if (npc_state.state == NPC_ABORT)
		return -1;	
	return 0;
}
