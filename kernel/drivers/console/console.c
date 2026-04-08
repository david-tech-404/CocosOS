#include "console.h"
#include "Display.h"
#include "keyboard.h"
static int cursor = 0;
void console_init()
{
    display_clear();
    cursor = 0;
}
void console_update()
{
    char c = keyboard_read();
    if (!c)
        return;
    if (c == 13)
    {
        cursor = ((cursor / 80) + 1) * 80;
        return;
    }
    if (c == 8)
    {
        if (cursor > 0)
        {
            {
                cursor--;
display_write_char(' ', cursor);
            }
            return;
        }
        display_write_char(c, cursor);
            cursor++;
    }
}