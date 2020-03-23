#Laboratory Exercise 3, Assignment 4
# Nguyn Trung Thanh - 20176874

# Modify the Assignment 1, so that the condition tested is 
# a. i<j
# b. i>=j
# c. i+j<=0 
# d. i+j>m+n

.text 
	li $s1, 1 # i
	li $s2, 2 # j 

################# a. i < j #################

start:
	slt $t0, $s1, $s2         # i < j
	beq $t0, $zero, else 	  # branch to else if i >= j
	addi $t1, $t1, 1	  # then part: x=x+1
	addi $t3, $zero, 1        # z=1
	j endif   		  # skip “else” part
else:
	addi $t2,$t2,-1   # begin else part: y=y-1
	add $t3,$t3,$t3   # z=2*z 
endif: