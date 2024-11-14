.data
	array_b: .space 40
	new_line: .asciz "\n"
	n_tests: .word 5, 9, 9, 1, 1, 7
	x_tests: .word 3, 8, 1, 2, 0, 1
	array_tests: 	.word 1, 2, 3, 4, 5
			.word 1, 1, 1, 1, 1, 1, 1, 1, 1
			.word 1, 1, 1, 1, 1, 1, 1, 1, 1
			.word 3
			.word 9999999
			.word 0, 0, 0, 0, 1, 0, 0
			
.include "macros.asm"
.text
config:
	li a5 0 # counter
	li a6 6 # amount of tests

	la t2 n_tests
	la t4 x_tests
	la a1 array_tests
test:
	# Load data for test
	lw a2 (t2)
	la a3 array_b
	lw a4 (t4)
	# Run test
	jal main
	la a0 new_line
	li a7 4
	ecall
	# Go to the next array
	li t0 4
	mul t1 t0 a2
	add a1 a1 t1
	# Pick next variable set
	addi t2 t2 4
	addi t4 t4 4
	addi a5 a5 1
	blt a5 a6 test
	j exit

main:
	# Save filtered array to B and save B's length to a0
	filter_array a1 a2 a3 a4
	
	# Print array B
	print_array a3 a0
	ret
exit:
	li a7 10
	ecall
	