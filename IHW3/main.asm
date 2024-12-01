.data
	input_filename: .space 128
	input_filename_prompt: .asciz "Введите имя файла с входными данными: "
	output_filename: .space 128
	output_filename_prompt: .asciz "Введите имя файла для записи результата: "
	buffer: .space 512
.include "macros.asm"
.text 
main:
	input_string input_filename_prompt, input_filename
	
	li s0 512 # set s0 to buffer size
	count input_filename, buffer, s0, s1, s2
	
	
	