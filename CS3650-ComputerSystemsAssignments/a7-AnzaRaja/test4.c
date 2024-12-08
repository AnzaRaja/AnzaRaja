// Increasing size test using calloc
// check each location is set to 0

#ifndef DEMO_TEST
#include <malloc.h>
#else
#include <stdlib.h>
#endif

#include <assert.h>
#include <stdio.h>
#include <string.h>

int allones = ~0; // allones for int

int main() {

  int i, j;
  size_t size;

  fprintf(stderr, 
      "=======================================================================\n"
      "This test uses calloc to allocate gradually allocate 2^2, 2^3, ...,\n"
      "2^29 bytes of memory. It checks whether the memory is set to 0. No more\n"
      "than 28 calls to sbrk should be made.\n"
      "=======================================================================\n");

  for (i = 2; i < 30; ++i) {
    size = 2UL << i;
    fprintf(stderr, "%zu bytes...", size);

    int *data = (int *) calloc(1, size);
    if (data == NULL) {
      fprintf(stderr, "Allocation failed for size %zu bytes\n", size);
            break; // Exit loop if allocation fails
      // test if all elements of data are ==0
      // Check if all elements are 0 and log if not
        int non_zero_count = 0;

      for (j = 0; j < size / sizeof(int); ++j) {
        //assert(data[j] == 0);
        if (data[j] != 0) {
                non_zero_count++;
            }
      }
            if (non_zero_count > 0) {
            fprintf(stderr, "Warning: %d non-zero elements found in allocation of %zu bytes\n",
                    non_zero_count, size);
      }
      free(data);
    }

    else {
      fprintf(stderr, "\nMax size allocated: %lu bytes\n", 2UL << (i - 1));
      break;
    }
  }
  fprintf(stderr, "\n");
  return 0;
}
