#include "isr.h"

isr_t interrupt_handlers[256];

void register_interrupt_handler(unsigned char n, isr_t handler) { 
    interrupt_handlers[n] = handler;
}