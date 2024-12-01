.data
	input_filename: .space 128
	input_filename_prompt: .asciz "Введите имя файла с входными данными: "
	output_filename: .space 128
	output_filename_prompt: .asciz "Введите имя файла для записи результата: "
	print_to_console_prompt: .asciz "Вывести результат в консоль? (Y/N): "
	buffer: .space 512
.include "macros.asm"
.text 
main:
	input_string input_filename_prompt, input_filename
	
	li s0 512 # set s0 to buffer size
	count input_filename, buffer, s0, s1, s2 # store digits' amount in s1 & letters' amount in s2

exit:
	li a0 0
	li a7 10
	ecall
	
	
	