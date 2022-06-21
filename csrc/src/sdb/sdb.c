#include <readline/readline.h>
#include <readline/history.h>
#include <stdio.h>
#include <sdb.h>
#include <log.h>
#include <npc.h>
#include <memory/memory.h>
#include <isa/loogArch.h>


static int is_batch_mode = false;

void init_regex();
void init_wp_pool();
void init_bp_pool();

/* We use the `readline' library to provide more flexibility to read from stdin. */
static char* rl_gets() {
  static char *line_read = NULL;

  if (line_read) {
    free(line_read);
    line_read = NULL;
  }

  line_read = readline(ASNI_FMT("(zakia-npc) ",ASNI_FG_BLUE));

  if (line_read && *line_read) {
    add_history(line_read);
  }

  return line_read;
}

static int cmd_c(char *args) {
  cpu_exec(0x80000);
  return 0;
}

static int cmd_q(char *args) {
  return -1;
}

static int cmd_help(char *args);

static int cmd_si(char *args){

  char *arg_N = strtok(args," ");
  if (arg_N == NULL) {
    cpu_exec(1);
  } else {
    int N;
    sscanf(arg_N,"%d",&N);
    Log("the steps are N=%d",N);
    for (int i = 0; i < N; i++) {
      cpu_exec(1);
    }
  } 
  return 0;
}

static int cmd_info(char *args){
  char *cmd = strtok(args," ");
  if (cmd == NULL) {
    printf("Invaild subcmd!\n");
  } else if (cmd[0] == 'r'){
    isa_reg_display();
  } else if (cmd[0] == 'w') {
    info_watchpoint();
  } else {
    printf("Invaild subcmd\n");
  }
  return 0;
}

static int cmd_x(char *args){
  char *bytes  = strtok(args," ");
  if (bytes == NULL) {
    printf("Invaild argument\n");
  } 
  int ibyte;
  sscanf(bytes,"%d",&ibyte);
  // ibyte = ibyte * 4;
  args = args + strlen(bytes)+1;
  // char *addr = strtok(args," ");
  // if (addr == NULL) {
  // 	printf("Invalid address\n");
  // // }
  // args = args + strlen(addr) + 1;
  bool status;
  vaddr_t iaddr = expr(args,&status);
  if (status == false){
    return 0;
  }
  const int num_p_line = 8; 
  for (int i = 0; i < (ibyte)/num_p_line+(ibyte%num_p_line!=0);i++){
    printf("\033[1;32m0x%08lx:\033[0m",iaddr+i*num_p_line);
    for (int j = num_p_line*i;j < ibyte && j <num_p_line*i+num_p_line; j++){
      word_t content = vaddr_read(iaddr+j*4,4);
      printf("0x%08lx  ",content);
    }
    printf("\n");
  }
  return 0;
}
static int cmd_xb(char *args){
  char *bytes  = strtok(args," ");
  if (bytes == NULL) {
    printf("Invaild argument\n");
  } 
  int ibyte;
  sscanf(bytes,"%d",&ibyte);
  // ibyte = ibyte * 4;
  args = args + strlen(bytes)+1;
  // char *addr = strtok(args," ");
  // if (addr == NULL) {
  // 	printf("Invalid address\n");
  // // }
  // args = args + strlen(addr) + 1;
  bool status;
  vaddr_t iaddr = expr(args,&status);
  if (status == false){
    return 0;
  }
  const int num_p_line = 8; 
  for (int i = 0; i < (ibyte)/num_p_line+(ibyte%num_p_line!=0);i++){
    printf("\033[1;32m0x%08lx:\033[0m",iaddr+i*num_p_line);
    for (int j = num_p_line*i;j < ibyte && j <num_p_line*i+num_p_line; j++){
      if(out_of_bound(iaddr+j)){
        printf(ASNI_FMT("addr out of bound", ASNI_BG_RED));
        printf("\n");
        return 0;
      }
      word_t content = vaddr_read(iaddr+j,1);
      if (content >=32 && content <= 126 ){
        printf("'%c' ",(char)content);
      }else {
        printf("'\\%d' ",(char)content);
      }
    }
    printf("\n");
  }
  return 0;
}

static int cmd_p (char * args){
  bool status;
  word_t res = expr(args,&status);
  if (status){
    printf("%s: 0x%lx\n",args,res);
  } else {
    printf("wrong experssion\n");
  }
  return 0;
}

static int cmd_pd (char * args){
  bool status;
  word_t res = expr(args,&status);
  if (status){
    printf("%s: %ld\n",args,res);
  } else {
    printf("wrong experssion\n");
  }
  return 0;
}
static int cmd_w (char * args){
  WP* p = NULL;
  bool status;
  word_t val = expr(args,&status);
  if (!status){
    printf("Invalid expression\n");
    return 0;
  }
  status = new_wp(&p);
  if (status == false){
    printf("allocate watchpoint failed,check if there are watchpoint available\n");
  } 
  Assert(p!=NULL,"Bad status");
  p->val = val;
  strcpy(p->expr,args);
  printf("watchpoint on [%s]\n",p->expr);
  return 0;
}

static int cmd_d(char * args){
  int N;
  char *d = strtok(args," ");
  if (*d == 'b'){
    ++d;
    sscanf(d,"%d",&N);
    free_bp(N);
    printf("bp %d freed", N);
  } else if (*d == 'w'){
    ++d;
    sscanf(d,"%d",&N);
    free_wp(N);
    printf("wp %d freed\n",N);
  } else {
    printf("invalid argument, valid arguments are b,w");
  }
  return 0;
}

static int cmd_b(char *args){
  bool status;
  word_t res = expr(args, &status);
  if (!status){
    return 0;
  }
  BP * bp;
  status = new_bp(&bp);
  if (status == false){
    printf("allocate breakpoint failed, check if there are breakpoint available\n");
    return 0;
  }
  Assert(bp != NULL,"Bad status");
  bp->address = res;
  printf("breakpoint on [%s:%lx]\n",args, res);
  return 0;
}

static struct {
  const char *name;
  const char *description;
  int (*handler) (char *);
} cmd_table [] = {
  { "help", "Display informations about all supported commands", cmd_help },
  { "c", "Continue the execution of the program", cmd_c },
  { "q", "Exit NEMU", cmd_q },
  { "si", "si [N]\n\tExecute [N] instruction(s)",cmd_si },
  { "info", "info {w|r}\ninfo r:\n\tCheck the register status\ninfo w:\n\tCheck the status of watchpoint",cmd_info },
  { "x", "x N EXP\n\tprint the contents in N Bytes from EXP",cmd_x},
  { "xb", "xb N EXP\n\tprint the contents in N Bytes from EXP in the form of char",cmd_xb},
  { "w", "x EXP\n\tset a watchpoint on expression EXP,when the value of the EXP change,the program will be stop",cmd_w},
  { "b", "b ADDRESS\n\tSet a breakpoint at ADDRESS", cmd_b}, 
// { "b", "b 0x"} 
  { "p", "p EXP\n\tprint the value of the expression",cmd_p},
  { "pd", "pd EXP\n\tprint the value of the expression in decimal",cmd_pd},
  { "d", "d N\n\tDelete the watchPoint N", cmd_d},
  { "n", "n [N]\n\t an alias for si", cmd_si},
//  { "display",}
  /* TODO: Add more commands */

};

#define NR_CMD ARRLEN(cmd_table)

static int cmd_help(char *args) {
  /* extract the first argument */
  char *arg = strtok(NULL, " ");
  int i;

  if (arg == NULL) {
    /* no argument given */
    for (i = 0; i < NR_CMD; i ++) {
      printf("%s - %s\n", cmd_table[i].name, cmd_table[i].description);
    }
  }
  else {
    for (i = 0; i < NR_CMD; i ++) {
      if (strcmp(arg, cmd_table[i].name) == 0) {
        printf("%s - %s\n", cmd_table[i].name, cmd_table[i].description);
        return 0;
      }
    }
    printf("Unknown command '%s'\n", arg);
  }
  return 0;
}

void sdb_set_batch_mode() {
  is_batch_mode = true;
}

void sdb_mainloop() {
  if (is_batch_mode) {
    cmd_c(NULL);
    return;
  }

  for (char *str; (str = rl_gets()) != NULL; ) {
    char *str_end = str + strlen(str);

    /* extract the first token as the command */
    char *cmd = strtok(str, " ");
    if (cmd == NULL) { continue; }

    /* treat the remaining string as the arguments,
    * which may need further parsing
    */
    char *args = cmd + strlen(cmd) + 1;
    if (args >= str_end) {
      args = NULL;
    }
#ifdef CONFIG_DEVICE
    extern void sdl_clear_event_queue();
    sdl_clear_event_queue();
#endif

    int i;
    for (i = 0; i < NR_CMD; i ++) {
      if (strcmp(cmd, cmd_table[i].name) == 0) {
        if (cmd_table[i].handler(args) < 0) { return; }
        break;
      }
    }

    if (i == NR_CMD) { printf("Unknown command '%s'\n", cmd); }
  }
}

void init_sdb() {
  /* Compile the regular expressions. */
  init_regex();

  /* Initialize the watchpoint pool. */
  init_wp_pool();

  init_bp_pool();
}
