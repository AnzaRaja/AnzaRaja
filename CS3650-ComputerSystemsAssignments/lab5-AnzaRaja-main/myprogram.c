// Take a look at some of the previous examples to create your own program!

#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

void run_command(char *cmd, char *args[]) {
    if (fork() == 0) {
        // In child process
        execve(cmd, args, NULL);
        // If execve fails, print error and exit
        perror("execve failed");
        exit(1);
    }
    else {
        // In parent process, wait for child to complete
        wait(NULL);
    }
}

int main(int argc, char **argv) {
    // Command 1: ps -uf
    char *ps_args[] = {"/bin/ps", "-uf", NULL};
    run_command("/bin/ps", ps_args);

    // Command 2: echo --help
    char *echo_args[] = {"/bin/echo", "--help", NULL};
    run_command("/bin/echo", echo_args);

    // Command 3: nl -b a example1.c
    char *nl_args[] = {"/usr/bin/nl", "-b", "a", "example1.c", NULL};
    run_command("/usr/bin/nl", nl_args);

    printf("All commands executed.\n");
    return 0;
}
