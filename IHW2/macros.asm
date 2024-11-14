.macro solve_for_x %result %x
	addi sp sp -72
	fsd %x (sp)
	sw t1 8(sp)
	sw t2 12(sp)
	fsd f0 16(sp)
	fsd f1 24(sp)
	fsd f2 32(sp)
	fsd f3 40(sp)
	fsd f4 48(sp)
	fsd f5 56(sp)
	
	# set f0 to %x
	fmv.d f0 %x
	# set f1 to 2.5
	li t1 5
	li t2 2
	fcvt.d.w f1 t1
	fcvt.d.w f2 t2
	fdiv.d f1 f1 f2
	# set f2 to x^3
	fmul.d f2 f0 f0
	fmul.d f2 f2 f0
	# set f3 to x^4
	fmul.d f3 f2 f0
	# set f4 to x^4-x^3
	fsub.d f4 f3 f2
	# save result
	fsub.d f5 f4 f1
	fsd f5 64(sp)

	fld %x (sp)
	lw t1 8(sp)
	lw t2 12(sp)
	fld f0 16(sp)
	fld f1 24(sp)
	fld f2 32(sp)
	fld f3 40(sp)
	fld f4 48(sp)
	fld f5 56(sp)
	fld %result 64(sp)
	addi sp sp 72
.end_macro

.macro find_next_x_secant_method %result %x1 %x2
	addi sp sp -96
	fsd %x1 (sp)
	fsd %x2 8(sp)
	fsd f0 16(sp)
	fsd f1 24(sp)
	fsd f2 32(sp)
	fsd f3 40(sp)
	fsd f4 48(sp)
	fsd f5 56(sp)
	fsd f6 64(sp)
	fsd f7 72(sp)
	fsd f7 80(sp)

	# set f6 to %x1 and f7 to %x2
	fmv.d f6 %x1
	fmv.d f7 %x2
	# set f0 to f(x2)
	solve_for_x f0 f7
	# set f1 to f(x1)
	solve_for_x f1 f6
	# set f2 to x1 * f(x2)
	fmul.d f2 f6 f0
	# set f3 to x2 * f(x1)
	fmul.d f3 f7 f1
	# set f4 to x1 * f(x2) - x2 * f(x1)
	fsub.d f4 f2 f3
	# set f5 to f(x2) - f(x1)
	fsub.d f5 f0 f1
	# set %result to x3 value
	fdiv.d f8 f4 f5
	fsd f8 88(sp)
	
	fld %x1 (sp)
	fld %x2 8(sp)
	fld f0 16(sp)
	fld f1 24(sp)
	fld f2 32(sp)
	fld f3 40(sp)
	fld f4 48(sp)
	fld f5 56(sp)
	fld f6 64(sp)
	fld f7 72(sp)
	fld f8 80(sp)
	fld %result 88(sp)
	addi sp sp 96
.end_macro

.macro find_x_secant_method %result %x1 %x2 %error
	addi sp sp -92
	fsd %x1 (sp)
	fsd %x2 8(sp)
	fsd f0 16(sp)
	fsd f1 24(sp)
	fsd f2 32(sp)
	fsd f3 40(sp)
	fsd f4 48(sp)
	fsd f5 56(sp)
	fsd f6 64(sp)
	fsd %error 72(sp)
	sw t0 88(sp)
	
	fmv.d f0 %x1
	fmv.d f1 %x2
	fmv.d f6 %error
	
	# find next x
	find_next_x_secant_method f2 f0 f1
	
	loop:
		# update x1 and x2
		fmv.d f0 f1
		fmv.d f1 f2
		find_next_x_secant_method f2 f0 f1
		# find abs value of difference between previous and current x
		fsub.d f4 f2 f1
		fabs.d f5 f4
		# check if the difference is less than error
		flt.d t0 f5 f6
		beqz t0 loop
	
	# save last x value
	fsd f2 80(sp)
	
	fld %x1 (sp)
	fld %x2 8(sp)
	fld f0 16(sp)
	fld f1 24(sp)
	fld f2 32(sp)
	fld f3 40(sp)
	fld f4 48(sp)
	fld f5 56(sp)
	fld f6 64(sp)
	fld %error 72(sp)
	fld %result 80(sp)
	lw t0 88(sp)
	addi sp sp 92
.end_macro

.macro input_int %result	
	li a7 5
	ecall
	
	mv %result a0
.end_macro

.macro output_double %value	
	fmv.d fa0 %value
	li a7 3
	ecall
.end_macro

.macro output_string %string
	mv a0 %string
	li a7 4
	ecall
.end_macro 
