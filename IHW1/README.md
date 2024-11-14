# input.asm
## Файл для работы при вводе клавиатуры
```
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
```
# macros.asm
## Файл с макросами
```
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
```
# 4 - 5 баллов
* Решение приведено выше, ввод осуществляется с клавиатуры, вывод осуществляется на дисплей. Пример ввода-вывода программы:
	```
	Please enter N(0 <= N <= 10): 3
	Please enter X: 2
	Enter number: 1
	Enter number: 2
	Enter number: 3
	[1 3 ]
	-- program is finished running (0) --
	```
 * Комментарии на месте
 * Тесты будут дальше

# 6 - 7 баллов
* В программе используются макросы

# 8 баллов
* Функция main может использоваться отдельно совместно с библиотекой макросов, аргументы передаются с помощью регистров а1...а4
* Программа для автоматического прогона тестовых данных:
	```
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
	```
	Выходные данные для представленных тестов совпадают с ожидаемыми:
	```
	[1 2 4 5 ]
	[1 1 1 1 1 1 1 1 1 ]
	[]
	[3 ]
	[9999999 ]
	[0 0 0 0 0 0 ]
	
	-- program is finished running (0) --
	```
# 9 баллов
* Макросы добавлены и находятся в отдельном файле **macros.asm**

# 10 баллов
* Программа разбита на несколько файлов, программы для ввода являются унифицированными - принимают промпт в качестве аргумента, записывают входные данные в а0.
* Макросы вынесены в отдельную библиотеку-файл
