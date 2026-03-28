#include "terminal.h"
#include "Display.h"
#include "keyboard.h"

char input_buffer[256];
int input_index = 0;

void terminal_init() {
    display_clear();
    terminal_write("Cocos-OS shell");
    terminal_prompt();
}

void terminal_write(const char *str) {
    while (*str) {
        display_putc(*str);
        str++;
    }
}

void terminal_prompt() {
    terminal_write("\n");
    terminal_write("cocos> ");
}

void terminal_input(char c) {
    if (c == '\n') {
        input_buffer[input_index] = 0;
        terminal_write("\n");
        input_index = 0;
        terminal_prompt();
        return;
    }

    if (input_index < 255) {
        input_buffer[input_index++] = c;
        display_putc(c);
    }
}