#include "memory.h"
#include <stddef.h>
#include <stdint.h>

typedef struct block_header {
    size_t size;
    uint8_t used;
    struct block_header* next;
} block_header_t;

static block_header_t* heap_start;
static block_header_t* heap_end;

void Memory_init(void* start, size_t size)
{
    heap_start = (block_header_t*)start;
    heap_start->size = size - sizeof(block_header_t);
    heap_start->used = 0;
    heap_start->next = NULL;
    heap_end = (block_header_t*)((uint8_t*)start + size);
}

static void coalesce()
{
    block_header_t* current = heap_start;
    
    while (current != NULL && current->next != NULL) {
        if (!current->used && !current->next->used) {
            current->size += current->next->size + sizeof(block_header_t);
            current->next = current->next->next;
        } else {
            current = current->next;
        }
    }
}

void* Memory_alloc(size_t size)
{
    if (size == 0) return NULL;
    
    size = (size + 3) & ~3;
    block_header_t* current = heap_start;
    
    while (current != NULL) {
        if (!current->used && current->size >= size) {
            if (current->size > size + sizeof(block_header_t) + 4) {
                block_header_t* new_block = (block_header_t*)((uint8_t*)current + sizeof(block_header_t) + size);
                new_block->size = current->size - size - sizeof(block_header_t);
                new_block->used = 0;
                new_block->next = current->next;
                current->next = new_block;
                current->size = size;
            }
            current->used = 1;
            return (uint8_t*)current + sizeof(block_header_t);
        }
        current = current->next;
    }
    return NULL;
}

void Memory_free(void* ptr)
{
    if (!ptr) return;
    if ((block_header_t*)ptr < heap_start || (block_header_t*)ptr >= heap_end) return;
    
    block_header_t* block = (block_header_t*)((uint8_t*)ptr - sizeof(block_header_t));
    block->used = 0;
    coalesce();
}

size_t Memory_get_free()
{
    size_t total = 0;
    block_header_t* current = heap_start;
    
    while (current != NULL) {
        if (!current->used) {
            total += current->size;
        }
        current = current->next;
    }
    return total;
}