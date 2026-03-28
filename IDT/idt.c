#include <stdint.h>

#define IDT_ENTRIES 256

struct idt_entry {
    uint16_t base_low;
    uint16_t selector;
    uint8_t zero;
    uint8_t flags;
    uint16_t base_high;
} __attribute__((packed));

struct idt_ptr {
    uint16_t limit;
    uint32_t base;
} __attribute__((packed));

static struct idt_entry idt[IDT_ENTRIES];
static struct idt_ptr idtp;

extern void idt_load(uint32_t);

static void idt_set_gate(
    int n,
    uint32_t base,     
    uint16_t selector,
    uint16_t flags
) 
{ 
    idt[n].base_low = (uint16_t)(base & 0xFFFF);
    idt[n].base_high = (uint16_t)((base >> 16) & 0xFFFF);
    idt[n].selector = selector;
    idt[n].zero = 0;
    idt[n].flags = (uint8_t)flags;
}

void idt_init(void) {
    idtp.limit = (uint16_t)(sizeof(idt) - 1);
    idtp.base = (uint32_t)&idt;

    extern void irq0_handler(void);

    idt_set_gate(32, (uint32_t)irq0_handler, 0x08, 0x8E);
    
    idt_load((uint32_t)&idtp);
}
