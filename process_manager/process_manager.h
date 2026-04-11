#ifndef PROCESS_MANAGER_H
#define PROCESS_MANAGER_H

typedef enum { STOPPED, RUNNIG, WAITING } process_state;

typedef struct {
    int pid;
    process_state state;
    void (*func)();
} process_t;

int create_process(void(*func)());
void kill_process(int pid);
void scheduler_tick();

#endif