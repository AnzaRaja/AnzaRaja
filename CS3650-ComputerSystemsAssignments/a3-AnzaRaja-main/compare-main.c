/* Complete the C version of the driver program for compare. This C code does
 * not need to compile. */

#include <stdio.h>

extern long compare(long, long);

int main(int argc, char *argv[]) {

 // To check if the number of arguments is correct
    if (argc != 3) {  // since arg0 = program name, arg1 = 1st, arg2 = 2nd
        printf("Two arguments required.\n");
        return 1;
    }

    // To convert arguments from strings to long integers
    long arg1 = atol(argv[1]);
    long arg2 = atol(argv[2]);

    // Calling the compare function to do the comparing
    long result = compare(arg1, arg2);

    // Printing result based on the compare function result
    if (result == -1) {
        printf("less\n");
    } else if (result == 0) {
        printf("equal\n");
    } else {
        printf("greater\n");
    }
  // for the program running successfully
  return 0;
}

