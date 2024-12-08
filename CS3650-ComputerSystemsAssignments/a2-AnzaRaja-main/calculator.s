#
# Usage: ./calculator <op> <arg1> <arg2>
#

# Make `main` accessible outside of this module
.global main

# Start of the code section
.text

# int main(int argc, char argv[][])
main:
  # Function prologue
  enter $0, $0

  # Variable mappings:
  # op -> %r12
  # arg1 -> %r13
  # arg2 -> %r14
  movq 8(%rsi), %r12  # op = argv[1]
  movq 16(%rsi), %r13 # arg1 = argv[2]
  movq 24(%rsi), %r14 # arg2 = argv[3]


  # Hint: Convert 1st operand to long int
  mov %r13, %rdi     # moving arg1 to the first argument register (arg1 is a string)
  call atol          # call atol -> result is in %rax
  mov %rax, %r15     # storing the result of atol in %r15 (arg1 is stored as a long)

  # Hint: Convert 2nd operand to long int
  mov %r14, %rdi     # moving arg2 to the first argument register (arg2 is a string)
  call atol          # call atol -> result is in %rax
  mov %rax, %r8      # storing the result of atol in %r16 (arg2 is stored as a long)

  # Hint: Copy the first char of op into an 8-bit register
  # i.e., op_char = op[0] - something like: 
  movb 0(%r12), %al  # moving the first character(which is a byte) of the op string to %al

  # Explanation: Since each argument is a string, the contents of %r12 are 
  # actually a memory address pointing to the beginning of the string (which 
  # is a sequence of characters). When correctly completed, the above 
  # instruction copy the first byte (i.e., the first character) to a register
  # for further use.

  # if (op_char == '+') {
  cmpb $'+', %al
  je add_operation   # jumps to the add_operation if the input equals '+'

  # }
  # else if (op_char == '-') {
  cmpb $'-', %al
  je sub_operation   # jumps to the sub_operation if the input equals '-'  

  # }
  # else if (op_char == '*') {
  cmpb $'*', %al
  je mult_operation  # jumps to the mult_operation if the intput equals '*'

  # }
  # else if (op_char == '/' {
  cmpb $'/', %al
  je div_operation   # jumps to the div_operation if the input equals '/' 

  # else {
  #   // print error
  #   // return 1 from main
  # }
  mov $1, %rax              # returning 1 if the program fails ***
  mov $error_message, %rdi  # loading the error message for an unknown operation
  call puts                 # calling puts to print the error message
  jmp end_program           # skips the rest of the operartions and exits

  # Handling the '+' operation
add_operation:
  add %r8, %r15             # adding arg2 to arg1
  jmp print_the_result      # jumping to print_the_result to display the output

  # Handling the '-' operation
sub_operation:
  sub %r8, %r15             # subtracting arg2 from arg1
  jmp print_the_result      # jumping to print_the_result to display the output

  # Handling the '*' operation
mult_operation:
  imul %r8, %r15            # multiplying arg2 with arg1
  jmp print_the_result      # jumping to print_the_result to display the output

  # Handling the '/' operation
div_operation:
  cmp $0, %r8               # checking if arg2 is 0
  je dividing_by_zero       # if this is true, jump to the dividing_by_zero case

  #Added this in to correctly handle division
# Handling  absolute value for the first operand (arg1)
  test %r15, %r15            # Testing if arg1 is negative
  jns check_second_operand   # Jump if arg1 is non-negative (so skip the negation)
  neg %r15                   # If arg1 is negative, then negate it

check_second_operand:
  # Handling absolute value for the second operand (arg2)
  test %r8, %r8              # Testing if arg2 is negative
  jns do_division            # Jump if arg2 is non-negative (so skip the negation)
  neg %r8                    # If arg2 is negative,then negate it

do_division:                # Now it should do the division
  mov %r15, %rax            # moving arg1 to %rax
  xor %rdx, % rdx           # clearing the register
  cqto                      # Sign-extend RAX into RDX:RAX to handle negative numbers
  div %r8                   # dividing by arg2
  mov %rax, %r15            # moving result back to %r15
  jmp print_the_result      # jumping to print_the_result to display the output

  # Handling the dividing by 0 case
dividing_by_zero:
  mov $1, %rax              # returning 1 if the program fails ***
  mov $div_zero_error, %rdi # calls on the error
  call puts
  jmp end_program           # ends the program

  # Printing the result
print_the_result:
  mov $format, %rdi         # printing the result
  mov %r15, %rsi
  xor %rax, %rax            # Clear %rax: set it to 0
  call printf

  mov $0, %rax              # returning 0 if the program is successful ***
  jmp end_program           # jump to end_program  ***

  # Function epilogue
end_program:
  leave
  ret


# Start of the data section
.data

format: 
  .asciz "%ld\n"

# error message for unknown operation
error_message:
  .asciz "Unknown operation\n"

# error message for trying to divide by 0
div_zero_error:
  .asciz "Cannot divide by zero error\n"


