#----------------------------------------------------------
# Team 4: Nguyen Trung Thanh - Hoang Thi Thu Trang
# Project 8: Students
#
#- Input the number of students in class.        
#- Input the name of students in class, mark.        
#- Sort students due to their mark. 
#-----------------------------------------------------------


#-----------------------------------------------------------
#@idea:
# - Nhap so luong sinh vien.
# - Nhap ten sinh vien.
# - Nhap diem sinh vien voi dieu kien 0 <= diem <= 10.
# - Sap xep nhan vien theo diem dung thuat toan bubble sort.
#-----------------------------------------------------------

.data
	students: .space 5200 			# Array to store blocks (52) of 100 student
	input_name: .asciiz "Nhap ten sinh vien"
	input_mark: .asciiz "Nhap diem sinh vien"
	note: .asciiz "Diem duoc nhap phai thoa man: 0 <= diem <=10"
	input_count: .asciiz "Nhap so luong sinh vien"
	error_count: .asciiz "So sinh vien phai la so tu nhien nho hon 100"
	error: .asciiz "Gia tri nhap vao khong dung kieu!"
	st_list: .asciiz "Danh sach sinh vien"
	mark_and_name: .asciiz "\nDiem\tHo va Ten\n"
	sorted_list: .asciiz "\nDanh sach da sap xep:\n"
	so_sinh_vien: .word
	ten: .float 10.0
	zero: .float 0.0

.text


#Doc thong tin sinh vien

__read_info_student:
	la 	$s1, students 			# Nap dia chi cua mang $s1
	move 	$t1, $s1 			# Gan dia chi cua mang vao $t1
	la 	$s4, ten			# $s4 = 10.0
	la 	$s5, zero			# $s5 = 0.0
	li	$t2,100				# $t2 = 100

count:
	li 	$v0, 51 			# Goi hop thoai nhap so luong sinh vien
	la 	$a0, input_count 		# $a0 tieu de: "Nhap so luong sinh vien"
	syscall 				# $a0 so sinh vien
	
	
	addi $t0, $zero, -1
	beq $t0, $a1, error_input
	slt $t0, $a0, $zero			# neu gia tri nhap vao < 0 => return 1
	bne $t0, $zero, error_input
	
	slt $v0, $a0, $t2			# Neu a0 (so sinh vien) < t2 ( = 100 ) --> v0 = 1
	beqz $v0, nhap_lai			# Neu v0 == 0 --> Nhap lai
	
	j	end_error_input
	
nhap_lai:
	li $v0, 55				# Goi hop thoai Thong bao 
	la $a0, error_count			
	li $a1, 0				# Hop thoai Error
	syscall
	j count					# Quay lai ham Nhap so SV 
error_input:
	la $v0, 55
	la $a0, error
	syscall 
	j 	count
	
#Thoat khoi ham nhap so sinh vien
end_error_input:	
	move 	$s0, $a0 			# ao = so sinh vien
	move 	$s7, $a0 			# s0,s6,s7 = so sinh vien
	move 	$s6, $a0			
	
	li 	$v0, 4 
	la 	$a0, st_list 			# In ra chuoi "Danh sach sinh vien "
	syscall 				# tren giao dien console
	
	la 	$a0, mark_and_name 		# in ra chuoi "Diem Ho va Ten"
	syscall

	li 	$t0, 0 				# khoi tao $t0 = 0, $t0 la bien dem (i) cua sinh vien vua duoc nhap thong tin

### Vong lap nhap thong tin sinh vien
loop:
	slt 	$v0, $t0, $s0 			# So sanh $t0 (So sinh vien nhap thong tin) < $s0 (Tong so sinh vien)-> v0 = 1 
	beqz 	$v0, end_loop 			# Thoat vong lap khi nhap du thong tin cho cac sinh vien

### Nhap ten sinh vien
name: 
	li 	$v0, 54 			# Goi hop thoai nhap ten sinh vien
	la 	$a0, input_name 		# Tieu de "Nhap ten sinh vien"
	la 	$a1, 4($t1) 			# Chi ra vi tri luu ten
	li 	$a2, 46 			# Gioi han do dai ten 46 ki tu
	syscall 
	bnez 	$a1, re_input 			# Neu a1 != 0 --> Nhap ten qua dai ( a1 = 0 la trang thai dung ) --> Nhap lai name 
	j mark					# Chay den ham nhap diem 

### Nhap lai ten 	
re_input:
	li $v0, 55				# Goi hop thoai thong bao String
	la $a0, error_input			# Goi string loi 
	li $a1, 0				# Goi hop thoai error 
	syscall
	j name					# Quay lai Nhap name
mark: 

do:	li 	$v0, 52 			# Goi hop thoai nhap diem (Kieu float)
	la 	$a0, input_mark 		# Tieu de "Nhap diem sinh vien"
	syscall 
	
	l.s 	$f1,($s4)			# Doc gia tri cua s4 (= 10.0) vao thanh ghi f1
	c.le.s 	$f0, $f1			# f0 <= f1
	li 	$a0, 1		 
	movt	$a0, $zero
	bne 	$a0, $zero, condi		# Neu a0 != 0 --> incre
	
	l.s 	$f1,($s5)
	c.le.s 	$f1, $f0			# f1 <= f0
	li 	$a0, 1		 
	movt 	$a0, $zero
	beq 	$a0, $zero, exit_do		# Neu a0 != 0 --> incre
condi:	
	
	la $v0, 55
	la $a0, note
	syscall 
	j 	do	

exit_do:
	s.s 	$f0, ($t1) 			# Luu diem vao mang
	li 	$v0, 2 				#Goi ham in ra man hinh kieu float
	mov.s 	$f12, $f0 			# In diem ra man hinh console
	syscall 
	li 	$v0, 11 			#in ky tu	
	li 	$a0, '\t' 			# In dau tab
	syscall 
	li 	$v0, 4 				#in string
	la 	$a0, 4($t1) 			# In ten sinh vien ra man hinh console
	syscall 
	addi 	$t0, $t0, 1 			#Tang bien dem len 1
	addi 	$t1, $t1, 52 			# Chuyen sang vung nho tiep theo, moi vung nho 52 bit
	j 	loop 				# Lap lai vong lap
end_loop:

#-----------------------------------------------------------
# Bat dau sap xep #
#-----------------------------------------------------------
#-----------------------------------------------------------
#@case_study: Sap xep bang phuong phap bubble sort
#@input: danh sach sinh vien - chua duoc sap xep theo diem
#@output: danh sach sinh vien - da duoc sap xep theo thu tu tang dan cua diem so
#-----------------------------------------------------------
__bubble_sort:
	la 	$s3, students 			#load dia chi mang a vao $s3
	addi 	$t2, $t0, 0 			#i = n
loop1: # for i = n-1 to 0
	addi 	$t2, $t2, -1 			# i = i - 1
	add 	$s0, $s3, $zero 		#Cho dia chi cua mang s0 = s3
	li 	$t3, 0 				#gan j = 0
	beq 	$t2, 0, break_1 		# so sanh i voi 0 neu bang nhau thi re nhanh xuong nhan break
loop2: #for j = 0 to i - 1
	beq 	$t2, $t3, loop1 		# if j == i then loop1
	l.s 	$f1, 0($s0) 			# Load a[j] luu vao $f1
	addi 	$s0, $s0, 52 			# tang dia chi len 52 --> Chuyen sang student khac  --> s0 = a[j+1] = f2
	l.s 	$f2, 0($s0) 			# Load a[j+1] = f2
	c.lt.s 	$f2, $f1			# Neu f1 < f2
	li 	$a0, 1
	movt 	$a0, $zero			
	bne 	$a0, $zero, incre		# Neu f2 >= f1 --> incre  
	jal 	swap				# Neu f2 < f1 --> swap 
incre: 
	addi 	$t3, $t3, 1 			# j = j + 1
	j 	loop2 				# nhay vao loop2

break_1:

	j 	__show_student			#Show student
	
### a[j-1] vs a[j]
swap:
	li 	$s7, 0
	addi 	$t4, $s0, -52			# t4 = students[j-1] --> f1 --> Vung nho dau tien
loopx:
	slti 	$v0, $s7, 13			# s7 < 13 -->v0 = 1
	beqz 	$v0, end_loopx			# v0 = 0 -> s7 >= 13 -> Thoat vong lap
	lw 	$a1, 0($t4)			# Load gia tri cua f1 ( a[j-1] ) vao a1
	lw 	$a2, 52($t4)			# Load gia tri cua f2 ( a[j] ) vao a2
	sw 	$a1, 52($t4)			# Ghi gia tri cua a1 vao a[j]
	sw 	$a2, 0($t4)			# Ghi gia tri cua a2 vao a[j-1]
	addi 	$t4, $t4, 4			# Tang vung nho cua students[j-1]
	addi 	$s7, $s7, 1			# Tang bien dem len 1
	j 	loopx
end_loopx:
	jr 	$ra				# quay ve incre
	
### In ra danh sach sinh vien da duoc sap xep
__show_student:
	add 	$s0, $s7, $zero			# so sinh vien = 0
	la 	$t1, students 			# Nap dia chi �au mang cac block luu thong tin sinh vien
	li 	$v0, 4 				# Goi ham in string
	la 	$a0, sorted_list 
	syscall 
	la 	$a0, mark_and_name 		# in ra chuoi "Diem Ho va Ten"
	syscall
	li 	$t0, 0 				# Khoi tao $t0 = 0, $t0 la bien diem so sinh vien da duoc duyet
loop3:
	slt 	$v0, $t0, $s6 			# So sanh $t0 (So sv da duyet) va $s0 (Tong so sinh vien)
	beqz 	$v0, exit 			# Thoat vong lap khi duyet het sinh vien
	
	li 	$v0, 2 				
	l.s 	$f12, 0($t1) 			# In diem ra man hinh console
	syscall 
	li 	$v0, 11 			# in char
	li 	$a0, '\t' 			# In dau tab
	syscall 
	li 	$v0, 4 				# in string
	la 	$a0, 4($t1) 			# In ten sinh vien ra man hinh console
	syscall 
continue:
	addi 	$t0, $t0, 1 			# Tang bien dem so luong sv da duyet
	addi 	$t1, $t1, 52			# tang dia chi t1 len 52
	j 	loop3 				# Lap lai vong lap
exit:
	li 	$v0, 10				# Thoat chuong trinh
	syscall
	
#-----------------------------------------------------------
# END
#-----------------------------------------------------------
