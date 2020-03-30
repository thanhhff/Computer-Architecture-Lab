# Laboratory Exercise 4, Home Assignment 1

.text
	li $s1 0x7fffffff # Gia tri lon nhat cua so 32-bit
	li $s2 0x6fffffff
start:
	li $t0, 0 # No overflow is default status 
	
	# s3 = s1 + s2
	addu $s3, $s1, $s2
	
	# t1 = xor(s1, s2): 2 bit khac nhau gia tri se la 1; nguoc lai, gia tri se la 0.
	xor $t1, $s1, $s2 # Test if $s1 and $s2 have the same sign
	
	# Neu t1 < 0 thi nhay xuong EXIT
	bltz $t1, EXIT # If not, exit
	
	# Neu s3 < s1 => t2 = 1; Nguoc lai, t2 = 0
	slt $t2, $s3, $s1 
	
	bltz $s1, NEGATIVE # Test if $s1 and $s2 is negative?
	beq $t2, $zero, EXIT # $s1 and $s2 is negative
	# if $s3 > $s1 then the result is not overflow
	b OVERFLOW
NEGATIVE:
	bne $t2, $zero, EXIT #s1 and $s2 are negative
	# if $s3 < $s1 then the result is not overflow
OVERFLOW:
	li $t0, 1 # the result is overflow
EXIT:

	

