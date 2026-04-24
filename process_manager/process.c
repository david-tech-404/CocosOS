#include "process.h"
#include "../kernel/kernel.h"
#include "../kernel/memory/memory.h"
#include "../timer/timer.h"

static process_t* process_list = 0;
static process_t* current_process = 0;
static uint32_t next_pid = 1;

extern void switch_context(cpu_state_t* old, cpu_state_t* new);

void process_init(void) {
    process_t* idle = (process_t*)Memory_alloc(sizeof(process_t));
    memset(idle, 0, sizeof(process_t));
    
    idle->pid = 0;
    idle->ppid = 0;
    strcpy(idle->name, "idle");
    idle->state = PROCESS_RUNNING;
    idle->priority = 0;
    idle->page_dir = paging_create_directory();
    
    process_list = idle;
    current_process = idle;
}

uint32_t process_create(void (*entry_point)(void), const char* name, uint8_t priority) {
    process_t* proc = (process_t*)Memory_alloc(sizeof(process_t));
    memset(proc, 0, sizeof(process_t));
    
    proc->pid = next_pid++;
    proc->ppid = current_process->pid;
    strncpy(proc->name, name, PROCESS_NAME_MAX - 1);
    proc->state = PROCESS_WAITING;
    proc->priority = priority;
    
    proc->page_dir = paging_create_directory();
    
    proc->stack_top = (void*)Memory_alloc(PROCESS_STACK_SIZE);
    memset(proc->stack_top, 0, PROCESS_STACK_SIZE);
    
    proc->context.esp = (uint32_t)proc->stack_top + PROCESS_STACK_SIZE - 4;
    proc->context.eip = (uint32_t)entry_point;
    proc->context.eflags = 0x202;
    proc->context.cr3 = proc->page_dir->physical_address;
    
    proc->next = process_list;
    process_list = proc;
    
    return proc->pid;
}

void process_kill(uint32_t pid) {
    process_t* proc = process_list;
    
    while (proc) {
        if (proc->pid == pid) {
            proc->state = PROCESS_ZOMBIE;
            return;
        }
        proc = proc->next;
    }
}

void process_sleep(uint32_t ms) {
    current_process->wakeup_tick = timer_get_ticks() + ms;
    current_process->state = PROCESS_SLEEPING;
    scheduler_switch();
}

void process_yield(void) {
    scheduler_switch();
}

process_t* process_get_current(void) {
    return current_process;
}

uint32_t process_get_pid(void) {
    return current_process->pid;
}

void scheduler_tick(void) {
    process_t* proc = process_list;
    
    while (proc) {
        if (proc->state == PROCESS_SLEEPING && timer_get_ticks() >= proc->wakeup_tick) {
            proc->state = PROCESS_WAITING;
        }
        proc = proc->next;
    }
    
    scheduler_switch();
}

void scheduler_switch(void) {
    process_t* next = process_list;
    process_t* best = 0;
    uint8_t best_priority = 0xFF;
    
    while (next) {
        if (next->state == PROCESS_WAITING && next->priority < best_priority) {
            best_priority = next->priority;
            best = next;
        }
        next = next->next;
    }
    
    if (!best) {
        best = process_list;
    }
    
    if (best == current_process) {
        return;
    }
    
    current_process->state = PROCESS_WAITING;
    best->state = PROCESS_RUNNING;
    
    process_t* old = current_process;
    current_process = best;
    
    switch_context(&old->context, &best->context);
}