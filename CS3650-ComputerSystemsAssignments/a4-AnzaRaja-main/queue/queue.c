/*
 * Queue implementation.
 *
 * - Implement each of the functions to create a working circular queue.
 * - Do not change any of the structs
 * - When submitting, You should not have any 'printf' statements in your queue 
 *   functions. 
 */
#include <assert.h>
#include <stdlib.h>

#include "queue.h"

/** The main data structure for the queue. */
struct queue{
  unsigned int back;      /* The next free position in the queue
                           * (i.e. the end or tail of the line) */
  unsigned int front;     /* Current 'head' of the queue
                           * (i.e. the front or head of the line) */
  unsigned int size;      /* How many total elements we currently have enqueued. */
  unsigned int capacity;  /* Maximum number of items the queue can hold */
  long *data;             /* The data our queue holds  */
};

/** 
 * Construct a new empty queue.
 *
 * Returns a pointer to a newly created queue.
 * Return NULL on error
 */
queue_t *queue_new(unsigned int capacity) {

  /* [TODO] Complete the function */

  queue_t *q = NULL;

  q = malloc(sizeof(queue_t));  // Allocate memory for the queue
    if (q == NULL) return NULL;  // Return NULL on allocation failure

    q->data = malloc(capacity * sizeof(long));  // Allocate memory for the data array
    if (q->data == NULL) {
        free(q);  // Free queue if data allocation fails
        return NULL;
    }

    q->front = 0;
    q->back = 0;
    q->size = 0;
    q->capacity = capacity;


  return q;
}

/**
 * Check if the given queue is empty.
 *
 * Returns a non-0 value if the queue is empty, 0 otherwise.
 */
int queue_empty(queue_t *q) {
  assert(q != NULL);   // To make sure the queue is not null

  /* [TODO] Complete the function */
  return (q->size == 0);  // Return non-zero if empty, otherwise 0
  
  //return 0;
}

/**
 * Check if the given queue is full.
 *
 * Returns a non-0 value if the queue is full, 0 otherwise.
 */
int queue_full(queue_t *q) {
  assert(q != NULL);  // To make sure the queue is not null

  /* [TODO] Complete the function */
  return (q->size == q->capacity);  // Return non-zero if full, otherwise 0

 // return 0;
}

/** 
 * Enqueue a new item.
 *
 * Push a new item into our data structure.
 */
void queue_enqueue(queue_t *q, long item) {
  assert(q != NULL);  // To make sure the queue is not null
  assert(q->size < q->capacity); // Make sure the queue is not full

  /* [TODO] Complete the function */
  q->data[q->back] = item;  // Adding the new item to the back of the queue
  q->back = (q->back + 1) % q->capacity;  // Wrapping around if necessary
  q->size++;  // Increment the size

}

/**
 * Dequeue an item.
 *
 * Returns the item at the front of the queue and removes an item from the 
 * queue.
 *
 * Note: Removing from an empty queue is an undefined behavior (i.e., it could 
 * crash the program)
 */
long queue_dequeue(queue_t *q) {
  assert(q != NULL);   // Make sure the queue is not null
  assert(q->size > 0); // Make sure the queue is not empty

  /* [TODO] Complete the function */
  long item = q->data[q->front];  // Getting the item from the front of the queue
  q->front = (q->front + 1) % q->capacity;  // Wrapping around if necessary
  q->size--;  // Decrement the size
  return item;  // Return the dequeued item
 // return -1;
}

/** 
 * Queue size.
 *
 * Queries the current size of a queue (valid size must be >= 0).
 */
unsigned int queue_size(queue_t *q) {
  assert(q != NULL); // Make the the queue is not null

  /* [TODO] Complete the function */
  return q->size;  // Return the current size of the queue

 // return 0;
}

/** 
 * Delete queue.
 * 
 * Remove the queue and all of its elements from memory.
 *
 * Note: This should be called before the proram terminates.
 */
void queue_delete(queue_t* q) {
  assert(q != NULL); // Make sure the queue is not null

  /* [TODO] Complete the function */
  free(q->data);  // Free the dynamically allocated array
  free(q);  // Free the queue structure
}

