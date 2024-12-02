# 4-5 баллов
* Решение преведено в двух файлах
* Параметры вводятся из консоли
* Комментарии присутствуют
* Данные обрабатываются в отдельном макросе:
  ```
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
  ```
* Файлы `test1.txt`, `output1.txt` и тд. присутствуют в подкаталоге.
# 6-7 баллов
* Для чтения данных реализован буфер размером 512 байт. За чтение отвечает макрос:
  ```
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
  	li s1 0 # digit counter
  	li s2 0 # letter counter
  	
  	read_loop:
  		read_from_file s0 %buffer s6 s3 # read from file and save to buffer, store amount of bytes read in s3
  		count_digits_and_letters s4 s5 %buffer # count digits and letters in buffer and save to temporary counters
  		add s1 s1 s4
  		add s2 s2 s5
  		beq s3 s6 read_loop # if amount of bytes read == buffer size, repeat
  
  	done_reading:
  		close_file s0
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
  ```
  Каждую итерацию читается кусок файла, и для этого куска считается количество букв и цифр.
# 8 баллов
* Возможность вывода результатов в консоль реализует следующий кусок кода:
  ```
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
  ```