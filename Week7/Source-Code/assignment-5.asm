# Assignment 5

# max => save in $a0
# min => save in $a1

.text

main:
	li $s0, -1
	li $s1, 0
	li $s2, -200
	li $s3, 4
	li $s4, 20
	li $s5, 5
	li $s6, 2
	li $s7, 100
	
	jal start
	nop
	
	li	$v0, 10	#exit
	syscall
	
endmain:

start:
	add $a0, $zero, $s0	# max
	add $a1, $zero, $s0	# min

push:
	add  $t7, $sp, $zero	# luu gia tri sp de ket thuc 
	addi $sp, $sp, -32	# push cac gia tri s0 -> s7 
	sw $s0, 28($sp)
	sw $s1, 24($sp)
	sw $s2, 20($sp)
	sw $s3, 16($sp)
	sw $s4, 12($sp)
	sw $s5, 8($sp)
	sw $s6, 4($sp)
	sw $s7, 0($sp)
	
pop:
	lw 	$t0, 0($sp)
	sub 	$t1, $t0, $a0	# if $t0 - $a0 > 0 => $t0 > $a0 => Max moi la $t0
	bgez 	$t1, change_max
continue:
	sub 	$t2, $t0, $a1   # if $t0 - $a1 < 0 =>$t0 < $a1 => Min moi la $t0
	bltz	$t2, change_min
	beq 	$t7, $sp, done	# Neu $sp = gia tri $sp ban dau thi ket thuc
	addi 	$sp, $sp, 4
	j	pop
	
change_max:
	add 	$a0, $zero, $t0
	j 	continue

change_min:
	add 	$a1, $zero, $t0
	j	pop
	
done:
	jr $ra
	
	
	
	
	
	
	
	
	
	
	
	
	
	
