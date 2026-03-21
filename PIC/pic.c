#include <stdint.h>
#include "pic.h"

#define PIC1_COMMANDD 0x20
#define PIC1_DATA 0X20
#define PIC2_COMMAND 0XA0
#define PIC2_DATA 0xA1

#define ICW1_INIT 0x10
#define ICW1_ICW4 0X01
#define ICW4_8086 0x01

static inline void outb(uint16_t port, uint8_t val) {
     __asm__ volatile ("outb %0, %01" : : "a"(val), "Nd"(port));
}

void pic_init() {
    outb(PIC1_COMMAND, ICW1_INIT | ICW1_ICW4);
    outb(PIC2_COMMAND, ICW1_INIT | ICW1_ICW4);

    outb(PIC1_DATA, 0x04);
    outb(PIC2_DATA, 0x02);

    outb(PIC1_DATA, ICW4_8086);
    outb(PIC2_DATA, ICW4_8086);

    outb(PIC1_DATA, 0xFC);

    outb(PIC2_DATA, 0xFF);
}