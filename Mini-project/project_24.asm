#----------------------------------------------------------
# Team 4: Nguyen Trung Thanh - Hoang Thi Thu Trang
# Project 24: Cyclone Word (Challenge)
#
# Cyclone Word (challenge)
# Cyclone words are English words that have a sequence of characters in alphabetical order when following a cyclic pattern.
# Write a function to determine whether a word passed into a function is a cyclone word. 
# You can assume that the word is made of only alphabetic characters, and is separated by whitespace.
#-----------------------------------------------------------


#-----------------------------------------------------------
# @input: mot tu bat ky luu vao c_word
# @idea: 
# 	TH1: Neu tu nhap vao co do dai bang 0 hoac bang 1 => TRUE
#	TH2: Neu tu nhap vao co do dai > 1:
#	     + Su dung vong lap co i bat dau bang 0 (Vi tri dau tien)
#	       va j = n - 1 (vi tri cuoi cung cua tu do)
#	     + Thuc hien so sanh c_word[i] voi c_word[j] va c_word[i+1] voi c_word[j] va cu tiep tuc cho den khi i >= j
#	       Neu c_word[i] <= c_word[j] va c_word[j] <= c_word[i+1] => TRUE
#-----------------------------------------------------------


.data
	# Chu y so luong ki tu cua tu
	c_word: .asciiz "adjourned"		# input dau vao
	true: .asciiz "True"
	false: .asciiz "False"
.text

main:
	la $a0, c_word
	
	# So ki tu cua tu
	addi $a1, $zero, 9
	
	jal cyclone_word
	nop 
	
	beq $v0, $zero, false_answer

true_answer:
	li $v0, 55
	la $a0, true
	syscall
	j end_main
	
false_answer:
	li $v0, 55
	la $a0, false
	syscall
	
end_main:
	li $v0, 10
	syscall

#--------------
	
cyclone_word:
	# If length of word = 0 or = 1 => TRUE
	beq $a1, $zero, return_true
	addi $t0, $zero, 1
	beq $a1, $t0, return_true

	addi $t0, $zero, 0			# i: 0
	sub $t1, $a1, 1				# j: n - 1
loop:
	slt $t2, $t0, $t1			# if i >= j => return 0
	beq $t2, $zero, return_true
	
	add $s1, $a0, $t0
	lb $s1, 0($s1)				# c_word[i]
	add $s2, $a0, $t1
	lb $s2, 0($s2)				# c_word[j]
	sle $t3, $s1, $s2			# if c_wrod[i] > c_word[j] false => 0
	beq $t3, $zero, return_false		# if return 0
	
	addi $t4, $t0, 1
	add $t4, $a0, $t4
	lb $s3, 0($t4)				# c_word[i+1]
	sle $t5, $s2, $s3			# if c_word[j] > c_word[i+1] false => 0
	beq $t5, $zero, return_false
	
	addi $t0, $t0, 1			# i = i + 1
	addi $t1, $t1, -1			# j = j - 1
	j	loop
end_loop:
	
return_true:
	addi $v0, $zero, 1
	jr 	$ra
return_false:
	addi $v0, $zero, 0
	jr 	$ra
