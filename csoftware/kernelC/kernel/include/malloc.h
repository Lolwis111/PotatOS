#ifndef _C_MALLOC_H_
#define _C_MALLOC_H_

#include "stdbool.h"
#include "stddef.h"

typedef struct MEMORY_BLOCK_S
{
    struct MEMORY_BLOCK_S* next;
    struct MEMORY_BLOCK_S* prev;
    void* ptr;
    size_t size;
    bool free;
    char data[1];
} MEMORY_BLOCK_T;

#define BLOCK_SIZE (sizeof(MEMORY_BLOCK_T))

void printBlocks(void);

void free(const void* ptr);

void* malloc(size_t size);

void* calloc (size_t num, size_t size);

void* realloc(void *ptr, size_t new_size);

void init_c_malloc(size_t heapSize);

void free_c_malloc(void);

#endif