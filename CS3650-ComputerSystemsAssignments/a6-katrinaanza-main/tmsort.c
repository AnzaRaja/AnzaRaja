/** 
 * Threaded Merge Sort
 *
 * Modify this file to implement your multi-threaded version of merge sort. 
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>

#include <unistd.h>

#include <assert.h>
#include <pthread.h>

#define tty_printf(...) (isatty(1) && isatty(0) ? printf(__VA_ARGS__) : 0)

#ifndef SHUSH
#define log(...) (fprintf(stderr, __VA_ARGS__))
#else 
#define log(...)
#endif

/** The number of threads to be used for sorting. Default: 1 */
int thread_count = 1;

//NEW
int active_threads = 0;
pthread_mutex_t thread_count_mutex;

/** NEW
 * Structure for passing parameters to the thread function
 */
typedef struct {
  long *nums;
  long *target;
  int from;
  int to;
} merge_sort_params;


/**
 * To compute the delta between the given timevals in seconds.
 */
double time_in_secs(const struct timeval *begin, const struct timeval *end) {
  long s = end->tv_sec - begin->tv_sec;
  long ms = end->tv_usec - begin->tv_usec;
  return s + ms * 1e-6;
}

/**
 * Print the given array of longs, an element per line.
 */
void print_long_array(const long *array, int count) {
  for (int i = 0; i < count; ++i) {
    printf("%ld\n", array[i]);
  }
}

/**
 * To merge two slices of nums into the corresponding portion of target.
 */
void merge(long nums[], int from, int mid, int to, long target[]) {
  int left = from;
  int right = mid;

  int i = from;
  for (; i < to && left < mid && right < to; i++) {
    if (nums[left] <= nums[right]) {
      target[i] = nums[left];
      left++;
    }
    else {
      target[i] = nums[right];
      right++;
    }
  }
  if (left < mid) {
    memmove(&target[i], &nums[left], (mid - left) * sizeof(long));
  }
  else if (right < to) {
    memmove(&target[i], &nums[right], (to - right) * sizeof(long));
  }

}

//REPLACED MERGE_SORT_AUX WITH THIS FUNCTION
/** 
 * Sort the given slice of nums into target.
 *
 * Warning: Nums gets overwritten.
 */
void *merge_sort_thread(void *args) {
  merge_sort_params *params = (merge_sort_params *)args;
  int from = params->from;
  int to = params->to;
  long *nums = params->nums;
  long *target = params->target;

  if (to - from <= 1) {
    return NULL; // Changed this line for better memory handling
  }

  int mid = (from + to) / 2;

  pthread_t left_thread, right_thread;
  merge_sort_params left_params = {target, nums, from, mid};
  merge_sort_params right_params = {target, nums, mid, to};

  int create_left = 0, create_right = 0;

  // Control thread creation based on available threads
  pthread_mutex_lock(&thread_count_mutex);
  if (active_threads < thread_count) {
    active_threads++;
    create_left = 1;
    pthread_create(&left_thread, NULL, merge_sort_thread, &left_params);
  }
  if (active_threads < thread_count) {
    active_threads++;
    create_right = 1;
    pthread_create(&right_thread, NULL, merge_sort_thread, &right_params);
  }
  pthread_mutex_unlock(&thread_count_mutex);

  // Fallback to sequential if no new thread is created
  // If we couldn't create threads, sort serially
  if (!create_left) {
    merge_sort_thread(&left_params);
  }
  if (!create_right) {
    merge_sort_thread(&right_params);
  }

  // Join created threads
  if (create_left) {
    pthread_join(left_thread, NULL);
    pthread_mutex_lock(&thread_count_mutex);
    active_threads--;
    pthread_mutex_unlock(&thread_count_mutex);
  }
  if (create_right) {
    pthread_join(right_thread, NULL);
    pthread_mutex_lock(&thread_count_mutex);
    active_threads--;
    pthread_mutex_unlock(&thread_count_mutex);
  }

  // Merge the sorted halves
  merge(nums, from, mid, to, target);

  return NULL; // Changed this line for better memory handling
}

/**
 * Sort the given array and return the sorted version.
 *
 * The result is malloc'd so it is the caller's responsibility to free it.
 *
 * Warning: The source array gets overwritten.
 */
long *merge_sort(long nums[], int count) {
  long *result = calloc(count, sizeof(long));
  assert(result != NULL);

  memmove(result, nums, count * sizeof(long));

  //merge_sort_aux(nums, 0, count, result);

  pthread_mutex_init(&thread_count_mutex, NULL);

  // Initialize parameters for the top-level merge sort
  merge_sort_params params = {nums, result, 0, count};

  merge_sort_thread(&params);

  pthread_mutex_destroy(&thread_count_mutex);
  
  return result;
}

/**
 * Based on command line arguments, allocate and populate an input and a 
 * helper array.
 *
 * Returns the number of elements in the array.
 */
int allocate_load_array(int argc, char **argv, long **array) {
  assert(argc > 1);
  int count = atoi(argv[1]);

  *array = calloc(count, sizeof(long));
  assert(*array != NULL);

  long element;
  tty_printf("Enter %d elements, separated by whitespace\n", count);
  int i = 0;
  while (i < count && scanf("%ld", &element) != EOF)  {
    (*array)[i++] = element;
  }

  return count;
}

int main(int argc, char **argv) {
  if (argc != 2) {
    fprintf(stderr, "Usage: %s <n>\n", argv[0]);
    return 1;
  }

  struct timeval begin, end;

  // get the number of threads from the environment variable SORT_THREADS
  if (getenv("MSORT_THREADS") != NULL)
    thread_count = atoi(getenv("MSORT_THREADS"));

  log("Running with %d thread(s). Reading input.\n", thread_count);

  // Read the input
  gettimeofday(&begin, 0);
  long *array = NULL;
  int count = allocate_load_array(argc, argv, &array);
  gettimeofday(&end, 0);

  log("Array read in %f seconds, beginning sort.\n", 
      time_in_secs(&begin, &end));
 
  // Sort the array
  gettimeofday(&begin, 0);
  long *result = merge_sort(array, count);
  gettimeofday(&end, 0);
  
  log("Sorting completed in %f seconds.\n", time_in_secs(&begin, &end));

  // Print the result
  gettimeofday(&begin, 0);
  print_long_array(result, count);
  gettimeofday(&end, 0);
  
  log("Array printed in %f seconds.\n", time_in_secs(&begin, &end));

  free(array);
  free(result);

  return 0;
}
