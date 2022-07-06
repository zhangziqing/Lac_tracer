#include <sdb.h>
#include <npc.h>

#define NR_WP 32

static WP wp_pool[NR_WP] = {};
static WP *head = NULL, *free_ = NULL;


void init_wp_pool() {
  int i;
  for (i = 0; i < NR_WP; i ++) {
    wp_pool[i].NO = i;
    wp_pool[i].next = (i == NR_WP - 1 ? NULL : &wp_pool[i + 1]);
  }

  head = NULL;
  free_ = wp_pool;
}
bool new_wp(WP** res){
  WP* p = free_;
  if (free_ == NULL){
    return p;
  }
  free_ = free_->next;
  WP* q = head;
  head = p;
  p->next = q;
  *res = p;
  return true;
}
static void free_wp_by_point(WP *wp){

  if (wp == head){
    head = head -> next;
    wp->next = free_;
    free_ = wp->next;
    return;
  }
  WP *p,*q;
  p = head;
  q = head;
  while (p != wp && p!=NULL) {
    q = p;
    p = p->next;
  }
  if (p == NULL){
    printf("Invalid watchpoint N\n");
    return ;
  }
  q->next = p->next;
  p->next = free_;
  free_ = p;
}
void free_wp(int N){
  if (N < 0 || N > NR_WP){
    printf("Invalid watchpoint N\n");
  }
  free_wp_by_point(wp_pool + N);
}
void info_watchpoint(){
  WP* p = head;
  while(p!=NULL){
    printf("%d\t:%s\n",p->NO,p->expr);
    p = p->next;
  }
}
inline static bool check_single_watchpoint(WP* p){
  bool status;
  word_t res = expr(p->expr,&status);
  if (status && res == p->val){
    return true;
  }
  printf("[%s] = %x\n",p->expr,res);
  p->val = res; 
  return false;
}
bool check_watchpoint(){
  WP* p = head;
  bool res = true;
  while (p)
  {
    res = res && check_single_watchpoint(p);
    p = p -> next;
  }
  return res;
}
