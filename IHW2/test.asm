.data
	root_with_error_msg: .asciz "\nКорень с точностью "
	equals: .asciz " равен: "
	error: .asciz "\nКоличество знаков после запятой должно быть в диапазоне от 3 до 8 включительно!"
.include "macros.asm" 
.text
li s0 -1
li s1 10

test_loop:
	mv t5 s0
	jal main
	addi s0 s0 1
	ble s0 s1 test_loop

li a7 10
ecall
	
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
	
	ret