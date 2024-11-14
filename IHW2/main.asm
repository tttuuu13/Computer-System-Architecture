.data
	root_with_error_msg: .asciz "Корень с точностью "
	equals: .asciz " равен: "
	ask_for_error_margin_msg: .asciz "Введите необходимую точность (количество знаков после запятой): "
	error: .asciz "Количество знаков после запятой должно быть в диапазоне от 3 до 8 включительно!\n"
.include "macros.asm"
.global main
.text
# sets t5 to user's input
input_from_keyboard:
	# set t5 to the lenght of error's digits after comma
	la t0 ask_for_error_margin_msg
	output_string t0
	input_int t5
	jal main
	j exit

# main function. takes amount of digits after comma at t5 as input, outputs value to fs0
main:
	li t0 1 # left end
	li t1 2 # right end
	
	# check boundaries
	li t2 3 # min_value
	li t3 8 # max_value
	blt t5 t2 show_error
	bgt t5 t3 show_error
	j continue
	show_error:
		la a0 error
		li a7 4
		ecall
		ret
	
	continue:
	addi t5 t5 -1
	li t4 10 # current number
	li t6 10 # just 10
	
	loop:
		mul t4 t4 t6
		addi t5 t5 -1
		bgtz t5 loop
	
	li t3 1
	fcvt.d.w f3 t3
	fcvt.d.w f4 t4
	fdiv.d f3 f3 f4
	fcvt.d.w f1 t0
	fcvt.d.w f2 t1
	
	find_x_secant_method fs0 f1 f2 f3

# outputs value from fs0 and error from f3
output:
	la t0 root_with_error_msg
	output_string t0
	
	output_double f3
	
	la t0 equals
	output_string t0
	
	output_double fs0
	
	ret
exit:
	li a7 10
	ecall
