main:
	mv t0, zero # pseudo
	li t1, 1 # pseudo
	
	li a7, 5 # pseudo
	ecall
	mv t3, a0 # pseudo
fib:
	beqz t3, finish # pseudo
	add t2, t1, t0 # R type
	mv t0, t1 # pseudo
	mv t1, t2 # pseudo
	addi t3, t3, -1 # I type
	j fib # pseudo
finish:
	li a7, 1 # pseudo
	mv a0, t0 # pseudo
	ecall