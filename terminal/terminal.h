#ifndef TERMINAL_H
#define TERMINAL_H

void terminal_init();
void terminal_write(const char *str);
void terminal_prompt();
void terminal_input(char c);

#endif