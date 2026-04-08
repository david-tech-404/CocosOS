#include "pic.h"
static inline void outb(uint16_t port, uint8_t val) {
    __asm__ volatile ("outb %0,%1" : : "a"(val), "Nd"(port));
}
void pit_init(uint32_t frequency) {
    uint32_t divisor = 1193180 / frequency;
    outb(0x43, 0x36);
    outb(0x40, divisor & 0xFF);
    outb(0x40, divisor >> 8);
}