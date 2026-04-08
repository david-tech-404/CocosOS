#ifndef PANIC_STATE_H
#define PANIC_STATE_H
#define PANIC_NONE 0
#define PANIC_FATAL 1
extern volatile int kernel_panic_state;
extern volatile int kernel_panic_code;
void kernel_panic(int code);
#endif