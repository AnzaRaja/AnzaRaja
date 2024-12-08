
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#include "third.h"

#define MAX_INPUT_SIZE 256
//#define MAX_TOKENS 100



int main(int argc, char **argv) {
  // TODO: Implement the tokenize demo.

char input[MAX_INPUT_SIZE];

    // Read a line of input from the user
    //printf("Enter a command: ");
    if (fgets(input, MAX_INPUT_SIZE, stdin) == NULL) {
        printf("Error reading input.\n");
        return 1;
    }

    // Remove newline character if it exists
    size_t len = strlen(input);
    if (len > 0 && input[len - 1] == '\n') {
        input[len - 1] = '\0';
    }

    // Tokenize the input string
    char** tokens = tokenize(input);

    // Print the tokens, one per line
    for (int i = 0; tokens[i] != NULL; i++) {
        printf("%s\n", tokens[i]);
    }

    // Free dynamically allocated memory for tokens
    free_tokens(tokens);

    return 0;
}
