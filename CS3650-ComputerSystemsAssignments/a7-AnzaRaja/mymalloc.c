#define _GNU_SOURCE
#include <malloc.h> 
#include <stdio.h> 
#include <unistd.h>
#include <stddef.h>

// Include any other headers we need here
#include <sys/mman.h>
#include <pthread.h>
#include <assert.h>
#include <stdint.h> // For SIZE_MAX

// NOTE: You should NOT include <stdlib.h> in your final implementation

#include <debug.h> // definition of debug_printf

#define BLOCK_SIZE sizeof(block_t)
#define PAGE_SIZE sysconf(_SC_PAGE_SIZE) // Added for a6

// Memory block structure to track allocations
typedef struct block {
    size_t size;         // Size of the allocated memory block (excludes metadata)
    int free;            // If this block is free (1) or allocated (0)
    struct block *next;  // Pointer to the next block in the list
} block_t;


// Global variables
static block_t *free_list = NULL;  // Head of the free list
static pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER; // Mutex for thread safety

// Helper function to align a size to the nearest page size
static size_t align_to_page(size_t size) {
    return (size + PAGE_SIZE - 1) & ~(PAGE_SIZE - 1);
}

// Helper function to find a free block by using first-fit
static block_t *find_free_block(size_t size) {
    block_t *current = free_list;
    while (current) {
        if (current->free && current->size >= size) {
            return current;
        }
        current = current->next;
    }
    return NULL;
}

static void add_to_free_list(block_t *block) {
    block->free = 1;
    block->next = NULL;

    // Debugging: Print initial state of the free list
    printf("Before adding block at %p (size: %zu):\n", block, block->size);
    
    if (!free_list) {
        free_list = block;
        return;
    }

    block_t *prev = NULL;
    block_t *current = free_list;

    // Traverse and debug
    while (current && current < block) {
        assert(current != NULL); // Ensure `current` is not NULL
        assert((uintptr_t)current % sizeof(void *) == 0); // Ensure memory is aligned
    
    
        prev = current;
        current = current->next;

        // add condition for when it should break out of the while loop(if null or if it found a block)
        if (current->next == NULL || current > block){
            break;
        } 
    }

    block->next = current;

    if (prev) {
        prev->next = block;
    } else {
        free_list = block;
    }

    current = free_list;

    // Coalesce adjacent blocks
    if (block->next && (char*)block + BLOCK_SIZE + block->size == (char*)block->next) {
        block->size += BLOCK_SIZE + block->next->size;
        block->next = block->next->next;
    }
    if (prev && (char*)prev + BLOCK_SIZE + prev->size == (char*)block) {
        prev->size += BLOCK_SIZE + block->size;
        prev->next = block->next;
    }

    // Debug after coalescing
    printf("After coalescing blocks:\n");
    current = free_list;
}

void *mymalloc(size_t s) {
    // Assignment 6 version
    // Allocate memory using mmap
    if (s <= 0) return NULL;

    pthread_mutex_lock(&lock);

    s += BLOCK_SIZE; // Include space for metadata
    block_t *block = find_free_block(s);

    if (block) {
        block->free = 0;
        pthread_mutex_unlock(&lock);
        return (void*)(block + 1);
    }

    size_t alloc_size = s < PAGE_SIZE ? PAGE_SIZE : align_to_page(s);
    block = mmap(NULL, (s + BLOCK_SIZE/PAGE_SIZE) * PAGE_SIZE, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANON, -1, 0);
    //block = mmap(NULL, alloc_size, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANON, -1, 0); old

    if (block == MAP_FAILED) {
        pthread_mutex_unlock(&lock);
        return NULL;
    }

    block->size = alloc_size - BLOCK_SIZE;
    block->free = 0;
    block->next = NULL;

    pthread_mutex_unlock(&lock);
    return (void*)(block + 1);
}

// Allocate and initialize memory
void *mycalloc(size_t nmemb, size_t s) {

    // Assignment 6 version
    // Check for overflow in size computation
    if (nmemb != 0 && s > SIZE_MAX / nmemb) {
        return NULL; // Prevent overflow
    }

    size_t total_size = nmemb * s;

    // Allocate memory
    void *ptr = mymalloc(total_size);
    if (ptr) {
        // Initialize memory to zero
        char *char_ptr = (char*)ptr;
        for (size_t i = 0; i < total_size; i++) {
            char_ptr[i] = 0;
        }
    }
    return ptr;
}

// Free allocated memory
void myfree(void *ptr) {
    // Assignment 6 version
    if (!ptr) return;

    pthread_mutex_lock(&lock);

    block_t *block = (block_t*)((char*)ptr - BLOCK_SIZE);

    if (block->size < PAGE_SIZE) {
        add_to_free_list(block);
    } else {
        munmap(block, block->size + BLOCK_SIZE);
    }

    pthread_mutex_unlock(&lock);
}
// check my free, coalescing