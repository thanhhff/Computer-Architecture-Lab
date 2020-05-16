#----------------------------------------------------------
# Team 4: Nguyen Trung Thanh - Hoang Thi Thu Trang
# Project 21 - Digit Degree
# Let's define the digit degree of some positive integer as the number of times 
# we need to replace this number with the sum of its digits until we get to a one digit number. 
# Given an integer, find its digit degree.
# Example:
# - For n = 5, the output should be digitDegree(n) = 0
# - For n = 100, the output should be digitDegree(n) = 1
# - For n = 91, the output should be digitDegree(n) = 2

#-----------------------------------------------------------

#-----------------------------------------------------------
# @input: mot so nguyen duong
# digit_degree ban dau bang 0
# @idea: 
#	1. Check: Neu so < 10: return digit_degree; Neu so > 10: digit_degree += 1 va tiep tuc buoc 2.
#	2. Su dung vong lap de tach cac chu so bang cach chia dan cho 10 va luu vao mang number.
#	3. Count: tinh tong cac chu so va quay lai check
#-----------------------------------------------------------


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
	
	# Kiem tra input nhap vao co phai la so nguyen duong hay khong
	addi $t0, $zero, -1
	beq $t0, $a1, error_input
	slt $t0, $a0, $zero		# neu gia tri nhap vao < 0 => return 1
	bne $t0, $zero, error_input
	
	j	end_error_input
error_input:
	la $v0, 55
	la $a0, error
	syscall 
	j 	end_main
	
end_error_input:
	
	add $a1, $a0, $zero		# So nhap vao duoc luu vao $a1
	la $a0, number			# Luu vi tri cua number
	jal digit_degree
	nop
	
	# Hien thi ket qua
	add $a1, $v0, $zero
	li $v0, 56
	la $a0, result
	syscall
	
end_main:
	li $v0, 10
	syscall
	
#-----------------------------------------------------------
# Thuc hien tinh digit_degree
#-----------------------------------------------------------
digit_degree:	
	addi $v0, $zero, 0		# Dau ra cua chuong trinh con
	addi $s0, $zero, 10		# $s0 luu gia tri 10 de so sanh
	add $s1, $zero, $a1		# $s1 gia tri dau vao cua chuong trinh

#-----------------------------------------------------------
# 1. Check: Neu so < 10: return digit_degree; Neu so > 10: digit_degree += 1 va tiep tuc buoc 2.
#-----------------------------------------------------------

check:	
	slt $t0, $s1, $s0 		# if number < 10 => return 1
	bne $t0, $zero, end_digit_degree
	addi $v0, $v0, 1		# Neu so do > 10 => degit_degree += 1
	
#-----------------------------------------------------------
# 2. Su dung vong lap de tach cac chu so bang cach chia dan cho 10 va luu vao mang number.
#-----------------------------------------------------------	
	
	addi $t7, $zero, 0		# So luong cac chu so n
loop:	
	div $t1, $s1, 10
	mfhi $t1
	
	add $t2, $t7, $a0		# vi tri cua phan tu
	sb $t1, 0($t2)
	addi $t7, $t7, 1
	
	div $s1, $s1, 10
	beq $s1, $zero, end_loop
	
	j loop
	
end_loop:

#-----------------------------------------------------------
# 3. Count: tinh tong cac chu so va quay lai check	
#-----------------------------------------------------------

	addi $s2, $zero, 0		# tong cua cac chu so
	addi $t3, $zero, 0		# i = 0
for:
	add $t5, $t3, $a0		# vi tri
	lb $s3, 0($t5)
	
	add $s2, $s2, $s3		# sum = sum + a[i]
	
	addi $t6, $zero, 0		# xoa bo
	sb $t6, 0($t5)
	
	addi $t3, $t3, 1		# i = i + 1
	slt $t4, $t3, $t7		# i >= n => False 0
	beq $t4, $zero, end_for
	j	for

end_for:
	sle $t0, $s0, $s2		# if 10 <= $s2 => return 1
	beq $t0, $zero, end_digit_degree
	
	add $s1, $zero, $s2		# tong moi sau khi cong cac chu so

	j 	check

end_digit_degree:
	jr 	$ra

#-----------------------------------------------------------
# END
#-----------------------------------------------------------