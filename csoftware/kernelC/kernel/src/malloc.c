#include "malloc.h"
#include "printk.h"
#include "string.h"
#include "stdbool.h"

extern char _end_kernel;

static void* theHeap = &_end_kernel;
static MEMORY_BLOCK_T* headptr;

static void printBlock(const MEMORY_BLOCK_T* ptr)
{
    printk(
        "%p: size: %d, free: %d, next: %8p, prev: %8p, ptr: %p\r\n", 
        (void*)ptr,
        ptr->size,
        ptr->free,
        (void*)ptr->next,
        (void*)ptr->prev,
        (void*)ptr->ptr
        );
}

void printBlocks(void)
{
    printk("\r\n");

    MEMORY_BLOCK_T* ptr = headptr;
    while(ptr)
    {
        printBlock(ptr);
        ptr = ptr->next;
    }

    printk("\r\n");
}

static void split_block(MEMORY_BLOCK_T* block, size_t size)
{
    size_t newBlockSize = size + BLOCK_SIZE;

    // create a new block in the heap by assigning it some memory on the heap
    MEMORY_BLOCK_T* newBlock = (MEMORY_BLOCK_T*)((char*)block->ptr + size);
    newBlock->size = block->size - (newBlockSize);
    newBlock->free = true;
    newBlock->next = block->next;
    newBlock->prev = block;
    newBlock->ptr = newBlock->data;

    block->next = newBlock;
    block->free = false;
    block->size = size;

    if(newBlock->next)
    {
        newBlock->next->prev = newBlock;
    }
}

static MEMORY_BLOCK_T* findBlock(const void* ptr)
{
    MEMORY_BLOCK_T* it = headptr;

    // iterate through the list until the block with exactly the pointer is found
    while(it)
    {
        if(it->ptr == ptr) return it;

        it = it->next;
    }

    return NULL;
}

static void merge_with_next(MEMORY_BLOCK_T* block)
{
    // merge block with the next if both are free
    if(block->next && block->next->free == true)
    {
        block->size += block->next->size + BLOCK_SIZE;
        block->next = block->next->next;
    }

    // when the next block is free and has size 0 we also delete the meta block of the next
    if(block->next && block->next->free == true && block->next->size == 0)
    {
        block->next = block->next->next;
        block->size += BLOCK_SIZE;
    }

    // if we removed a block we have to set the prev of the new next
    if(block->next)
    {
        block->next->prev = block;
    }
}

void free(const void* ptr)
{
    if(ptr == NULL) return;

    MEMORY_BLOCK_T* block = findBlock(ptr);

    if(block == NULL)
    {
        // fprintf(stderr, "Invalid pointer %p\r\n", ptr);
        return; 
    }

    // set block as free
    block->free = true;

    // try merging it with the previous block
    if(block->prev && block->prev->free)
    {
        merge_with_next(block->prev);
    }

    MEMORY_BLOCK_T* it = headptr;

    // keep merging blocks until no two adjacent blocks are free
    while(it)
    {
        if(it->free && it->next && it->next->free)
        {
            merge_with_next(it);
        }

        it = it->next;
    }
}

static MEMORY_BLOCK_T* findFreeBlock(size_t size)
{
    MEMORY_BLOCK_T* it = headptr;

    // iterate through all the blocks
    while(it != NULL)
    {
        // until one is free AND big enough
        if(it->free && it->size >= size)
        {
            break;
        }

        it = it->next;
    }

    // this in NULL if we exhausted all blocks, because the last next pointer in the list is obviously NULL
    return it;
}

void* realloc(void *ptr, size_t new_size)
{
    if(ptr == NULL)
    {
        return malloc(new_size);
    }

    MEMORY_BLOCK_T* block = findBlock(ptr);

    if(block == NULL)
    {
        printk("Invalid pointer %p\r\n", ptr);
        return NULL; 
    }

    if(new_size == block->size)
    {
        return block->ptr;
    }

    if(new_size < block->size)
    {
        merge_with_next(block);

        if(block->size > new_size)
        {
            split_block(block, new_size);
        }


        return block->ptr;
    }

    // new_size > block->size

    if(block->next && block->next->free && (block->size + block->next->size - BLOCK_SIZE) >= new_size)
    {
        merge_with_next(block);

        if(block->size + BLOCK_SIZE > new_size)
        {
            split_block(block, new_size);
        }

        return block->ptr;
    }

    void* newPtr = malloc(new_size);

    memcpy(newPtr, ptr, block->size);

    free(ptr);

    return newPtr;
}

void* calloc(size_t num, size_t size)
{
    size_t totalSize = num * size;

    // allocate the memory
    void* ptr = malloc(totalSize);

    if(ptr)
    {
        // set top zero if successful
        memset(ptr, 0, totalSize);
    }

    return ptr;
}

void* malloc(size_t size)
{
    if(size == 0) return NULL;

    size_t newBlockSize = size + BLOCK_SIZE;

    MEMORY_BLOCK_T* it = findFreeBlock(newBlockSize);
    
    if(NULL == it)
    {
        // fprintf(stderr, "No block of size %ld found.\r\n", size);
        return NULL;
    }

    split_block(it, size);

    return it->ptr;
}

// DEMO function for testing it in userspace
void init_c_malloc(size_t heapSize)
{
    // assert(heapSize > BLOCK_SIZE);

    // theHeap = malloc((sizeof(char) * (heapSize + BLOCK_SIZE)));

    MEMORY_BLOCK_T head = { 
        .next = NULL, 
        .prev = NULL,
        .size = (heapSize - BLOCK_SIZE),
        .free = true
    };

    memcpy(theHeap, &head, BLOCK_SIZE);
    headptr = (MEMORY_BLOCK_T*)theHeap;
    headptr->ptr = &headptr->data;
}

void free_c_malloc(void)
{
    // free(theHeap);
}