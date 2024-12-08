// Type in and try example5.c

#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

int main(int argc, char **argv) {

  char* myargv[16];      // We can store up to 16 arguments.
  myargv[0] = "/bin/cat"; // Our first argument is the program we want to launch. Changed "/bin/ls" to "/bin/cat"
  // The program does not work if we change myargv[0] to "ls" and it goes to the if (fork() == 0) case and then the else case.
  myargv[1] = "example5.c";      // Any additional arguments (i.e. flags) we want to make use of. Changed "-F" to "example5.c"
  myargv[2] = NULL;      // Terminate the argument list--similar to how we would terminate a character string.
                         // (i.e. Set the last argument to NULL if we have no more flags.)
  if (fork() == 0) {
    // Executes command from child then terminates our process
    // Note: There are other 'exec' functions that may be helpful. Look at 'man exec' and 'man execve'.
    execve(myargv[0], myargv, NULL);
    printf("Child: Should never get here\n");
    exit(1);
  }
  else {
    wait(NULL); // handy synchronization function again!
    printf("This always prints last\n");
  }
  
  return 0;
}