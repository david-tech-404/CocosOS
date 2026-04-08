#include "panic_state.h"
volatile int kernel_panic_state = PANIC_NONE;
volatile int kernel_panic_code = 0;
void kernel_panic(int code) {
    kernel_panic_code = code;
    kernel_panic_state = PANIC_FATAL;
    arch_disable_interrupts();
    for (;;) {}
}