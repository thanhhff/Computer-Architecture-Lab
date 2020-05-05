
.data
	notice: .asciiz "Nhap gia tri so nguyen: "
	result: .asciiz "digitDegree = "
	error: .asciiz "Gia tri nhap vao khong dung kieu!"
	number: .word
	
.text
main:
	# Nhap gia tri so nguyen
	li $v0, 51
	la $a0, notice
	syscall
	
	addi $t0, $zero, -1
	beq $t0, $a1, error_input
	slt $t0, $a0, $zero	# neu gia tri nhap vao < 0 => return 1
	bne $t0, $zero, error_input
	
	j	end_error_input
error_input:
	la $v0, 55
	la $a0, error
	syscall 
	j 	end_main
	
end_error_input:
	
	add $a1, $a0, $zero
	la $a0, number
	jal digit_degree
	nop
	
	# Show output
	add $a1, $v0, $zero
	li $v0, 56
	la $a0, result
	syscall
	
end_main:
	li $v0, 10
	syscall
	
#-----------------
digit_degree:	
	addi $v0, $zero, 0
	addi $s0, $zero, 10
	add $s1, $zero, $a1
	
check:	
	slt $t0, $s1, $s0 	# if number < 10 => return 1
	bne $t0, $zero, end_digit_degree
	
	addi $v0, $v0, 1
	addi $t7, $zero, 0	# So luong cac chu so n
loop:	
	div $t1, $s1, 10
	mfhi $t1
	
	add $t2, $t7, $a0	# vi tri cua phan tu
	sb $t1, 0($t2)
	addi $t7, $t7, 1
	
	div $s1, $s1, 10
	beq $s1, $zero, end_loop
	
	j loop
	
end_loop:

	addi $s2, $zero, 0	# tong cua cac chu so
	addi $t3, $zero, 0	# i = 0
for:
	add $t5, $t3, $a0	# vi tri
	lb $s3, 0($t5)
	
	add $s2, $s2, $s3	# sum = sum + a[i]
	
	addi $t6, $zero, 0	# xoa bo
	sb $t6, 0($t5)
	
	addi $t3, $t3, 1	# i = i + 1
	slt $t4, $t3, $t7	# i >= n => False 0
	beq $t4, $zero, end_for
	j	for

end_for:
	sle $t0, $s0, $s2	# if 10 <= $s2 => return 1
	beq $t0, $zero, end_digit_degree
	
	add $s1, $zero, $s2

	j 	check

end_digit_degree:
	jr 	$ra
