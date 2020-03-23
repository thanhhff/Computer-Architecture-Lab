#Laboratory 3, Home Assigment 2
# the index i,  $s1
# the starting address of A,  $s2
# the comparison constant n,  $s3
# step $s4
# sum are found in registers $s5
	
.data 
	arr: .word 1,1,1,1,1,1

.text
	li $s1, -1
	la $s2, arr
	li $s3, 5
	li $s4, 1
	li $s5, 0	

loop:
	add $s1,$s1,$s4  #i=i+step
	add $t1,$s1,$s1  #t1=2*s1
	add $t1,$t1,$t1  #t1=4*s1
	add $t1,$t1,$s2  #t1 store the address of A[i]
	lw  $t0,0($t1)    #load value of A[i] in $t0
	add $s5,$s5,$t0  #sum=sum+A[i]
	bne $s1,$s3,loop #if i != n, goto loop