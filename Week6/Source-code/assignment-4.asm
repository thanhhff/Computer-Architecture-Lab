# Assignment 4 - Nguyen Trung Thanh - 20176874
# Insertion sort algorithm
.data
	A: .word 7, -2, 5, 1, 5, 6, 7, 3, 6, 8, 8, 59, 5
    
.text
main: 
    	la $a0, A 	#$a0 = Address(A[0])
    	li $a1, 13	# length of array A: n
   	 j sort 	#sort
    
after_sort: 
    	li $v0, 10 	#exit
    	syscall
end_main:

#--------------------------------------------------------------

sort: 

	li $t0, 1	# index i cua vong lap thu nhat
	
loop: 	# for i in range(1, len(arr))
	
	
	add $t1, $t0, $t0 	#put 2i in $t0
	add $t2, $t1, $t1 	#put 4i in $t0
	add $t2, $t2, $a0
	lw  $s1, 0($t2)		# load A[i]; key = arr[i] 
	
	sub $t3, $t0, 1		# j = i-1

while:
	
	slt $t8, $t3, $zero 	# if j < 0 
	bne $t8, $zero, end_while
	
	add $t4, $t3, $t3 	#put 2i in $t3
	add $t5, $t4, $t4 	#put 4i in $t3
	add $t5, $t5, $a0
	lw  $s2, 0($t5)		#  arr[j]

	slt $t9, $s1, $s2	# key < arr[j]
	beq $t9, $zero, end_while
	
	# Swap
	lw $s3, 4($t5)
   	sw $s3, 0($t5) 		# arr[j + 1] = arr[j] 
    	sw $s2, 4($t5) 

    	sub $t3, $t3, 1		# j -= 1
	j   while 
end_while:

	add $t3, $t3, 1
	mul $s5, $t3, 4 
	add $s6, $s5, $a0
	sw  $s1, 0($s6)	#  arr[j + 1] = key 

	add $t0, $t0, 1
	slt $t6, $t0, $a1 	# if i < n return 1
	beq $t6, $zero, end_loop
	j   loop

end_loop:
	
	
	
	
	
	

