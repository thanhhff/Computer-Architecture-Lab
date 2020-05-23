#----------------------------------------------------------
# Team 4: Nguyen Trung Thanh - Hoang Thi Thu Trang
# Project 7: sortByHeight
#
# Task: Some people are standing in a row in a park. There are trees between them which cannot be moved. 
#	Your task is to rearrange the people by their heights in a non- descending order without moving the trees. 
#	People can be very tall!
# Example: For a = [-1, 150, 190, 170, -1, -1, 160, 180]
#	   the output should be sortByHeight(a) = [-1, 150, 160, 170, -1, -1, 180, 190].
#-----------------------------------------------------------


#-----------------------------------------------------------
# @input: array (mang chua cac gia tri dau vao)
# @note: cac gia tri -1 bieu thi tree
# Mang height: chi chua cac chieu cao lay tu mang array
# @idea: Input array 
# 	1. @find_height: Lay cac gia tri la chieu cao cua nguoi => height
#	2. @sort_height: Sap xep mang height theo thu tu tang dan 
#	3. @change: Thay the nhung gia tri da duoc sap xep trong mang height vao mang array
#-----------------------------------------------------------

.data
	
	# Input array 
	# array: .word -1, 150, 190, 170, -1, -1, 160, 180
	array: .space 4000	# Gioi han do dai cua mang la 1000 phan tu
	
	# Luu cac gia tri height cua nguoi ra mot mang moi
	height: .space 4000 
	message_input: .asciiz "Nhap gia tri dau vao cho mang (-1: bieu thi cho tree) !\n"
	message_input_length: .asciiz "Ban chua nhap bat ky gia tri nao, vui long nhap lai!"
	message_input_1: .asciiz "Nhap gia tri (-1: cay, cancel: ket thuc nhap)"
	message_input_2: .asciiz "Nhap sai gia tri dau vao. Vui long nhap lai!"
	message_input_3: .asciiz "Ket qua sau khi nhap la:\n"
	tab: .asciiz "  "
	message_result: .asciiz "\nKet qua sau khi sap xep la:\n"
	
	
.text
main:
	la 	$s1, array		# Lay dia chi cua array cho vao $s1
	la 	$s2, height 		# Lay dia chi height cho vao $s2
	addi 	$s3, $zero, -1		# -1: bieu thi Tree trong array input
	
	addi 	$s4, $zero, 0		# n: So luong phan tu cua array
	addi 	$s5, $zero, 0		# m: So luong phan tu cua height


### Input array
	li	$v0, 4
	la	$a0, message_input
	syscall
	
	jal	input
	nop
	
### Show input array
	li 	$v0, 4 
	la	$a0, message_input_3
	syscall
	
	jal	show_array
	nop

### Find height
	jal	find_height
	nop
	
### Sort height
	jal 	sort_height
	nop

### Change
	jal 	change
	nop

### Show result
	li 	$v0, 4 
	la	$a0, message_result
	syscall
	
	jal	show_array
	nop

### END
	li $v0, 10
	syscall
end_main:

#-----------------------------------------------------------
# 0. @input: Nhap cac gia tri tu ban phim
# Chu y: ki hieu -1 la tree
# Nhap -2 de ket thuc
#-----------------------------------------------------------

	
input:
	li $v0, 51
	la $a0, message_input_1
	syscall
	
	beq $a0, -1, input_ok		# Neu ma la -1: tree, oke
	beq $a1, 0, input_ok		# Neu la int => oke
	beq $a1, -2, end_input		# Neu an cacel => ket thuc nhap
	
input_fail:
	li $v0, 55
	la $a0, message_input_2
	syscall
	j	input
	
	
input_ok:
	beq 	$a0, 0, input_fail	# Yeu cau height phai > 0
	slt	$t0, $a0, $s3		# Neu height < -1 fail (Chi -1: bieu thi cho tree oke)
	beq	$t0, 1, input_fail
	
	sll  	$t1, $s4, 2		# $t1 = 4*i
	add  	$t1, $t1, $s1		# Vi tri cua input[i]
	sw	$a0, 0($t1)
	addi 	$s4, $s4, 1		# i = i + 1
	j   	input

end_input:
	beqz	$s4, input_length_fail
	jr	$ra

input_length_fail:
	li 	$v0, 55
	la 	$a0, message_input_length
	syscall
	j	input
	
	
#-----------------------------------------------------------
# 1. @find_height: Lay cac gia tri la chieu cao cua nguoi => height
# @input: array (mang chua gia tri dau vao)
# @output: mang height chua gia tri chieu cao cua nguoi
#-----------------------------------------------------------

find_height:

	# Khoi tao cac bien i, j bang 0
	addi 	$t0, $zero, 0		# i = 0
	addi 	$t2, $zero, 0		# j = 0

fh_loop:
	sll  	$t1, $t0, 2		# $t1 = 4*i
	add  	$t1, $t1, $s1		# Vi tri cua input[i]
	lw   	$s6, 0($t1)		# Lay gia tri cua input[i]
	
	beq  	$s6, $s3, fh_continue	# Neu gia tri input[i] == -1 => continue (bo qua tree)
	
	sll  	$t3, $t2, 2		# $t3 = 4*j
	add  	$t3, $t3, $s2		# Vi tri cua height[j]
	sw   	$s6, 0($t3)		# Luu gia tri vao vi tri height[j]
	addi 	$t2, $t2, 1		# j = j + 1
	addi 	$s5, $s5, 1		# m = m + 1 (so luong phan tu trong height tang len 1)
	
fh_continue:
	addi 	$t0, $t0, 1		# i = i + 1
	slt  	$t4, $t0, $s4		# if i < n => True: return 1; False: return 0
	bne  	$t4, $zero, fh_loop 

fh_end_loop:
	# j after_find_height
	jr	$ra
			
#### Sap xep cac phan tu trong mang height
### BubbleSort

#-----------------------------------------------------------
# 2. @sort_height: Sap xep mang height theo thu tu tang dan 
# @case_study: Sap xep bang phuong phap `BubbleSort`
# @input: height (chua gia tri chieu cao cua nguoi) - chua duoc sap xep
# @output: height (chua gia tri chieu cao cua nguoi) - da sap xep theo thu tu tang dan
#-----------------------------------------------------------

sort_height:

	# Khoi tao index i cua loop_1 bang 0 
	addi 	$t0, $zero, 0		# i = 0
	
loop_1:
	# Khoi tao index j cua loop_2 bang 0 
	addi  	$t1, $zero, 0		# j = 0
	
	addi 	$t0, $t0, 1		# i = i + 1
	sub 	$t2, $s5, $t0		# m - i - 1
	
	# Kiem tra dieu kien: i < m - 1
	slt 	$t6, $t0, $s5  
	beq 	$t6, $zero, end_loop_1
	
loop_2:
	# Kiem tra dieu kien j < m - i - 1
	slt 	$t5, $t1, $t2		#  j < m - i - 1: True return 1; else return 0 
	beq 	$t5, $zero, end_loop_2

	sll 	$t3, $t1, 2 		# $t3 = 4*j
	add 	$t3, $t3, $s2		# Vi tri cua A[j]
	lw  	$s6, 0($t3)		# Lay gia tri cua A[j]
	lw  	$s7, 4($t3)		# Lay gia tri cua A[j+1]
	
if:
	slt	 $t4, $s6, $s7 		# Kiem tra A[j] < A[j+1] => True: return 1; False: return 0
	bne 	$t4, $zero, end_if
	
	# Neu A[j] > A[j + 1] => Thuc hien Swap 2 phan tu nay	
   	sw 	$s7, 0($t3) 
    	sw 	$s6, 4($t3) 

end_if:
	addi 	$t1, $t1, 1		# j = j + 1
	j   	loop_2
	
end_loop_2:
	j   	loop_1
	
end_loop_1:
	jr	$ra


#-----------------------------------------------------------
# 3. @change: Thay the nhung gia tri da duoc sap xep trong mang height vao mang array
# @input: array (mang chua gia tri dau vao)
# @output: array (mang chua gia tri duoc sap xep theo chieu cao cua nguoi)
# @note: Reset cac gia tri cua height = 0 
#-----------------------------------------------------------

change:
	# Khoi tao bien i, j bang 0
	addi 	$t0, $zero, 0		# i = 0
	addi 	$t2, $zero, 0		# j = 0
	
i_loop:
	sll  	$t1, $t0, 2		# $t1 = 4*i
	add  	$t1, $t1, $s1		# Vi tri cua array[i]
	lw   	$s6, 0($t1)		# Lay gia tri cua array[i]
	
	beq  	$s6, $s3, i_continue	# Neu gia tri array[i] == -1 => continue
	
	sll  	$t3, $t2, 2		# $t3 = 4*j
	add  	$t3, $t3, $s2		# Vi tri cua height[j]
	lw   	$s6, 0($t3)		# Lay gia tri cua height[j]
	sw 	$s6, 0($t1)		# array[i] = height[j]
	
	addi 	$s7, $zero, 0
	sw 	$s7, 0($t3)		# Reset gia tri cua height[j] = 0
	addi 	$t2, $t2, 1		# j = j + 1

i_continue:
	addi 	$t0, $t0, 1		# i = i + 1
	slt  	$t4, $t0, $s4		# if i < n: True return: 1; False return: 0
	bne  	$t4, $zero, i_loop 

i_end_loop:
	jr	$ra



#-----------------------------------------------------------
# @show_array: Hien thi array
#-----------------------------------------------------------
show_array:
	addi 	$t0, $zero, 0		# i = 0
	
show_array_loop:
	sll  	$t1, $t0, 2		# $t1 = 4*i
	add  	$t1, $t1, $s1		# Vi tri cua input[i]
	lw   	$s6, 0($t1)		# Lay gia tri cua input[i]
	
	li	$v0, 4			# in dau cach de de nhin
	la	$a0, tab
	syscall
	li 	$v0, 1			# in gia tri
	addi	$a0, $s6, 0
	syscall
	
	
	addi 	$t0, $t0, 1		# i = i + 1
	slt  	$t4, $t0, $s4		# if i < n => True: return 1; False: return 0
	bne  	$t4, $zero, show_array_loop

end_show_array:
	jr	$ra

#-----------------------------------------------------------
# END
#-----------------------------------------------------------
