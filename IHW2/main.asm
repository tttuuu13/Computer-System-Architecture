.data
	root_with_error_msg: .asciz "Корень с точностью "
	equals: .asciz " равен: "
.include "macros.asm"
.text
# sets t5 to user's input
input_from_keyboard:
	# set t5 to the lenght of error's digits after comma
	get_error_digits_after_comma t5

# main function. takes amount of digits after comma at t5 as input, outputs value to fs0
main:
	li t0 1 # left end
	li t1 2 # right end
	
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
	la a0 root_with_error_msg
	li a7 4 
	ecall 
	
	fmv.d fa0 f3
	li a7 3
	ecall
	
	la a0 equals
	li a7 4
	ecall
	
	fmv.d fa0 fs0
	li a7 3
	ecall