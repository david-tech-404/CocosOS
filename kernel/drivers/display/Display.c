#include "Display.h"
extern void display_clear();
extern void display_write_char(char c, int pos);
void display_print(const char* str, int row)
{
    int pos = row * 80;
    int i = 0;
    while (str[i])
    {
        display_write_char(str[i], pos + i);
            i++;
    }
}