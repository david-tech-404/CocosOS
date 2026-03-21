#include "memory.h"

static unsigned char* heap_start;
static unsigned char* keap_current;
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
    
}