
.global main

.text

main:
  # we are using callee-save registers to preserve information when calling printf
  push %r12
  push %r13
  push %r14
  enter $8, $0  # changed $8 to $16 for more space on the stack.

  mov %rdi, %r12   # number of arguments
  mov %rsi, %r13   # argument addresses
  mov $1, %r14     # starting the counter at 1 to exclude the program name

# Initialize running sum at -8(%rbp) to 0
  movq $0, -8(%rbp)

loop:
  cmp %r12, %r14
  jge loop_end

###New
# Converting the argument to a long integer using atol
  mov (%r13, %r14, 8), %rdi  # the argument pointer
  call atol                  # converting to long int(result stored in %rax)
  
  # Adding the result to the running sum at -8(%rbp)
  addq %rax, -8(%rbp)

inc %r14
  jmp loop

loop_end:  # print when the loop ends
  # print each argument
  mov $sum_format, %rdi
  mov -8(%rbp), %rsi
  mov $0, %al
  call printf

  leave
  pop %r14
  pop %r13
  pop %r12
  ret

.data

sum_format: 
  .asciz "Sum: %ld\n" # Formatting the string for printing sum

