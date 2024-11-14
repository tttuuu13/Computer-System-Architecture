.data
	array_a: .space 40
	array_b: .space 40
	enter_n_prompt: .asciz "Please enter N(0 <= N <= 10): "
	enter_x_prompt: .asciz "Please enter X: "
	enter_num_prompt: .asciz "Please enter number: "
	input_out_of_range_msg: .asciz "ERROR: input is out of range, restarting the program...\n"
.include "macros.asm"
.text
handle_input:
	# Store register's values on stack
	addi sp sp, -16
	sw s0 (sp)
	sw s1 4(sp)
	sw s2 8(sp)
	sw s3 12(sp)
	
	# Get N
	input_number enter_n_prompt
	
	# Validate input
	blez a0 input_out_of_range
	li t0 10 # upper bound
	bgt a0 t0 input_out_of_range
	mv s0 a0 # store N
	
	# Get X
	input_number enter_x_prompt
	mv s1 a0 # store X
	
	# Get array
	mv a0 s0
	la a1 array_a
	input_array a1 a0
	mv s2 a1 # store array_a
	
	la s3 array_b # save array_b
	
	mv a1 s2
	mv a2 s0
	mv a3 s3
	mv a4 s1
	jal main
	
	# Restore registers
	lw s0 (sp)
	lw s1 4(sp)
	lw s2 8(sp)
	lw s3 12(sp)
	addi sp sp 16
	j exit
	
input_out_of_range:
	la a0 input_out_of_range_msg
	li a7 4
	ecall
	j handle_input

exit:
	li a7 10
	ecall

main:
	# Save filtered array to B and save B's length to a0
	filter_array a1 a2 a3 a4
	
	# Print array B
	print_array a3 a0
	ret