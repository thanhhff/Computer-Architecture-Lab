# Laboratory Exercise 2, Assignment 4
.text
	# Assign X, Y
	addi $t1, $0, 5
	addi $t2, $zero, -1 
	
	# Expression Z = 2X + Y
	add $s0, $t1, $t1 # x + x = 2x
	add $s0, $s0, $t2