#include "shell.h"
#include "terminal.h"
#include <string.h>

void shell_execute(char* cmd)
{

    if (strcmp(cmd, "help") == 0)
    {

        terminal_write("Commands:\n");

        terminal_write("help\n");

        terminal_write("clear\n");
        
        terminal_write("about\n");
    }

    else if (strcmp(cmd, "clear") == 0)
    {
        terminal_clear();
    }
    else if (strcmp(cmd, "about") == 0)
    {
        terminal_write("Cocos OS Alpha V1\n");
        terminal_write("Kernel: lilcos v1\n");
    }

    else
    {
        terminal_write("Unknown command\n");
    }
}