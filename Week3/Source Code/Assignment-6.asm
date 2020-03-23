# Assignment 6 - Nguyen Trung Thanh - 20176874

.data 
	arr: .word 2, 3, 5, 7, 1, 2

.text
	li $s1, 0	# i
	la $s2, arr	# array
	li $s3, 6	# n
	li $s4, 1	# step
	
	# $s5 will saved max of array after finished program.
	lw $s5, 0($s2)	# first value of array

loop:
	add $s1,$s1,$s4  #i=i+step
	add $t1,$s1,$s1  #t1=2*s1
	add $t1,$t1,$t1  #t1=4*s1
	add $t1,$t1,$s2  #t1 store the address of A[i]
	lw  $t0,0($t1)   #load value of A[i] in $t0

start:
	slt $t2, $s5, $t0 	# $s5 < $t0; max < A[i]
	beq $zero, $t2, endif
	add $s5, $zero, $t0

endif:	
	bne $s1, $s3, loop