.include "strncpy.asm"

.data
src_string: .asciz "Testing strncpy!"   
dest_string: .space 20              
newline: .asciz "\n"           

.text
.global _start
_start:
    # Input data
    la a0, dest_string     # Destination string pointer
    la a1, src_string      # Source string pointer
    li a2, 10              # Number of symbols to copy

    jal strncpy

   # Result output
    la a0, dest_string
    jal print_string

    # New line
    la a0, newline
    jal print_string

    # Exit
    li a7, 10
    ecall

print_string:
    mv t0, a0              
    li a1, 1               
    li a7, 64              
    
    mv t1, t0              
length_loop:
    lbu t2, 0(t1)          
    beqz t2, length_done   
    addi t1, t1, 1         
    j length_loop          
length_done:
    sub a2, t1, t0         

    ecall
    ret