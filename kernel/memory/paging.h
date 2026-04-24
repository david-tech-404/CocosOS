#ifndef PAGING_H
#define PAGING_H

#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#define PAGE_SIZE       4096
#define PAGE_TABLE_ENTRIES 1024
#define PAGE_DIR_ENTRIES   1024

#define PAGE_PRESENT  0x1
#define PAGE_WRITE    0x2
#define PAGE_USER     0x4
#define PAGE_WRITE_THROUGH 0x8
#define PAGE_CACHE_DISABLE 0x10
#define PAGE_ACCESSED 0x20
#define PAGE_DIRTY    0x40
#define PAGE_4MB      0x80

typedef struct {
    uint32_t present    : 1;
    uint32_t writable   : 1;
    uint32_t user       : 1;
    uint32_t write_through : 1;
    uint32_t cache_disable : 1;
    uint32_t accessed   : 1;
    uint32_t dirty      : 1;
    uint32_t reserved   : 2;
    uint32_t available  : 3;
    uint32_t frame      : 20;
} __attribute__((packed)) page_table_entry_t;

typedef struct {
    page_table_entry_t entries[PAGE_TABLE_ENTRIES];
} page_table_t;

typedef struct {
    uint32_t entries[PAGE_DIR_ENTRIES];
    page_table_t* tables_virtual[PAGE_DIR_ENTRIES];
    uint32_t physical_address;
} page_directory_t;

void paging_init(size_t total_memory);
page_directory_t* paging_create_directory(void);
void paging_switch_directory(page_directory_t* dir);
void* paging_map_page(page_directory_t* dir, void* virtual_addr, uint32_t flags);
void paging_unmap_page(page_directory_t* dir, void* virtual_addr);
uint32_t paging_virtual_to_physical(page_directory_t* dir, void* virtual_addr);
bool paging_is_page_present(page_directory_t* dir, void* virtual_addr);

uint32_t paging_allocate_frame(void);
void paging_free_frame(uint32_t frame);
size_t paging_get_free_frames(void);

#endif
