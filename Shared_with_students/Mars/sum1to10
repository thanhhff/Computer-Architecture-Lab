.text
	# $s1: i
	# $s2: starting address
	# $s3: n
	# $s4: step
	# $s5: sum
	
	addi	$s1, $zero, 1		# i = 0
	addi	$s3, $zero, 11		# number of items
	addi	$s4, $zero, 1		# step = 1
	addi	$s5, $zero, 0		# sum = 0
loop:
	# determine address of item i: 4*i
	add	$s5, $s5, $s1
	add	$s1, $s1, $s4		# i = i + step, $s1 <= i, $s4 <= step
	bne	$s1, $s3, loop
	
	# print the sum
	li 	$v0, 1
    	move 	$a0, $s5
    	syscall
    	
    	# End Program
    	li 	$v0, 10
    	syscall
