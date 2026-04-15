#include "shell.h"
#include "terminal.h"
#include <string.h>
#include <stdlib.h>

void shell_execute(char* cmd)
{
    char* argv[16];
    int argc = 0;
    
    char* token = strtok(cmd, " ");
    while (token && argc < 16) {
        argv[argc++] = token;
        token = strtok(NULL, " ");
    }
    
    if (argc == 0) return;

    if (strcmp(argv[0], "help") == 0)
    {
        terminal_write("Comandos disponibles:\n");
        terminal_write("  help\n");
        terminal_write("  clear\n");
        terminal_write("  about\n");
        terminal_write("  cpm\n");
    }
    else if (strcmp(argv[0], "clear") == 0)
    {
        terminal_clear();
    }
    else if (strcmp(argv[0], "about") == 0)
    {
        terminal_write("Cocos OS Alpha V1\n");
        terminal_write("Kernel: lilcos v1\n");
    }
    else if (strcmp(argv[0], "cpm") == 0)
    {
        extern void cpm_main(int argc, char** argv);
        cpm_main(argc, argv);
    }
    else
    {
        terminal_write("Comando desconocido\n");
    }
}