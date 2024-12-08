# Hello World in Assembly using printf

.global main

.text

main:
    enter $0, $0

    mov $message, %rdi
    mov $0, %al
    call printf

#PART 1: Task 2
# Math Calculation: (2 * a + b * c) >> 4
    mov a(%rip), %rax       # Load a into %rax
    mov b(%rip), %rdx       # Load b into %rdx
    mov c(%rip), %rcx       # Load c into %rcx (using %rcx since %rdx is occupied)

    shl $1, %rax            # 2 * a -> shift left by 1
    imul %rcx, %rdx         # b * c -> multiply b by c, store in %rdx
    add %rdx, %rax          # (2 * a) + (b * c) -> add %rdx to %rax
    shr $4, %rax            # (result) >> 4 -> shift right by 4

# Print the result using printf and long_format
    mov $long_format, %rdi  # Format string for printf
    mov %rax, %rsi          # Move the result into %rsi (1st argument for printf)
    mov $0, %al             # Zero %al for printf call
    call printf

#PART 2: Task 1
# Call labs with the value of d
    mov d(%rip), %rdi       # Move d into %rdi (labs takes 1 arg in %rdi)
    call labs               # Call labs, result will be in %rax

    # Print the result from labs
    mov $long_format, %rdi  # Format string for printf
    mov %rax, %rsi          # Result from labs is in %rax, move it to %rsi for printf
    mov $0, %al             # Zero out %al for printf
    call printf

#PART 2: Task 2
# Calculates the formula: labs((d * e) << 3)
    mov d(%rip), %rdi
    mov e(%rip), %rsi
    imul %rsi, %rdi     #multipy e and d and store value in rdi
    
# Left shift 3 times
    shl $3, %rdi
  
# Call labs on (d * e)
    call labs

#Print result from labs
    mov $long_format, %rdi #Format string for printf
    mov %rax, %rsi # Result from labs is in %rax, move to %rsi for printf
    mov $0, %al
    call printf

    leave
    ret

.data
message:
    .asciz "Hello, World!\n"

long_format:
    .asciz "%ld\n"

a: .quad 0x3908
b: .quad 0x721
c: .quad 16
d: .quad -32
e: .quad 64
