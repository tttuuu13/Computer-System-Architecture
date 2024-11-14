.data
	enter_number_prompt: .asciz "Enter number: "
	whitespace: .asciz " "
	open_bracket: .asciz "["
	closing_bracket: .asciz "]"

.macro input_number %prompt
	# Display prompt
	la a0 %prompt
	li a7 4
	ecall
	# Read input
	li a7 5
	ecall
.end_macro 

.macro input_array %array_ref %length
	# Store register's values on stack
	addi sp sp -12
	sw s0 (sp)
	sw s1 4(sp)
	sw s2 8(sp)
	
	# Configure variables
	li s0 0
	mv s1 %length
	mv s2 %array_ref
	
	# Read N elements
	insert_elem:
		input_number enter_number_prompt
		sw a0 0(s2)
		addi s0 s0 1
		addi s2 s2 4
		blt s0 s1 insert_elem
		
	# Restore registers
	lw s0 (sp)
	lw s1 4(sp)
	lw s2 8(sp)
	addi sp sp 12
.end_macro

.macro filter_array %source_array_ref %source_length %dest_array_ref %x
	# Store register's values on stack
	addi sp sp -28
	sw s0 (sp)
	sw s1 4(sp)
	sw s2 8(sp)
	sw s3 12(sp)
	sw s4 16(sp)
	sw s5 20(sp)
	sw s6 24(sp)
	
	# Configure variables
	li s0 0 # source index
	mv s1 %source_array_ref
	mv s2 %source_length
	li s3 0 # destination index
	mv s4 %dest_array_ref
	mv s5 %x
	
	# Iterate through array
	loop:
		lw s6 0(s1)
		bne s6 s5 not_equal
		j continue
		not_equal:
			sw s6 0(s4)
			addi s3 s3 1
			addi s4 s4 4
		continue:
			addi s0 s0 1
			addi s1 s1 4
			blt s0 s2 loop
	
	# Load destination array's length to a0
	mv a0 s3
	
	# Restore registers
	lw s0 (sp)
	lw s1 4(sp)
	lw s2 8(sp)
	lw s3 12(sp)
	lw s4 16(sp)
	lw s5 20(sp)
	lw s6 24(sp)
	addi sp sp 28
.end_macro		

.macro print_array %array_ref %length
	# Store register's values on stack
	addi sp sp -16
	sw s0 (sp)
	sw s1 4(sp)
	sw s2 8(sp)
	sw s3 12(sp)
	
	mv s0 %array_ref
	li s1 0 # index
	mv s2 %length
	la a0 open_bracket
	li a7 4
	ecall
	beqz s2 skip
	print_loop:
		lw s3 (s0)
		mv a0 s3
		li a7 1
		ecall
		la a0 whitespace
		li a7 4
		ecall
		addi s1 s1 1
		addi s0 s0 4
		blt s1 s2 print_loop
	skip:
	la a0 closing_bracket
	li a7 4
	ecall
	# Restore registers
	lw s0 (sp)
	lw s1 4(sp)
	lw s2 8(sp)
	lw s3 12(sp)
	addi sp sp 16
.end_macro
		
	