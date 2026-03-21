#ifndef ISR_h
#define ISR_H

typedef struct registers {
    unsigned int ds;
    unsigned int edi, esi, edp, esp, ebx, edx, ecx, eax;
    unsigned int int_no, err_code;
    unsigned int eip, cs, eflags, usersp, ss;
} registers_t;

typedef void (*isr_t) (registers_t*);

void register_interrupt_handler(unsigned char n, isr_t handler);

#endif