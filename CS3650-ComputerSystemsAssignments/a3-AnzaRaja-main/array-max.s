# Write the assembly code for the array_max function

.section .text
    .globl array_max
array_max:
    # Prologue: save registers, set up the stack
    push %rbx                # save callee-save register
    mov %rdi, %rbx           # store the number of elements (n) in %rbx

    # Base case: if n == 0, return 0 (optional)
    test %rbx, %rbx
    je .return_zero

    # Initialization: load the first element as the current max
    mov (%rsi), %rax         # load the first element of the array into %rax (current max)
    mov $1, %rcx             # initialize counter (start from second element)

.loop_start:
    # Check if we've reached the end of the array
    cmp %rbx, %rcx
    jge .done                # if rcx >= rbx (n), we are done

    # Load the next element of the array
    mov (%rsi, %rcx, 8), %rdx  # load items[rcx] into %rdx

    # Compare the current element to the current max
    cmp %rax, %rdx
    jle .skip                # if items[rcx] <= max, skip to next iteration



    # Update max if items[rcx] > max
    mov %rdx, %rax

.skip:
    # Increment the counter and loop
    inc %rcx
    jmp .loop_start

#.update_max:
 #   mov %rdx, %rax
  #  jmp .skip

.done:
    # Epilogue: return the max in %rax and restore stack
    pop %rbx
    ret

.return_zero:
    mov $0, %rax
    pop %rbx
    ret

