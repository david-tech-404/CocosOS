#ifndef VFS_H
#define VFS_H

#include <stdint.h>

#define MAX_NAME 32

typedef struct vfs_node {
    char name[32];
    uint32_t size;
    uint8_t *data;
    struct vfs_node *next;
} vfs_node_t;

void vfs_init();
int vfs_create(const char *name);
int vfs_write(const char *name, const uint8_t *data, uint32_t size);
int vfs_read(const char *name, uint8_t *buffer, uint32_t size);

#endif