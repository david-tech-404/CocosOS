#ifndef SCHEDULER_H
#define SCHEDULER_H
#include <stdint.h>
typedef struct  task {
    uint32_t esp;
    struct task* next;
} task_t;
void scheduler_init(void);
void scheduler_add(task_t* task);
void scheduler_tick(void);
#endif