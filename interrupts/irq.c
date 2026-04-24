#include "irq.h"
#include "../timer/timer.h"
#include "../PIC/pic.h"
#include "../scheduler/scheduler.h"

void irq0_handler_c(void) {
    scheduler_tick();

    __asm__ volatile("outb %0, %1" : : "a"(0x20), "Nd"(0x20));
}
