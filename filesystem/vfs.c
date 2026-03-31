#include "vfs.h"
#include <string.h>

static vfs_node_t *root = 0;

void vfs_init() {
    root = 0;
}

static vfs_node_t* vfs_find(const char *name) {
    vfs_node_t *node = root;

    while (node) {
        int i = 0;
        while (name[i] && node->name[i] && name[i] == node->name[i]) {
            i++;
        }

        if (name[i] == 0 && node->name[i] == 0) {
            return node;
        }

        node = node->next;
    }

    return 0;    
}


int vfs_create(const char *name) {
    vfs_node_t *node = (vfs_node_t*)malloc(sizeof(vfs_node_t));
    
    if (!node) return 0;  // Check malloc success

    int i = 0;
    while (name[i] && i < MAX_NAME - 1) {  // Prevent buffer overflow
        node->name[i] = name[i];
        i++;
    }
    node->name[i] = 0;

    node->size = 0;
    node->data = 0;
    node->next = root;

    root = node;

    return 1;
}

int vfs_write(const char *name, const uint8_t *data, uint32_t size) {
    vfs_node_t *node = vfs_find(name);

    if (!node) return 0;

    // Free old data if exists to prevent memory leak
    if (node->data) {
        free(node->data);
    }

    node->data = (uint8_t*)malloc(size);
    
    if (!node->data) {  // Check malloc success
        node->size = 0;
        return 0;
    }

    for (uint32_t i = 0; i < size; i++) {
        node->data[i] = data[i];
    }

    node->size = size;

    return size;
}

int vfs_read(const char *name, uint8_t *buffer, uint32_t size) {
    vfs_node_t *node = vfs_find(name);

    if (!node || !buffer) return 0;  // Check for null pointers

    if (size > node->size) {
        size = node->size;
    }

    for (uint32_t i = 0; i < size; i++) {
        buffer[i] = node->data[i];
    }

    return size;
}
