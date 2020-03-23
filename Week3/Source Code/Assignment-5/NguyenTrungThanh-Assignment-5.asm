# Assigment 5 - Nguyen Trung Thanh - 20176874

# Modify the Assignment 2, so that the condition tested at the end of the loop is
# a.     i < n
# b.     i <= n
# c.     sum >= 0
# d.     A[i] == 0

.data 
	arr: .word 1,1,1,1,1,1

.text
	li $s1, -1
	la $s2, arr
	li $s3, 5
	li $s4, 1
	li $s5, 0	

################# a. i < n #################

loop:
	add $s1,$s1,$s4  #i=i+step
	add $t1,$s1,$s1  #t1=2*s1
	add $t1,$t1,$t1  #t1=4*s1
	add $t1,$t1,$s2  #t1 store the address of A[i]
	lw  $t0,0($t1)    #load value of A[i] in $t0
	add $s5,$s5,$t0  #sum=sum+A[i]
	
	slt $t8, $s1, $s3  # i < n => return 1: if (i<n) else return 0;
	bne $t8, $zero, loop # if: $t8 != $zero => loop
	
	
################# a. i <= n #################

loop:
	add $s1,$s1,$s4  #i=i+step
	add $t1,$s1,$s1  #t1=2*s1
	add $t1,$t1,$t1  #t1=4*s1
	add $t1,$t1,$s2  #t1 store the address of A[i]
	lw  $t0,0($t1)    #load value of A[i] in $t0
	add $s5,$s5,$t0  #sum=sum+A[i]
	
	slt $t8, $s3, $s1  # n < i => if true: return 1; else return 0
	beq $t8, $zero, loop # if: $t8 == $zero => loop


################# a. sum >= 0 #################

loop:
	add $s1,$s1,$s4  #i=i+step
	add $t1,$s1,$s1  #t1=2*s1
	add $t1,$t1,$t1  #t1=4*s1
	add $t1,$t1,$s2  #t1 store the address of A[i]
	lw  $t0,0($t1)    #load value of A[i] in $t0
	add $s5,$s5,$t0  #sum=sum+A[i]
	
	slt $t8, $s5, $zero  # sum < 0 => if true: return 1; else return 0
	beq $t8, $zero, loop # if: $t8 == $zero => loop
	
################# d. A[i] == 0 #################

loop:
	add $s1,$s1,$s4  #i=i+step
	add $t1,$s1,$s1  #t1=2*s1
	add $t1,$t1,$t1  #t1=4*s1
	add $t1,$t1,$s2  #t1 store the address of A[i]
	lw  $t0,0($t1)    #load value of A[i] in $t0
	add $s5,$s5,$t0  #sum=sum+A[i]
	
	beq $zero, $t0, loop
	

