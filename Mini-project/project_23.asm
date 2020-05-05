# Surpassing words are English words for which the gap between each adjacent pair of letters strictly increases. 
# These gaps are computed without "wrapping around" from Z to A.

.data
	input_word: .asciiz "superb"
	true: .asciiz "True"
	false: .asciiz "False"
	gap_length: .word

.text
main:
	# so cac phan tu cua input_word
	addi $a0, $zero, 6	# n
	la $a1, input_word
	la $a2, gap_length

	
	jal check
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
	
	
###############


check:
	addi $t0, $zero, 0 	# i = 0	
	sub $t1, $a0, 1		# $t1 = n - 1
loop:
	
	addi $t4, $t0, 1	# j = i + 1
	
	add $s0, $a1, $t0
	lb $s0, 0($s0)		# A[i]
	
	add $s1, $a1, $t4
	lb $s1, 0($s1)		# A[i+1]
	
	sub $s2, $s0, $s1 
	
	slt $t5, $s2, $zero	# if $s2 > 0 => 0
	beq $t5, $zero, continue
	
	nor $s2, $s2, $zero	# Neu $s2 < 0 => Dao dau $s2 => Duowng
	add $s2, $s2, 1
	

continue:
	add $t2, $t0, $a2
	sb $s2, 0($t2)
	
	addi $t0, $t0, 1	# i = i + 1
	slt $t3, $t0, $t1	# i < n - 1 => 1; false => 0
	beq $t3, $zero, end_loop
	j	loop
	
end_loop:


	addi $t0, $zero, 0 	# i = 0	
	sub $t1, $a0, 2		# $t1 = n - 2

loop_2:	
	addi $t4, $t0, 1	# j = i + 1
	
	add $s0, $a2, $t0
	lb $s0, 0($s0)		# B[i]
	
	add $s1, $a2, $t4
	lb $s1, 0($s1)		# B[i+1]
	
	slt $t2, $s0, $s1	# B[i] < B[j] => 1
	beq $t2, $zero, return_false
	
	addi $t0, $t0, 1	# i = i + 1
	slt $t3, $t0, $t1	# i < n - 2 => 1; false => 0
	beq $t3, $zero, end_loop_2
	
	j   loop_2
end_loop_2:
	
return_true:
	addi $v0, $zero, 1
	jr 	$ra
return_false:
	addi $v0, $zero, 0
	jr 	$ra
	


	