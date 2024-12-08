
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>

#include "linkedlist.h"

// Complete the function definitions here

// TODO: Complete.
// To prepend an item to the front of the given list
node_t *cons(int data, node_t *list) {

  node_t *new_node = (node_t *)malloc(sizeof(node_t));
    if (new_node == NULL) {
        // to handle allocation failure
        exit(1);
    }
    new_node->data = data;
    new_node->next = list;
    return new_node;
}


// TODO: Complete.
// To get the first item in the list
int first(node_t *list) {
  assert(list); // to make sure the list is not empty
  
  return list->data;
}

// TODO: Complete.
// To get the rest of the list
node_t *rest(node_t *list) {
  assert(list); // to make sure the list is not empty
  
  return list->next;
}

// TODO: Complete.
// Check if the list is empty. Return 0 if it is not empty, non-0 otherwise
int is_empty(node_t *list) {
  
  return list == NULL;
}

// TODO: Complete.
// To print the whole list, one item at a time
void print_list(node_t *list) {
  
  node_t *current = list;
    while (current != NULL) {
        printf("%d\n", current->data);
        current = current->next;
    }
}

// TODO: Complete.
// To free the memory held by the whole list
void free_list(node_t *list) {
  
  node_t *current = list;
    while (current != NULL) {
        node_t *next_node = current->next;
        free(current);
        current = next_node;
    }
}


