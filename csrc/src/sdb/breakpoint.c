#include "sdb.h"

#define NR_BP 32

static BP bp_pool[NR_BP] = {};
static BP* _head  = NULL, *_free = NULL;

void init_bp_pool() {
    int i;
    for (i = 0; i < NR_BP - 1; i++){
        bp_pool[i].NO = i;
        bp_pool[i].next = &bp_pool[i+1];
    }
    bp_pool[NR_BP - 1].next = NULL;
    _head = NULL;
    _free = bp_pool;
}

bool new_bp(BP **res){
    BP *p = _free;
    if( _free == NULL){
        return p;
    }
    _free = _free->next;
    BP* q = _head;
    _head = p;
    p->next = q;
    *res = p;
    return true;
}

static void free_bp_by_point(BP *bp){
    if (bp == NULL){
        return;
    }
    if (bp == _head){
        _head = _head -> next;
        bp->next = _free;
        return;
    }
    BP *p,*q;
    p = _head;
    q = _head;
    while (p != bp && p != NULL){
        q = p;
        p = p->next;
    }
    if (p == NULL) {
        printf("Invalid watchpoint N\n");
        return ;
    }
    q->next = p->next;
    p->next = _free;
    _free = p;
}

void info_breakpoint(){
    BP* bp = _head;
    while (bp != NULL){
        printf("%d:\t:%lx",bp->NO,bp->address);
        bp = bp->next;
    }
}

bool check_breakpoint(uint64_t addr){
    BP *bp = _head;
    while(bp){
        if (bp->address == addr){
            printf("breakpoint at 0x%lx\n",addr);
            return true;
        }
        bp = bp->next;
    }
    return false;
}

void free_bp(int N){
    if (N <= 0 || N > NR_BP){
        printf("Invalid break point number\n");
    }
    free_bp_by_point(bp_pool + N);
}