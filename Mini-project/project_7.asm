# Team 4: Nguyen Trung Thanh - Hoang Thi Thu Trang
# Project 7: sortByHeight

##################################
# Some people are standing in a row in a park. There are trees between them which cannot be moved. 
# Your task is to rearrange the people by their heights in a non- descending order without moving the trees. 
# People can be very tall!
# Example: For a = [-1, 150, 190, 170, -1, -1, 160, 180]
#          the output should be sortByHeight(a) = [-1, 150, 160, 170, -1, -1, 180, 190].
##################################

.data
	# Dau vao, chu y dieu chinh so phan tu n trong $s1
	array: .word -1, 150, 190, 170, -1, -1, 160, 180
	## array: .word 1, -1, -1, -1, -1
	## array: .word 2, -1, 1, -1, -1
	## array: .word 2, -1, 1, -1, 1
	
	# Luu cac gia tri height cua nguoi ra mot mang moi
	height: .word 
	
	
.text
main:
	la $a0, array		# Lay dia chi cua array cho vao $a0
	la $a1, height 		# Lay dia chi height cho vao $a1
	addi $s0, $zero, -1	# Tree trong array input
	addi $s1, $zero, 8	# n: So phan tu cua Input
	addi $s2, $zero, 0	# m: So phan tu trong mang height
	
	j find_height
	
after_find_height:
	j sort_height

after_sort:
	j insert

after_insert:
	li $v0, 10
	syscall
end_main:
	
	
#### Tu input dau vao chi lay ra vi tri cua tree
find_height:

	# Khoi tao cac bien i, j bang 0
	addi $t0, $zero, 0	# i = 0
	addi $t2, $zero, 0	# j = 0

fh_loop:
	sll  $t1, $t0, 2	# $t1 = 4*i
	add  $t1, $t1, $a0	# vi tri input[i]
	lw   $s3, 0($t1)	# gia tri cua input[i]
	
	beq  $s3, $s0, fh_continue	# Neu gia tri input[i] == -1 => continue
	
	sll  $t3, $t2, 2	# $t3 = 4*j
	add  $t3, $t3, $a1
	sw   $s3, 0($t3)
	addi $t2, $t2, 1	# j = j + 1
	addi $s2, $s2, 1	# m = m + 1
	
fh_continue:
	addi $t0, $t0, 1	# i = i + 1
	slt  $t4, $t0, $s1	# if i < n => return: 1; else return: 0
	bne  $t4, $zero, fh_loop 

fh_end_loop:
	j after_find_height

#### Sap xep cac phan tu trong mang height
### BubbleSort

sort_height:
	# Khoi tao index i cua vong lap thu nhat = 0 
	addi $t0, $zero, 0	# i = 0
	
	# Neu mang chi co 1 phan tu => Khong thuc hien sort
	# addi $t7, $zero, 1
	# beq $s2, $t7, after_sort
	
loop_1:
	# Index cua vong lap thu 2 bang 0
	addi  $t1, $zero, 0	# index j cua vong lap thu 2
	
	addi $t0, $t0, 1	# i = i + 1
	
	sub $t2, $s2, $t0	# m - i - 1
	# Check dieu kien: i < n - 1
	slt $t6, $t0, $s2  
	beq $t6, $zero, end_loop_1
loop_2:
	# Check dieu kien j < n - i - 1
	slt $t5, $t1, $t2	# neu t1 < t2 return 1; else return 0 ( j < n-i-1)
	beq $t5, $zero, end_loop_2

	sll $t3, $t1, 2 	# $t3 = 4*j
	add $t3, $t3, $a1
	lw  $s3, 0($t3)		# load A[j]
	lw  $s4, 4($t3)		# Load A[j+1]
	
if:
	slt $t4, $s3, $s4 	# If A[j] < A[j+1]
	bne $t4, $zero, end_if
	# Swap
   	sw $s4, 0($t3) 
    	sw $s3, 4($t3) 

end_if:
	addi $t1, $t1, 1	# j = j + 1
	
	j   loop_2
end_loop_2:
	
	
	j   loop_1
end_loop_1:
	j after_sort

######
##### Chen mang da sap xep vao mang output

insert:
	
	# Khoi tao bien i, j bang 0
	addi $t0, $zero, 0	# i = 0
	addi $t2, $zero, 0	# j = 0
	
i_loop:
	sll  $t1, $t0, 2	# $t1 = 4*i
	add  $t1, $t1, $a0	# vi tri input[i]
	lw   $s3, 0($t1)	# gia tri cua input[i]
	
	beq  $s3, $s0, i_continue	# Neu gia tri input[i] == -1 => continue
	
	sll  $t3, $t2, 2	# $t3 = 4*j
	add  $t3, $t3, $a1
	lw   $s3, 0($t3)
	sw $s3, 0($t1)
	
	addi $s4, $zero, 0
	sw $s4, 0($t3)		# xoa bo gia tri cua mang height
	addi $t2, $t2, 1	# j = j + 1

i_continue:
	
	addi $t0, $t0, 1	# i = i + 1
	slt  $t4, $t0, $s1	# if i < n => return: 1; else return: 0
	bne  $t4, $zero, i_loop 

i_end_loop:
	j after_insert

