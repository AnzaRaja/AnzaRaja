#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define MAX_INPUT_SIZE 256
#define MAX_TOKENS 100

// Function to check if a character is a special token
int is_special_char(char c) {
    return (c == '<' || c == '>' || c == '(' || c == ')' || c == ';' || c == '|');
}


char* strndup(const char* str, size_t n) {
    char* copy = malloc(n + 1); // Allocate memory for the new string (+1 for NULL terminator)
    if (copy) {
        strncpy(copy, str, n);
        copy[n] = '\0'; // Ensure NULL-termination
    }
    return copy;
}

// Function to tokenize input string
char** tokenize(const char* input) {
    char** tokens = malloc(MAX_TOKENS * sizeof(char*)); // Allocate space for token array
    int token_count = 0;
    int i = 0, start = 0;
    int in_quotes = 0;

    while (input[i] != '\0' && token_count < MAX_TOKENS - 1) {
        // Skip the whitespace unless inside quotes
        if (!in_quotes && isspace(input[i])) {
            i++;
            continue;
        }

        // To handle quoted strings
        if (input[i] == '"') {
            in_quotes = !in_quotes;
            if (!in_quotes) {
                // We closed a quote, extract token from start to i (inclusive)
                tokens[token_count] = strndup(&input[start], i - start);
                token_count++;
            } else {
                // We just opened a quote, mark the start position
                start = i + 1;
            }
            i++;
            continue;
        }

        // To handle special characters
        if (!in_quotes && is_special_char(input[i])) {
            tokens[token_count] = strndup(&input[i], 1); // Store special char as token
            token_count++;
            i++;
            continue;
        }

        // To handle words (sequences of non-special characters)
        if (!in_quotes && !isspace(input[i]) && !is_special_char(input[i])) {
            start = i;
            while (input[i] != '\0' && !isspace(input[i]) && !is_special_char(input[i]) && input[i] != '"') {
                i++;
            }
            tokens[token_count] = strndup(&input[start], i - start);
            token_count++;
            continue;
        }
        
        // If inside quotes, continue to next character
        if (in_quotes) {
            i++;
        }
    }

    tokens[token_count] = NULL; // Null-terminate the token array
    return tokens;
}

// Function to free the token array
void free_tokens(char** tokens) {
    for (int i = 0; tokens[i] != NULL; i++) {
        free(tokens[i]);
    }
    free(tokens);
}



