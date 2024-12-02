.data
	input_filename: .space 128
	output_filename: .space 128
	digit_counter: .space 100
	letter_counter: .space 100
	buffer: .space 512
	input_filename_prompt: .asciz "Введите имя файла с входными данными: "
	output_filename_prompt: .asciz "Введите имя файла для записи результата: "
	print_to_console_prompt: .asciz "Вывести результат в консоль? (Y/N): "
	new_line: .asciz "\n"
	space: .asciz " "
.include "macros.asm"
.text 
main:
	input_string input_filename_prompt, input_filename
	
	li s0 512 # set s0 to buffer size
	count input_filename, buffer, s0, s1, s2 # store digits' amount in s1 & letters' amount in s2
	
	input_string output_filename_prompt, output_filename
	
	# convert counter values to string
	int_to_string s1 digit_counter s3
	int_to_string s2 letter_counter s4
	
	li t0 9 # flag to open in write-append mode
	open_file output_filename s0 t0 # open file and save descriptor to s0
	

	# write digits counter
	la t1 digit_counter
	write_to_file s0 t1 s3

	# write space inbetween
	la t1 space
	li t2 1
	write_to_file s0 t1 t2

	# write letter counter
	la t1 letter_counter
	write_to_file s0 t1 s4
	
	close_file s0
	
	# ask whether data should be printed in the console or not
	print_string print_to_console_prompt
	li a7 12
	ecall
	li t0 'Y'
	beq a0 t0 print_to_console # compare ASCII value of input to ASCII value of char "Y"
	j exit
	print_to_console:
		print_string new_line
		print_string digit_counter
		print_string space
		print_string letter_counter
		
	
exit:
	li a0 0
	li a7 10
	ecall
	
	
	