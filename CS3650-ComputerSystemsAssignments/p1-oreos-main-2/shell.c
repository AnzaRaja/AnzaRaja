#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <string.h>

#include "third.h"

#define MAX_INPUT_SIZE 256

// Function to execute commands from a file
void execute_script(const char *filename)
{
    FILE *file = fopen(filename, "r");
    if (file == NULL)
    {
        perror("source: unable to open file");
        return;
    }

    char line[MAX_INPUT_SIZE];
    while (fgets(line, sizeof(line), file) != NULL)
    {
        // Remove newline character from the line
        size_t len = strlen(line);
        if (len > 0 && line[len - 1] == '\n')
        {
            line[len - 1] = '\0';
        }

        // Process the line for semicolon-separated commands
        char *command = strtok(line, ";");
        while (command != NULL)
        {

        // Process the command as if entered interactively
        if (strlen(line) > 0)
        {
            // Tokenize the line
            char **tokens = tokenize(line);

            // If it's a built-in command, handle it
            if (strcmp(tokens[0], "cd") == 0)
            {
                if (tokens[1] == NULL)
                {
                    fprintf(stderr, "cd: missing argument\n");
                }
                else if (chdir(tokens[1]) != 0)
                {
                    perror("cd failed");
                }
            }
            else if (strcmp(tokens[0], "source") == 0)
            {
                fprintf(stderr, "source: cannot call source from within itself\n");
            }
            else
            {
                // Fork a new process to execute the command
                pid_t pid = fork();
                if (pid < 0)
                {
                    perror("Fork failed");
                }
                else if (pid == 0)
                {
                    // Child process
                    if (execvp(tokens[0], tokens) == -1)
                    {
                        fprintf(stderr, "%s: command not found\n", tokens[0]);
                    }
                    exit(EXIT_FAILURE);
                }
                else
                {
                    // Parent process: Wait for the child to finish
                    int status;
                    waitpid(pid, &status, 0);
                }
            }

            // Free the tokens
            free_tokens(tokens);
        }
        command = strtok(NULL, ";");
        }
    }

    fclose(file);
}

// Function to print the "help" information
void print_help()
{
    printf("Built-in commands available:\n");
    printf(" cd <directory>    : Change the current working directory of the shell to <directory>\n");
    printf(" source <filename> : Executes a script given in <filename>\n");
    printf(" prev              : Prints the previous command line and executes it again\n");
    printf(" help              : Explains all the built-in commands available\n");
    printf(" exit              : Exits the shell\n");
}


void execute_pipeline(char *command)
{
    char *cmd = strtok(command, "|");
    int num_cmds = 0;
    char *commands[10]; // Adjust size as needed

    // Split commands based on pipe
    while (cmd != NULL)
    {
        commands[num_cmds++] = cmd;
        cmd = strtok(NULL, "|");
    }

    int pipefd[2 * (num_cmds - 1)]; // Create pipes
    for (int i = 0; i < num_cmds - 1; i++)
    {
        if (pipe(pipefd + i * 2) < 0)
        {
            perror("pipe");
            exit(1);
        }
    }

    for (int i = 0; i < num_cmds; i++)
    {
        pid_t pid = fork();
        if (pid == 0)
        { // Child process
            if (i != 0)
            {                                 // Not the first command
                dup2(pipefd[(i - 1) * 2], 0); // Read end of previous pipe
            }
            if (i != num_cmds - 1)
            {                               // Not the last command
                dup2(pipefd[i * 2 + 1], 1); // Write end of current pipe
            }
            for (int j = 0; j < 2 * (num_cmds - 1); j++)
            {
                close(pipefd[j]); // Close all pipes
            }
            execlp("sh", "sh", "-c", commands[i], NULL); // Execute command
            perror("execlp");                            // If exec fails
            exit(1);
        }
    }

    // Parent process
    for (int i = 0; i < 2 * (num_cmds - 1); i++)
    {
        close(pipefd[i]); // Close all pipes
    }

    for (int i = 0; i < num_cmds; i++)
    {
        wait(NULL); // Wait for all children to finish
    }
}

int main(int argc, char **argv)
{

    // TODO: Implement your shell's main
    char input[MAX_INPUT_SIZE];
    char **tokens;
    pid_t pid;
    int status;

    // variable to store the previous command
    char previous_command[MAX_INPUT_SIZE] = "";

    // Print the welcome message
    printf("Welcome to mini-shell.\n");

    // Shell loop
    while (1)
    {
        // Display the shell prompt
        printf("shell $ ");
        fflush(stdout); // Ensure the prompt is printed immediately

        // Read the input from the user
        if (fgets(input, MAX_INPUT_SIZE, stdin) == NULL)
        {
            // Handle Ctrl-D (EOF)
            printf("\nBye bye.\n");
            break;
        }

        // Remove newline character from input
        size_t len = strlen(input);
        if (len > 0 && input[len - 1] == '\n')
        {
            input[len - 1] = '\0';
        }

        // Check if the input is "exit" to exit the shell
        if (strcmp(input, "exit") == 0)
        {
            printf("Bye bye.\n");
            break;
        }

        // check if the input is "prev" to print previous command line
        if (strcmp(input, "prev") == 0)
        {
            if (strlen(previous_command) == 0)
            {
                printf("No previous command.\n");
                continue;
            }
            else
            {
                strcpy(input, previous_command); // reuse the previous command
            }
        }

        // Store the current command line into previous_command before tokenizing
        if (strcmp(input, "prev") != 0) {
            strcpy(previous_command, input);
        }

        // Check if the input is "help"
        if (strcmp(input, "help") == 0)
        {
            print_help(); // Print the help message
            continue;     // Skip the rest of the loop for "help"
        }

        // Check for pipes in the command
        if (strchr(input, '|') != NULL)
        {
            execute_pipeline(input);
        }
        else
        {

            // NEW
            //  Split the input into commands based on semicolons
            char *command = strtok(input, ";");
            while (command != NULL)
            {
                // Tokenize the command
                tokens = tokenize(command);

                // If no command was entered, prompt again
                if (tokens[0] == NULL)
                {
                    free_tokens(tokens);
                    command = strtok(NULL, ";"); // Get next command
                    continue;
                }

                // Handle input/output redirection of multiple commands
                int input_redirect = 0;
                char *input_file = NULL;
                int output_redirect = 0;
                char *output_file = NULL;

                // To detect for redirection
                for (int i = 0; tokens[i] != NULL; i++)
                {
                    if (strcmp(tokens[i], "<") == 0)
                    {
                        input_redirect = 1;
                        input_file = tokens[i + 1]; // file name would be after the <
                        tokens[i] = NULL;
                    }
                    if (strcmp(tokens[i], ">") == 0)
                    {
                        output_redirect = 1;
                        output_file = tokens[i + 1];
                        tokens[i] = NULL;
                    }
                }

                // PART OF TASK 2.1
                // Check for built-in commands
                // The cd command
                if (strcmp(tokens[0], "cd") == 0)
                {
                    if (tokens[1] == NULL)
                    {
                        fprintf(stderr, "cd: missing argument\n");
                    }
                    else if (chdir(tokens[1]) != 0)
                    {
                        perror("cd failed");
                    }
                }
                else if (strcmp(tokens[0], "source") == 0)
                {
                    if (tokens[1] == NULL)
                    {
                        fprintf(stderr, "source: missing filename\n");
                    }
                    else
                    {
                        execute_script(tokens[1]); // Execute the script
                    }
                }
                else
                {
                    // Fork a new process
                    pid = fork();
                    if (pid < 0)
                    {
                        perror("Fork failed");
                    }
                    else if (pid == 0)
                    {
                        // handle input redirection
                        if (input_redirect && input_file != NULL)
                        {
                            FILE *input_fp = freopen(input_file, "r", stdin);
                            if (input_fp == NULL)
                            //if (freopen(input_file, "r", stdin) == NULL)
                            {
                                perror("Input redirection failed");
                                exit(EXIT_FAILURE);
                            }
                        }

                        // Handle output redirection
                        if (output_redirect && output_file != NULL)
                        {
                            FILE *output_fp = freopen(output_file, "w", stdout);
                            if (output_fp == NULL)
                            //if (freopen(output_file, "w", stdout) == NULL)
                            {
                                perror("Output redirection failed");
                                exit(EXIT_FAILURE);
                            }
                        }

                        // Child process: Execute the command
                        if (execvp(tokens[0], tokens) == -1)
                        {
                            // Command not found
                            fprintf(stderr, "%s: command not found\n", tokens[0]);
                        }
                        exit(EXIT_FAILURE); // Exit child if exec fails
                    }
                    else
                    {
                        // Parent process: Wait for the child to finish
                        waitpid(pid, &status, 0);
                    }
                }

                // Free the tokens array
                free_tokens(tokens);
                // NEW
                command = strtok(NULL, ";"); // Get the next command
            }
        }
    }
    return 0;
}
