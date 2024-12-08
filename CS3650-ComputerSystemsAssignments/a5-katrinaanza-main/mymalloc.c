#define _DEFAULT_SOURCE
#define _BSD_SOURCE 
#include <malloc.h> 
#include <stdio.h> 
#include <unistd.h>
#include <stddef.h>

// Include any other headers we need here

// NOTE: You should NOT include <stdlib.h> in your final implementation

#include <debug.h> // definition of debug_printf

#define BLOCK_SIZE sizeof(block_t)

// Memory block structure to track allocations
typedef struct block {
    size_t size;         // Size of the allocated memory block (excludes metadata)
    int free;            // If this block is free (1) or allocated (0)
    struct block *next;  // Pointer to the next block in the list
} block_t;

// Global head pointer to the start of the linked list
static block_t *head = NULL;

// Helper function to find a suitable block using first-fit
static block_t *find_free_block(size_t size) {
    block_t *current = head;
    while (current != NULL) {
        if (current->free && current->size >= size) {
            return current;
        }
        current = current->next;
    }
    return NULL;
}

// Helper function to request new memory using sbrk
static block_t *request_memory(size_t size) {
    block_t *block = (block_t*)sbrk(BLOCK_SIZE + size);
    if ((void*)block == (void*)-1) {
        return NULL;  // sbrk failed
    }

    block->size = size;
    block->free = 0;
    block->next = NULL;

    return block;
}


void *mymalloc(size_t s) {

/*
  void *p = (void *) malloc(s); // In your solution no calls to malloc should be
                               // made! Determine how you will request memory :)

  if (!p) {
    // We are out of memory
    // if we get NULL back from malloc
  }
  debug_printf("malloc %zu bytes\n", s);

  return p;
  */

  if (s <= 0) return NULL;

    // Try to find a suitable free block
    block_t *block = find_free_block(s);
    if (block != NULL) {
        block->free = 0; // Mark block as allocated
        debug_printf("Malloc %zu bytes\n", s);
        return (void*)(block + 1); // Return memory address after the metadata
    }

    // No suitable free block found; request new memory
    block = request_memory(s);
    if (block == NULL) return NULL; // Out of memory

    // Add new block to the list
    if (head == NULL) {
        head = block; // Initialize head if list is empty
    } else {
        block_t *current = head;
        while (current->next != NULL) {
            current = current->next;
        }
        current->next = block; // Append new block to the end of the list
    }

    debug_printf("Malloc %zu bytes\n", s);
    return (void*)(block + 1); // Return usable memory after metadata
}

void *mycalloc(size_t nmemb, size_t s) {

/*
  void *p = (void *) calloc(nmemb, s); // In your solution no calls to calloc should be
                                       // made! Determine how you will request memory :)

  if (!p) {
    // We are out of memory
    // if we get NULL back from malloc
  }
  debug_printf("calloc %zu bytes\n", s);

  return p;
  */

  size_t total_size = nmemb * s;
    void *ptr = mymalloc(total_size);
    if (ptr == NULL) return NULL;

    // Initialize allocated memory to zero
    char *char_ptr = (char*)ptr;
    for (size_t i = 0; i < total_size; i++) {
        char_ptr[i] = 0;
    }

    debug_printf("Calloc %zu bytes\n", total_size);
    return ptr;
}

void myfree(void *ptr) {
  /*
  debug_printf("Freed some memory\n");

  // Replace the free below with your own free implementation
  free(ptr);
  */

  if (ptr == NULL) return;

    // Retrieve the block metadata
    block_t *block = (block_t*)((char*)ptr - BLOCK_SIZE);
    block->free = 1; // Mark the block as free

    debug_printf("Freed %zu bytes\n", block->size);
}
