#include <stdint.h>

extern void context_switch(uint32_t* old_esp, uint32_t new_esp);

static task_t* current = 0;

void scheduler_init(void) {
}

void scheduler_add(task_t* task) {
    if (!current) {
        current = task;
        task->next = task;
    } else {
        task->next = current->next;
        current->next = task;
    }
}

void scheduler_tick(void) {
    if (!current) return;

    task_t* prev = current;
    current = current->next;

    context_switch(&prev->esp, current->esp);
}
