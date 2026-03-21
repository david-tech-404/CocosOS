#ifndef DISPLAY_H
#define DISPLAY_H

void display_clear();
void display_write_char(char c, int pos);

void display_print(const char* str, int row);

#endif