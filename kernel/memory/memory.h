#ifndef MEMORY_H
#define MEMORY_H

#include <stddef.h>

void Memory_init(void* start, size_t size);
void* Memory_alloc(size_t size);
void Memory_free(void* ptr);

#endif