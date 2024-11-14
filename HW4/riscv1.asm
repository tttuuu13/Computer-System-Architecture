.data
	enter_amount_of_elems:   .asciz "\nВведите количество чисел (от 1 до 10): "
	enter_number:            .asciz "\nВведите число: "
	overflow:                .asciz "\nСлучилось переполнение( Последняя сумма: "
	sum_counter:             .asciz "\nЭлементов просуммировано: "
	final_sum:               .asciz "\nСумма элементов: "
	invalid_amount_of_elems: .asciz "\nНекорректное значение, попробуйте еще!"
	.align 2
	array:                   .space 40
.text
	
read_elems_amount:
	# Запрашиваем количество элементов
	la a0, enter_amount_of_elems
	li a7, 4
	ecall
	# Получаем количество элементов
	li a7, 5
	ecall
	mv t1, a0
	# Проверка полученного значения
	li t2, 1
	blt t1, t2, elems_amount_out_of_range
	li t2, 10
	bgt t1, t2, elems_amount_out_of_range
	mv s0, t1 # Сохраняем количество элементов
	la s1, array # Указатель на массив
	li t0, 0 # Индекс
read_number_loop:
	# Заполняем массив
	beq t0, s0, sum_numbers
	la a0, enter_number
	li a7, 4
	ecall
	li a7, 5
	ecall
	sw a0, 0(s1)
	addi s1, s1, 4
	addi t0, t0, 1
	j read_number_loop
	
sum_numbers:
	la s1, array # Указатель на начало массива
	li s2, 0 # Количество просуммированных элементов
	li s3, 0 # Сумма
	j sum_loop

sum_loop:
	beq s2, s0, print_sum
	lw t1, 0(s1)
	add t2, s3, t1
	xor t3, s3, t1
	# Проверка на переполнение
        bltz t3, no_overflow
        xor t3, s3, t2
        bgez t3, no_overflow
        # Вывод сообщения о переполнении и результатов работы программы
        la a0, overflow
        li a7, 4
        ecall
        mv a0, s3
        li a7, 1
        ecall
        la a0, sum_counter
        li a7, 4
        ecall
        mv a0, s2
        li a7, 1
        ecall
        j exit

print_sum:
	# Вывод итоговой суммы
	la a0, final_sum
	li a7, 4
	ecall
	mv a0, s3
	li a7, 1
	ecall
	j exit

no_overflow:
	# Обновление суммы, количества посчитанных элементов и индекса
	mv s3, t2
	addi s2, s2, 1
	addi s1, s1, 4
	j sum_loop
	
	
elems_amount_out_of_range:
	# Сообщение об ошибке, в случае если количество элемента вне диапазона
	la a0, invalid_amount_of_elems
	li a7, 4
	ecall
	j read_elems_amount

exit:
	li a7, 10
	ecall
	