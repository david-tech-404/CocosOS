#include "cpm.h"
#include "../terminal/terminal.h"
#include "../filesystem/fs.h"
#include <string.h>

#define VERSION "0.1.0"

void cpm_help() {
    terminal_write("Cocos Package Manager\n");
    terminal_write("Uso: cpm <comando>\n\n");
    terminal_write("Comandos:\n");
    terminal_write("  init      Inicializar proyecto\n");
    terminal_write("  install   Instalar paquete\n");
    terminal_write("  remove    Eliminar paquete\n");
    terminal_write("  list      Listar paquetes\n");
    terminal_write("  update    Actualizar paquetes\n");
    terminal_write("  version   Mostrar version\n");
}

void cpm_init() {
    terminal_write("Inicializando proyecto CPM\n");
    fs_mkdir("/.cpm");
    fs_mkdir("/.cpm/packages");
    terminal_write("Estructura creada correctamente\n");
}

void cpm_install(int argc, char** argv) {
    char ruta[64];
    if (argc < 3) {
        terminal_write("Instalando todas las dependencias\n");
        return;
    }

    terminal_write("Instalando: ");
    terminal_write(argv[2]);
    terminal_write("\n");

    strcpy(ruta, "/.cpm/packages/");
    strcat(ruta, argv[2]);
    fs_mkdir(ruta);

    terminal_write("Paquete instalado\n");
}

void cpm_list() {
    terminal_write("\nPaquetes instalados:\n");
    terminal_write("--------------------\n");
    
    terminal_write("  (listado de paquetes)\n");
    
    terminal_write("--------------------\n");
}

void cpm_remove(int argc, char** argv) {
    if (argc < 3) {
        terminal_write("Especifique nombre de paquete\n");
        return;
    }
    
    terminal_write("Eliminando: ");
    terminal_write(argv[2]);
    terminal_write("\n");
    terminal_write("Paquete eliminado\n");
}

void cpm_main(int argc, char** argv) {
    if (argc == 1) {
        cpm_help();
        return;
    }

    if (strcmp(argv[1], "help") == 0) {
        cpm_help();
    } else if (strcmp(argv[1], "init") == 0) {
        cpm_init();
    } else if (strcmp(argv[1], "install") == 0) {
        cpm_install(argc, argv);
    } else if (strcmp(argv[1], "remove") == 0) {
        cpm_remove(argc, argv);
    } else if (strcmp(argv[1], "list") == 0) {
        cpm_list();
    } else if (strcmp(argv[1], "version") == 0) {
        terminal_write("CPM v");
        terminal_write(VERSION);
        terminal_write("\n");
    } else {
        terminal_write("Comando desconocido\n");
        cpm_help();
    }
}