#ifndef PROCESS_H
#define PROCESS_H

#include <stdint.h>
#include <stdbool.h>
#include "../kernel/memory/paging.h"

#define PROCESS_NAME_MAX 32
#define PROCESS_STACK_SIZE 0x40000
#define MAX_PROCESSES 8192

typedef enum {
    PROCESS_STOPPED,
    PROCESS_WAITING,
    PROCESS_RUNNING,
    PROCESS_SLEEPING,
    PROCESS_ZOMBIE
} process_state_t;

typedef struct cpu_state {
    uint32_t eax, ebx, ecx, edx;
    uint32_t esi, edi, ebp, esp;
    uint32_t eip, eflags, cs, ds, es, fs, gs;
    uint32_t cr3;
} __attribute__((packed)) cpu_state_t;

typedef struct process {
    uint32_t pid;
    uint32_t ppid;
    char name[PROCESS_NAME_MAX];
    process_state_t state;
    uint8_t priority;
    uint64_t runtime;
    uint32_t wakeup_tick;
    
    page_directory_t* page_dir;
    void* stack_top;
    cpu_state_t context;
    
    uint32_t uid;
    uint32_t gid;
    uint32_t permissions;
    
    struct process* next;
} process_t;

void process_init(void);
uint32_t process_create(void (*entry_point)(void), const char* name, uint8_t priority);
void process_kill(uint32_t pid);
void process_sleep(uint32_t ms);
void process_yield(void);
process_t* process_get_current(void);
uint32_t process_get_pid(void);

void scheduler_tick(void);
void scheduler_switch(void);

#endif