#ifndef MOUSE_H
#define MOUSE_H

#include <stdint.h>

void mouse_init();
void mouse_interrupt_handler(registers_t *r);

int mouse_get_x(void);
int mouse_get_y(void);
unsigned char mouse_get_buttons(void);

#endif