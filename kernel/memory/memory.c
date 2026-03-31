#include "memory.h"

static unsigned char* heap_start;
static unsigned char* heap_current;
static unsigned char* heap_end;

void Memory_init(void* start, size_t size)
{
    heap_start = (unsigned char*)start;
    heap_current = heap_start;
    heap_end = heap_start + size;
}

void* Memory_alloc(size_t size)
{
    if (heap_current + size > heap_end)
        return 0;
    void* ptr = heap_current;
    heap_current += size;
    return ptr;
}

void Memory_free(void* ptr)
{
    // Note: This simple allocator doesn't support individual deallocation
    // In a real implementation, you would maintain a free list
    // For now, we just validate the pointer is within our heap
    if (ptr >= (void*)heap_start && ptr < (void*)heap_end) {
        // Mark as freed (simplified - real implementation would be more complex)
    }
}
