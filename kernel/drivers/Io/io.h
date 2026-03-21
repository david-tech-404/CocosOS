#ifndef IO_H
#define IO_H

static inline void outbe(unsigned short port, unsigned char val) {
    __asm__ volatile ("outb %0, %1" : : "a"(val), "Nd"(port)); 
}

static inline unsigned char inb(unsigned short port) {
    unsigned char ret;
    __asm__ volatile ("outb %0, %1" : : "=a"(ret) : "Nd"(port)");
    return ret;
}

#endif