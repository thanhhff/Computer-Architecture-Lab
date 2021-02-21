#--------------------------------------------------------------------------------------------------------------------
# Project 5: Display decimal numbers in binary and hexadecimal.
#
# Task: Write a program to get decimal numbers, display those numbers in binary and hexadecimal.
#
#---------------------------------------------------------------------------------------------------------------------


.data
	ask_str: .asciiz "\nEnter a number PLEASE: "
	result_str1: .asciiz "\nBinary equivalent: "
	result_str2: .asciiz "\nHexadecimal equivalent: "
	result2: .space 8
.text

main:
	# ask and store the number
	li 	$v0, 4
	la 	$a0, ask_str
	syscall
	li 	$v0, 5
	syscall
	move 	$t0, $v0		# $t0 = input number decimal
	
	beqz	$t0, end_main		# if input = 0 then exit program

	jal 	print_bin
	jal 	print_hexa
	
	li 	$v0, 11			# New Line
	li 	$a0, 10
	syscall
	
	j 	main		
end_main:
	li	$v0, 10			# exit
	syscall

# ================== Pseudo Code ================= #
# # Convert decimal number to binary number
# input = enter from keyboard
# count = 32
# mark = 1000 0000 0000 0000 0000 0000 0000 0000
# while(count != 0)
#	temp = AND input, mark
#	if (temp != 0)
#		temp = 1
#	print(temp)
#	srl mark, 1
#	count--
# =============================================== #
print_bin:
	li 	$v0, 4
	la 	$a0, result_str1	# call result_str1
	syscall
	
	add 	$t1, $zero, $zero 	# $t1 = 0
	addi 	$t2, $zero, 1 		# load 1 as a mask
	sll 	$t2, $t2, 31 		# move the mask to appropriate position
	addi 	$t3, $zero, 32 		# loop counter
loop1:
	and 	$t1, $t0, $t2		# and the input with the mask
	beq 	$t1, $zero, print1	# Branch to print if $t1 = 0
	addi 	$t1, $zero, 1 		# else $t1 != 0 -> assign $t1 = 1
print1: 
	li 	$v0, 1
	move 	$a0, $t1
	syscall				# print result
	
	srl 	$t2, $t2, 1
	addi 	$t3, $t3, -1
	bne 	$t3, $zero, loop1
	
	jr 	$ra			# return to main

# ================== Pseudo Code ================= #
# # Convert decimal number to hexadecimal number
# input = enter from keyboard
# count = 8
# mark = 0x0000000f
# while(count != 0)
#	input = rol input, 4	Ex: 0x0000000a -> 0x000000a0
#	temp = AND input, mark
#	if (temp <= 9)
#		temp += 48 (stage number of ASCII table)
#	else
#		temp += 55 (stage uppercase alphabet of ASCII table)
#	storage temp (hex digit) into result
#	count--
# print(result)
# =============================================== #
print_hexa:
	la 	$a0, result_str2 	# call result_str
	li 	$v0, 4 
	syscall
	li 	$t3, 8 			# counter
	la 	$t2, result2		# where answer will be stored
loop2:
	beqz 	$t3, exit 		# branch to exit if counter is equal to zero 
	rol 	$t0, $t0, 4 		# rotate 4 bits to the left
	and 	$t1, $t0, 0xf		# mask with 1111 
	ble 	$t1, 9, sum 		# if less than or equal to nine, branch to sum 
	addi 	$t1, $t1, 55 		# if greater than nine, add 55
	j 	end
sum: 
	addi 	$t1, $t1, 48 		# add 48 to result -> if $t2 = 1 then $t2 assign "1" in ASCII
end: 
	sb 	$t1, 0($t2) 		# store hex digit into result 
	addi 	$t2, $t2, 1 		# increment address counter 
	addi 	$t3, $t3, -1 		# decrement loop counter
	j 	loop2 
exit: 	
	la 	$a0, result2 
	li 	$v0, 4 
	syscall 
	jr 	$ra
