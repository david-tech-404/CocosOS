#include "log.h"
char log_buffer[4096];
int log_index = 0;
#define COM1 0x3F8
static inline void outb(unsigned short port, unsigned char value)
{
    __asm__ volatile ("outb %0, %1" : : "a"(value), "Nd"(port));
}
void log_init()
{
    outb(COM1 + 1, 0x00);
    outb(COM1 + 3, 0x80);
    outb(COM1 + 0, 0x03);
    outb(COM1 + 1, 0x00);
    outb(COM1 + 3, 0x03);
    outb(COM1 + 2, 0xC7);
    outb(COM1 + 4, 0x0B);
}
static int serial_ready()
{
    unsigned char status;
    __asm__ volatile ("inb %1, %0" : "=a"(status) : "Nd"(COM1 + 5));
    return status & 0x20; 
}
static void
serial_write_char(char c)
{
    while (!serial_ready());
    outb(COM1, c);
}
void log_write(const char* msg)
{
    while (*msg) {
        serial_write_char(*msg++);
    }
}
void log_info(const char* msg)
{
    log_write("[INFO] ");
    log_write(msg);
    log_write("\n");
}
void log_warn(const char* msg)
{
    log_write("[WARN] ");
    log_write(msg);
    log_write("\n");
}
void log_error(const char* msg)
{
    log_write("[ERROR] ");
    log_write(msg);
    log_write("\n");
}