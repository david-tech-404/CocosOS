#include "vfs.h"
void ramfs_init() {
    vfs_init();
    vfs_create("welcome.txt");
    const uint8_t msg[] = "Bienvenido a Cocos OS";
    vfs_write("welcome.txt", msg, sizeof(msg));
}