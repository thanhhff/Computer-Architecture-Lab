# Nguyen Trung Thanh - 20176874

.text
	li $s1 0x7fffffff # Gia tri lon nhat cua so 32-bit
	li $s2 0x6fffffff
	
start:
	li $t0, 0 # No overflow is default status 
	
	# s3 = s1 + s2
	addu $s3, $s1, $s2
	
	xor $t1, $s1, $s2 # Test if $s1 and $s2 have the same sign
	# Neu t1 < 0 thi nhay xuong EXIT
	bltz $t1, EXIT # If not, exit
	
	xor $t2, $s1, $s3
	# Neu t2 > 0 thi nhay xuong EXIT
	bgtz $t2, EXIT
	
	OVERFLOW:
	li $t0, 1 # the result is overflow
EXIT:

