#include "paging.h"
#include "memory.h"
#include "../kernel.h"
#include "../panic_state.h"

static uint8_t* frame_bitmap = 0;
static size_t total_frames = 0;
static size_t used_frames = 0;

static page_directory_t* kernel_directory = 0;

extern void load_page_directory(uint32_t pd_phys);
extern void enable_paging(void);

void paging_init(size_t total_memory) {
    total_frames = total_memory / PAGE_SIZE;
    
    size_t bitmap_size = (total_frames + 7) / 8;
    frame_bitmap = (uint8_t*)Memory_alloc(bitmap_size);
    
    memset(frame_bitmap, 0xFF, bitmap_size);
    
    size_t start_frame = 0x100000 / PAGE_SIZE;
    for (size_t i = start_frame; i < total_frames; i++) {
        paging_free_frame(i);
    }
    
    kernel_directory = paging_create_directory();
    
    for (uint32_t addr = 0; addr < 0x400000; addr += PAGE_SIZE) {
        paging_map_page(kernel_directory, (void*)addr, PAGE_PRESENT | PAGE_WRITE);
    }
    
    paging_switch_directory(kernel_directory);
    enable_paging();
}

uint32_t paging_allocate_frame(void) {
    for (size_t i = 0; i < total_frames; i++) {
        uint32_t byte = i / 8;
        uint32_t bit = i % 8;
        
        if (!(frame_bitmap[byte] & (1 << bit))) {
            frame_bitmap[byte] |= (1 << bit);
            used_frames++;
            return i;
        }
    }
    panic("No hay frames de memoria libres!");
    return 0;
}

void paging_free_frame(uint32_t frame) {
    uint32_t byte = frame / 8;
    uint32_t bit = frame % 8;
    
    frame_bitmap[byte] &= ~(1 << bit);
    used_frames--;
}

size_t paging_get_free_frames(void) {
    return total_frames - used_frames;
}

page_directory_t* paging_create_directory(void) {
    page_directory_t* dir = (page_directory_t*)Memory_alloc(sizeof(page_directory_t));
    memset(dir, 0, sizeof(page_directory_t));
    
    dir->physical_address = (uint32_t)dir;
    
    return dir;
}

void paging_switch_directory(page_directory_t* dir) {
    load_page_directory(dir->physical_address);
}

void* paging_map_page(page_directory_t* dir, void* virtual_addr, uint32_t flags) {
    uint32_t virt = (uint32_t)virtual_addr;
    uint32_t pd_index = virt >> 22;
    uint32_t pt_index = (virt >> 12) & 0x3FF;
    
    if (!(dir->entries[pd_index] & PAGE_PRESENT)) {
        page_table_t* table = (page_table_t*)Memory_alloc(sizeof(page_table_t));
        memset(table, 0, sizeof(page_table_t));
        
        dir->entries[pd_index] = (uint32_t)table | flags | PAGE_PRESENT;
        dir->tables_virtual[pd_index] = table;
    }
    
    page_table_t* table = dir->tables_virtual[pd_index];
    
    if (!(table->entries[pt_index].present)) {
        uint32_t frame = paging_allocate_frame();
        table->entries[pt_index].frame = frame;
        table->entries[pt_index].present = 1;
        table->entries[pt_index].writable = (flags & PAGE_WRITE) ? 1 : 0;
        table->entries[pt_index].user = (flags & PAGE_USER) ? 1 : 0;
    }
    
    return virtual_addr;
}

void paging_unmap_page(page_directory_t* dir, void* virtual_addr) {
    uint32_t virt = (uint32_t)virtual_addr;
    uint32_t pd_index = virt >> 22;
    uint32_t pt_index = (virt >> 12) & 0x3FF;
    
    if (!(dir->entries[pd_index] & PAGE_PRESENT)) return;
    
    page_table_t* table = dir->tables_virtual[pd_index];
    
    if (table->entries[pt_index].present) {
        paging_free_frame(table->entries[pt_index].frame);
        table->entries[pt_index].present = 0;
    }
}

uint32_t paging_virtual_to_physical(page_directory_t* dir, void* virtual_addr) {
    uint32_t virt = (uint32_t)virtual_addr;
    uint32_t pd_index = virt >> 22;
    uint32_t pt_index = (virt >> 12) & 0x3FF;
    
    if (!(dir->entries[pd_index] & PAGE_PRESENT)) return 0;
    
    page_table_t* table = dir->tables_virtual[pd_index];
    
    if (!table->entries[pt_index].present) return 0;
    
    return (table->entries[pt_index].frame << 12) | (virt & 0xFFF);
}

bool paging_is_page_present(page_directory_t* dir, void* virtual_addr) {
    uint32_t virt = (uint32_t)virtual_addr;
    uint32_t pd_index = virt >> 22;
    uint32_t pt_index = (virt >> 12) & 0x3FF;
    
    if (!(dir->entries[pd_index] & PAGE_PRESENT)) return false;
    
    page_table_t* table = dir->tables_virtual[pd_index];
    
    return table->entries[pt_index].present;
}