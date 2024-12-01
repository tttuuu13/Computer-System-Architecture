.macro input_string %prompt %result
	# print prompt
	print_string %prompt

	# get input
	la a0 %result
	li a1 128
	li a7 8
	ecall
	
	# replace newline character with null terminator
	li t0 '\n'
	la t1 %result
	loop:
		lb t2 (t1)
		beq t2 t0 replace
		addi t1 t1 1
		j loop
		
	replace:
		sb zero (t1)
	
.end_macro

.macro print_string %string
	la a0 %string
	li a7 4
	ecall
.end_macro 

.macro open_file %filename %descriptor %flag
	la a0 %filename
	mv a1 %flag
	li a7 1024
	ecall
	mv %descriptor a0
.end_macro 

.macro read_from_file %descriptor %buffer %buffer_size %bytes_read
	# read data from file
	mv a0 %descriptor
	la a1 %buffer
	mv a2 %buffer_size
	li a7 63
	ecall
	
	mv %bytes_read a0
	
	# close file
	mv a0 t0
	li a7 57
	ecall
.end_macro 

.macro count_digits_and_letters %digit_counter %letter_counter %string
	la t0 %string
	loop:
		lb t1 0(t0) # load character from the string
		beqz t1 end # if char is null terminator, exit loop
		
		check_if_uppercase:
			li t2 0x41 # load ASCII "A"
			li t3 0x5A # load ASCII "Z"
			blt t1 t2 check_if_digit
			bgt t1 t3 check_if_lowercase
			addi %letter_counter %letter_counter 1
			j continue
			
		check_if_lowercase:
			li t2 0x61 # load ASCII "a"
			li t3 0x7a # load ASCII "z"
			blt t1 t2 check_if_digit
			bgt t1 t3 check_if_digit
			addi %letter_counter %letter_counter 1
			j continue
			
		check_if_digit:
			li t2 0x30 # load ASCII "0"
			li t3 0x39 # load ASCII "9"
			blt t1 t2 continue
			bgt t1 t3 continue
			addi %digit_counter %digit_counter 1
			j continue
		
		continue:
			addi t0 t0 1
			j loop
	end:
.end_macro

.macro count %input_filename %buffer %buffer_size %digit_counter %letter_counter
	addi sp sp -36
	sw s0 0(sp)
	sw s1 4(sp)
	sw s2 8(sp)
	sw s3 12(sp)
	sw s4 16(sp)
	sw s5 20(sp)
	sw s6 24(sp)

	mv s6 %buffer_size
	li t0 0 # read-only flag
	open_file %input_filename s0 t0 # open file and store file's descriptor in s0
	#la s1 %digit_counter # digit counter
	#la s2 %letter_counter # letter counter
	
	read_loop:
		read_from_file s0 %buffer s6 s3 # read from file and save to buffer, store amount of bytes read in s3
		count_digits_and_letters s4 s5 %buffer # count digits and letters in buffer and save to temporary counters
		add s1 s1 s4
		add s2 s2 s5
		beq s3 s6 read_loop # if amount of bytes read == buffer size, repeat

	done_reading:
		sw s1 28(sp)
		sw s2 32(sp)
		lw s0 0(sp)
		lw s1 4(sp)
		lw s2 8(sp)
		lw s3 12(sp)
		lw s4 16(sp)
		lw s5 20(sp)
		lw s6 24(sp)
		lw %digit_counter 28(sp)
		lw %letter_counter 32(sp)
		addi sp sp 36
	
.end_macro 