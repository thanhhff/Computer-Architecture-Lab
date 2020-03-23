.text 
	li $s1, 1 # i
	li $s2, 2 # j 

################# b. i >= j #################

start:
	beq $s1, $s2, continue
	slt $t0, $s2, $s1         # j < i
	beq $t0, $zero, else 	  # branch to else if j > i
continue:
	addi $t1, $t1, 1	  # then part: x=x+1
	addi $t3, $zero, 1        # z=1
	j endif   		  # skip “else” part
else:
	addi $t2,$t2,-1   # begin else part: y=y-1
	add $t3,$t3,$t3   # z=2*z 
endif:
