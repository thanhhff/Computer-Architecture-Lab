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
	# @note: Chu y so luong phan tu n cua mang trong $s1
	
	array: .word -1, 150, 190, 170, -1, -1, 160, 180
	## array: .word 1, -1, -1, -1, -1
	## array: .word 2, -1, 1, -1, -1
	## array: .word 2, -1, 1, -1, 1
	
	# Luu cac gia tri height cua nguoi ra mot mang moi
	height: .word 
	
	
.text
main:
	la 	$a0, array		# Lay dia chi cua array cho vao $a0
	la 	$a1, height 		# Lay dia chi height cho vao $a1
	addi 	$s0, $zero, -1		# -1: bieu thi Tree trong array input
	addi 	$s1, $zero, 8		# n: So luong phan tu cua array
	addi 	$s2, $zero, 0		# m: So luong phan tu cua height
	
	j find_height
	
after_find_height:
	j sort_height

after_sort:
	j change

after_change:
	li $v0, 10
	syscall
end_main:
	
	
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
	add  	$t1, $t1, $a0		# Vi tri cua input[i]
	lw   	$s3, 0($t1)		# Lay gia tri cua input[i]
	
	beq  	$s3, $s0, fh_continue	# Neu gia tri input[i] == -1 => continue (bo qua tree)
	
	sll  	$t3, $t2, 2		# $t3 = 4*j
	add  	$t3, $t3, $a1		# Vi tri cua height[j]
	sw   	$s3, 0($t3)		# Luu gia tri vao vi tri height[j]
	addi 	$t2, $t2, 1		# j = j + 1
	addi 	$s2, $s2, 1		# m = m + 1 (so luong phan tu trong height tang len 1)
	
fh_continue:
	addi 	$t0, $t0, 1		# i = i + 1
	slt  	$t4, $t0, $s1		# if i < n => True: return 1; False: return 0
	bne  	$t4, $zero, fh_loop 

fh_end_loop:
	j after_find_height

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
	sub 	$t2, $s2, $t0		# m - i - 1
	
	# Kiem tra dieu kien: i < m - 1
	slt 	$t6, $t0, $s2  
	beq 	$t6, $zero, end_loop_1
	
loop_2:
	# Kiem tra dieu kien j < m - i - 1
	slt 	$t5, $t1, $t2		#  j < m - i - 1: True return 1; else return 0 
	beq 	$t5, $zero, end_loop_2

	sll 	$t3, $t1, 2 		# $t3 = 4*j
	add 	$t3, $t3, $a1		# Vi tri cua A[j]
	lw  	$s3, 0($t3)		# Lay gia tri cua A[j]
	lw  	$s4, 4($t3)		# Lay gia tri cua A[j+1]
	
if:
	slt	 $t4, $s3, $s4 		# Kiem tra A[j] < A[j+1] => True: return 1; False: return 0
	bne 	$t4, $zero, end_if
	
	# Neu A[j] > A[j + 1] => Thuc hien Swap 2 phan tu nay	
   	sw 	$s4, 0($t3) 
    	sw 	$s3, 4($t3) 

end_if:
	addi 	$t1, $t1, 1		# j = j + 1
	j   	loop_2
	
end_loop_2:
	j   	loop_1
	
end_loop_1:
	j 	after_sort


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
	add  	$t1, $t1, $a0		# Vi tri cua array[i]
	lw   	$s3, 0($t1)		# Lay gia tri cua array[i]
	
	beq  	$s3, $s0, i_continue	# Neu gia tri array[i] == -1 => continue
	
	sll  	$t3, $t2, 2		# $t3 = 4*j
	add  	$t3, $t3, $a1		# Vi tri cua height[j]
	lw   	$s3, 0($t3)		# Lay gia tri cua height[j]
	sw 	$s3, 0($t1)		# array[i] = height[j]
	
	addi 	$s4, $zero, 0
	sw 	$s4, 0($t3)		# Reset gia tri cua height[j] = 0
	addi 	$t2, $t2, 1		# j = j + 1

i_continue:
	addi 	$t0, $t0, 1		# i = i + 1
	slt  	$t4, $t0, $s1		# if i < n: True return: 1; False return: 0
	bne  	$t4, $zero, i_loop 

i_end_loop:
	j 	after_change

#-----------------------------------------------------------
# END
#-----------------------------------------------------------
