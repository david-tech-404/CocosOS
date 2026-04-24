#ifndef COCOSFS_H
#define COCOSFS_H

#include <stdint.h>
#include <stdbool.h>

#define COCOSFS_MAGIC 0x434F434F
#define COCOSFS_VERSION 1
#define COCOSFS_BLOCK_SIZE 4096
#define COCOSFS_NAME_MAX 128

typedef struct {
    uint32_t magic;
    uint16_t version;
    uint64_t total_blocks;
    uint64_t free_blocks;
    uint32_t root_block;
    uint32_t block_bitmap_start;
    uint32_t node_bitmap_start;
    uint32_t node_table_start;
    uint32_t data_start;
    uint32_t checksum;
} __attribute__((packed)) cocosfs_superblock_t;

typedef enum {
    NODE_FILE,
    NODE_DIRECTORY,
    NODE_SYMLINK
} node_type_t;

typedef struct {
    uint32_t id;
    uint64_t size;
    node_type_t type;
    uint64_t created;
    uint64_t modified;
    uint32_t blocks[256];
    uint32_t parent;
    char name[COCOSFS_NAME_MAX];
} __attribute__((packed)) cocosfs_node_t;

void cocosfs_init(uint32_t drive_port);
bool cocosfs_format(uint32_t drive_port);
bool cocosfs_mount(uint32_t drive_port);
bool cocosfs_create(const char* path, node_type_t type);
bool cocosfs_delete(const char* path);
int cocosfs_read(const char* path, uint8_t* buffer, uint64_t offset, uint32_t size);
int cocosfs_write(const char* path, const uint8_t* buffer, uint64_t offset, uint32_t size);
uint64_t cocosfs_get_size(const char* path);
bool cocosfs_exists(const char* path);

#endif