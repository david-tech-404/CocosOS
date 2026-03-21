#include <stdint.h>

extern void context_switch(uint32_t* old_esp, uinit32_t new_esp);

static task_t* current = 0;

void scheduler_init(void) {

void scheduler_add(task_t* task) {

    if (!current) {
        current = task;
        task->next = task;
    } else {
        task->next = current->nect;
        current->next = task;
    }
}

void scheduler_tick(void) {
    if (!cuurrent) return;

    task_t* prev = current;
    current = current->next;

    context_switch(&prev->esp,current->esp);
}