#include "keyboard.h"
#include "input.h"
#include "event.h"
#include <stdint.h>
event_t e;
e.type = EVENT_KEY;
e.data1 = scancode;
e.data2 = 0;
event_push(e);
void keyboard_irq_handler(uint8_t scancode) {
    input_event_t e;
    e.type = INPUT_KEYBOARD;
    e.data1 = scancode;
    input_push_event(e);
}
extern unsigned char ps2_read_scancode();
static char scancode_table[128] =
{
    0,
    '1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=', '_',8,
    9,
    'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p', '[', ']', 13,
    0,
    'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', '', ';', 39, '`',
    0,
    '\\', 'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/',
    0,
    '*',
    0,
    ' ',
};
char keyboard_read()
{
    unsigned char scancode = ps2_read_scancode();
    if (scancode > 127)
        return 0;
    return scancode_table[scancode];
}