#ifndef VFS_H
#define VSF_H

#include <stdint.h>

typedef struct vfs_node {
    char name[32];
    uint32_t size;
    uint8_t *data;
    struct vfs_node *next;
} vfs_node_t;

void vfs_init();
int vfs_create(const char *name);
int vfs_write(const char *name, const uint8_t *data, *name, const uint32_t size);
int vfs_read(const char *name, uint8_t *buffer, uint32_t size);

#endif