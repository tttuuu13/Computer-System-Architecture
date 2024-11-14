.data
	enter_divident: .asciz "Введите делимое: "
	enter_divisor: .asciz "Введите делитель: "
	quotient: .asciz "Частное: "
	reminder: .asciz "Остаток: "
	zero_division_error: .asciz "Ошибка деления на ноль!\n"
	try_again: .asciz "Попробуйте еще раз\n"
	new_line: .asciz "\n"
.text
start:
	# Ввод делимого
	la a0, enter_divident
	li a7, 4
	ecall
	li a7, 5
	ecall
	mv t0, a0
	# Ввод делителя
	la a0, enter_divisor 
	li a7, 4
	ecall
	li a7, 5
	ecall
	beq a0, zero, divisor_is_zero # Проверка делителя на ноль
	mv t1, a0
	bltz t0, make_divident_positive
	mv t2, t0
	check_divisor:
	bltz t1, make_divisor_positive
	mv t3, t1
	j init

make_divident_positive:
	neg t2, t0
	j check_divisor
	
make_divisor_positive:
	neg t3, t1
	j init
	
init:
	li t4, 0 # Частное
	j division_loop

division_loop:
	blt t2, t3, exit_loop
	sub t2, t2, t3
	addi t4, t4, 1
	j division_loop

exit_loop:
	bltz t0, divident_is_negative
	bltz t1, divident_is_positive_and_divisor_is_negative
	j show_result

divident_is_negative:
	bgez t1, divident_is_negative_and_divisor_is_positive
	neg t2, t2
	j show_result

divident_is_negative_and_divisor_is_positive:
	neg t4, t4
	neg t2, t2
	j show_result

divident_is_positive_and_divisor_is_negative:
	neg t4, t4
	j show_result

show_result:
	la a0, quotient
	li a7, 4
	ecall
	mv a0, t4
	li a7, 1
	ecall
	la a0, new_line
	li a7, 4
	ecall
	la a0, reminder
	li a7, 4
	ecall
	mv a0, t2
	li a7, 1
	ecall
	j end

divisor_is_zero:
	la a0, zero_division_error
	li a7, 4
	ecall
	la a0, try_again
	li a7, 4
	ecall
	j start

end:
	li a7, 10
	ecall
	