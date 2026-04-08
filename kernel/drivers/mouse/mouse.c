#include "mouse.h"
#include "io.h"
#include "isr.h"
#include "input.h"
void mouse_irq_handler(uint8_t buttons, int8_t dx, int8_t dy)
{
    event_t e;
    e.type = EVENT_MOUSE;
    e.data1 = mouse_x;
    e.data2 = mouse_y;
    event_push(e);
    input_event_t ie;
    ie.type = INPUT_MOUSE;
    ie.data1 = buttons;
    ie.data2 = dx;
    ie.data3 = dy;
    input_push_event(ie);
}
static int mouse_cycle = 0;
static signed char mouse_byte[3];
static int mouse_x = 0;
static int mouse_y = 0;
static unsigned char mouse_button = 0;
static void mouse_wait(unsigned char type)
{
    unsigned int timeout = 100000;
    if (type == 0) {
        while (timeout--) {
            if (inb(0x64) & 1) return;
        }
    } else {
        while (timeout--) {
            if (!(inb(0x64) & 2)) return;
        }
    }
}
static void mouse_write(unsigned char data)
{
    mouse_wait(1);
    outb(0x64, 0xD4);
    mouse_wait(1);
    outb(0x60, data);
}
unsigned char mouse_read() {
    mouse_wait(0);
    return inb(0x60);
}
void mouse_handler(register_t *r) {
    unsigned char status = inb(0x64);
    if (!(status & 0x20)) return;
    mouse_byte[mouse_cycle] = mouse_read() & 0x07;
    mouse_cycle++;
    if (mouse_cycle == 3) {
        mouse_button = mouse_byte[0] & 0x07;
        mouse_x += mouse_byte[1];
        mouse_y -= mouse_byte[2];
        mouse_cycle = 0;
    }
}
void mouse_init() {
    mouse_wait(1);
    outb(0x64, 0xA8);
    mouse_wait(0);
    unsigned char status = inb(0x60);
    status |= 2;
    mouse_wait(1);
    outb(0x64, 0x60);
    mouse_wait(1);
    outb(0x60, status);
    mouse_write(0xF6);
    mouse_read();
    mouse_write(0xF4);
    mouse_read();
    register_interrupt_handler(12, mouse_handler);
}
int mouse_get_x() { return mouse_x; }
int mouse_get_y() { return mouse_y; }
unsigned char mouse_get_buttons() { return mouse_button; }