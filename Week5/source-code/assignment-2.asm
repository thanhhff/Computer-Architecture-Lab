.data
Message_1: .asciiz "The sum of "
Message_2: .asciiz " and "
Message_3: .asciiz " is: "

 .text
 	li $s0, 2
 	li $s1, 3
 	add $s2, $s0, $s1
 	
 	li $v0, 4
 	la $a0, Message_1
 	syscall 
 	
 	li $v0, 1
 	add $a0, $zero, $s0
 	syscall
 	
 	li $v0, 4
 	la $a0, Message_2
 	syscall
 	
 	li $v0, 1
 	add $a0, $zero, $s1
 	syscall
 	
 	li $v0, 4
 	la $a0, Message_3
 	syscall 
 	
 	li $v0, 1
 	add $a0, $zero, $s2
 	syscall
 