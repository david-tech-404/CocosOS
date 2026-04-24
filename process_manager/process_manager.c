#include <stdint.h>
#include <stddef.h>
#include <string.h>
#include "process_manager.h"

#define MAX_PROCESSES 10

process_t process_table[MAX_PROCESSES];

int process_count = 0;

int create_process(void(*func)(void)) {
    if(process_count >= MAX_PROCESSES) return -1;
    
    process_table[process_count].pid = process_count;
    process_table[process_count].state = WAITING;
    process_table[process_count].func = func;
    
    process_count++;
    return process_count - 1;
}

void kill_process(int pid) {
    if(pid < 0 || pid >= process_count) return;
    process_table[pid].state = STOPPED;
    memset(&process_table[pid], 0, sizeof(process_t));
}

void scheduler_tick(void) {
    for(int i = 0; i < process_count; i++) {
        if(process_table[i].state == WAITING) {
            process_table[i].state = RUNNING;
            process_table[i].func();
            process_table[i].state = WAITING;
        }
    }
}
