/* TODO: Implement the Programming task here. */
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <fcntl.h>

int main() {
    int pipe_fds[2];
    pid_t pid1, pid2;

    // Create the pipe
    assert(pipe(pipe_fds) == 0);  // pipe_fds[0] is the read end, pipe_fds[1] is the write end

    // Fork the first child (sort process)
    pid1 = fork();
    if (pid1 == -1) {
        perror("Error forking the sort process");
        exit(1);
    }

    if (pid1 == 0) {  // Child 1 (sort)
        // Redirect stdin to read from the file many_words.txt
        int input_fd = open("many_words.txt", O_RDONLY);
        if (input_fd == -1) {
            perror("Error opening many_words.txt");
            exit(1);
        }
        dup2(input_fd, STDIN_FILENO);  // replace stdin with many_words.txt
        close(input_fd);  // no longer need this file descriptor

        // Redirect stdout to write to the pipe
        dup2(pipe_fds[1], STDOUT_FILENO);  // replace stdout with the write end of the pipe
        close(pipe_fds[0]);  // close the read end of the pipe
        close(pipe_fds[1]);  // we already dup'd this to stdout

        // Execute sort
        execlp("sort", "sort", NULL);
        perror("Error executing sort");
        exit(1);
    }

    // Fork the second child (tail process)
    pid2 = fork();
    if (pid2 == -1) {
        perror("Error forking the tail process");
        exit(1);
    }

    if (pid2 == 0) {  // Child 2 (tail)
        // Redirect stdin to read from the pipe
        dup2(pipe_fds[0], STDIN_FILENO);  // replace stdin with the read end of the pipe
        close(pipe_fds[1]);  // close the write end of the pipe
        close(pipe_fds[0]);  // we already dup'd this to stdin

        // Redirect stdout to write to the file sorted_tail.txt
        int output_fd = open("sorted_tail.txt", O_WRONLY | O_CREAT | O_TRUNC, 0644);
        if (output_fd == -1) {
            perror("Error opening sorted_tail.txt");
            exit(1);
        }
        dup2(output_fd, STDOUT_FILENO);  // replace stdout with sorted_tail.txt
        close(output_fd);  // no longer need this file descriptor

        // Execute tail
        execlp("tail", "tail", NULL);
        perror("Error executing tail");
        exit(1);
    }

    // Parent process: close both ends of the pipe
    close(pipe_fds[0]);
    close(pipe_fds[1]);

    // Wait for both child processes to finish
    waitpid(pid1, NULL, 0);
    waitpid(pid2, NULL, 0);

    return 0;
}
