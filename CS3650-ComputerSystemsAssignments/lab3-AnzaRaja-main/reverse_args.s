
.global main

.text

main:
  # we are using callee-save registers to preserve information when caligning printf
  push %r12
  push %r13
  push %r14
  enter $8, $0  # changed $8 to $16 for more stack allocation

  mov %rdi, %r12   # number of arguments
  mov %rsi, %r13   # argument addresses
  mov $1, %r14     # starting the counter at 1

# The first loop will push each argument's address onto the stack
push_loop:
  cmp %r12, %r14     # comparing argc with the counter
  jge pushing_end    # and if the counter is > argc, it jumps to exit the loop


# Pushing the address of the current arg onto the stack
 mov (%r13, %r14, 8), %rax   # Loading address of argument into %rax
  push %rax                  # Pushing address onto the stack

  inc %r14                   # Incrementing the counter
  jmp push_loop              # Back to begining of loop


pushing_end:

#SECOND LOOP
mov %r14, %r12
sub $1, %r12

# The second loop will pop each arg plus print it in reverse
pop_loop:
  cmp $1, %r12            # To check if all arguments were printed
  jl pop_end              # If counter >= argc it will exit


pop %rsi

mov $print_format, %rdi
mov $0, %al
call printf

dec %r12
jmp pop_loop

  
pop_end: # to exit the program
  mov $newline_format, %rdi  # Loading the newline format string
  call printf                # Printing the newline character

  leave
  pop %r14
  pop %r13
  pop %r12
  ret

.data
print_format:
.asciz "%s "     # Formatting the string for printing the arguments

newline_format:
  .asciz "\n"    # Newline format string to print after all arguments
