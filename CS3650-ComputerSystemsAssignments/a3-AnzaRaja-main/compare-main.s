# Write the assembly code for the main of the compare program

.global main
    .extern compare
    .extern printf
    .extern atol

.section .data
    less_msg:    .asciz "less\n"
    equal_msg:   .asciz "equal\n"
    greater_msg: .asciz "greater\n"
    error_msg:   .asciz "Two arguments required.\n"

.section .text
#    .globl _start
#    .globl main

main:
    # Prologue
    pushq %rbp       # Saving the base pointer
    movq %rsp, %rbp  # Setting the stack frame
   
    # Storing the values of arg[1] and arg[2] into registers
    movq 8(%rsi), %r12    # argv[1] loaded into %rsi stored in %r12
    movq 16(%rsi), %r13   # argv[2] loaded into %rsi stored in %r13

    # Checking argc (which is stored in %rdi)
    movq %rdi, %rax      # argc is in %rdi
    cmpq $3, %rax
    jne print_error      # If argc != 3, jump to error handling

    # Converting argv[1] and argv[2] from strings to long integers using atol
    movq %r12, %rdi        # moving %r12 into %rdi before calling atol
    call atol              # Call atol to convert argv[1]
    movq %rax, %r12        # Store the result in %r12 (which is "a")

    # Converting argv[2]
    movq %r13, %rdi       # moving %r13 into %rdi before calling atol
    call atol             # Call atol to convert argv[2]
    movq %rax, %r13       # Store the result in %r13 (arg2) (a callee-save register)

    # Call the compare function
    movq %r12, %rdi         # Move arg1 to %rdi
    movq %r13, %rsi         # Move arg2 to %rsi
    call compare           # Call compare
    # The result will be in %rax

    # Check the result and print the corresponding message
    cmp $-1, %rax          # Comparing with -1
    je print_less          # If result == -1, print "less"
    
    cmp $0, %rax           # Comparing with 0
    je print_equal         # If result == 0, print "equal"

# Default is print greater
print_greater:
    movq $greater_msg, %rdi # To print "greater"
    mov $0, %al
    call printf
    jmp exit_program
 
print_less:
    movq $less_msg, %rdi    # To print "less"
    mov $0, %al
    call printf
    jmp exit_program

print_equal:      
    movq $equal_msg, %rdi   # To print "equal"
    mov $0, %al
    call printf
    jmp exit_program

print_error:
    movq $error_msg, %rdi   # To print "Two arguments required."
    mov $0, %al
    call printf
    movq $1, %rax           # Set return status to 1 (which is error)
    jmp exit_program

exit_program:
    movq $0, %rax           # Set return status to 0 (which is success)
    leave
    ret

