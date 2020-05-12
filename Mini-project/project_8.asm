#----------------------------------------------------------
# Team 4: Nguyen Trung Thanh - Hoang Thi Thu Trang
# Project ?8: students
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
	note: .asciiz "diem duoc nhap phai thoa man dieu kien: 0 <= diem <=10"
	input_count: .asciiz "Nhap so luong sinh vien"
	error: .asciiz "Gia tri nhap vao khong dung kieu!"
	st_list: .asciiz "Danh sach sinh vien"
	mark_and_name: .asciiz "\nDiem\tHo va Ten\n"
	sorted_list: .asciiz "\nDanh sach da sap xep:\n"
	so_sinh_vien: .word
	ten: .float 10.0
	zero: .float 0.0
#-----------------------------------------------------------
#__read_info_student: nao dia chi cua mang.
#count: nhap so luong sinh vien.
#loop: vong lap de nhap thong tin sinh vien.
#name: nhap ten sinh vien voi gioi han la 46 ki tu.
#mark: nhap diem sinh vien voi dieu kien: 0 <= diem <=10.
#-----------------------------------------------------------
.text
__read_info_student:
	la 	$s1, students 			# Nap dia chi cua mang $s1
	move 	$t1, $s1 			# Gan dia chi cua mang vao $t1
	la 	$s4, ten
	la 	$s5, zero

count:
	li 	$v0, 51 			# Goi hop thoai nhap so luong sinh vien
	la 	$a0, input_count 		# $a0 tieu de: "Nhap so luong sinh vien"
	syscall 
	
	addi $t0, $zero, -1
	beq $t0, $a1, error_input
	slt $t0, $a0, $zero			# neu gia tri nhap vao < 0 => return 1
	bne $t0, $zero, error_input
	
	j	end_error_input
error_input:
	la $v0, 55
	la $a0, error
	syscall 
	j 	count
end_error_input:	
	move 	$s0, $a0 			# So vua nhap vao $a0, gan cho $s0
	move 	$s7, $a0 			# So vua nhap vao $a0, gan cho $s7
	# sw $s0, so_sinh_vien
	move 	$s6, $a0			# So vua nhap vao $a0, gan cho $s6
	
	li 	$v0, 4 
	la 	$a0, st_list 			# In ra chuoi "Danh sach sinh vien "
	syscall 				# tren giao dien console
	
	la 	$a0, mark_and_name 		# in ra chuoi "Diem Ho va Ten"
	syscall

	li 	$t0, 0 				# khoi tao $t0 = 0, $t0 là bien dem cua sinh vien vua duoc nhap thong tin
loop:
	slt 	$v0, $t0, $s0 			# So sanh $t0 (So sinh vien nhap thong tin) và $s0 (Tong so sinh vien)
	beqz 	$v0, end_loop 			# Thoat vong lap khi nhap du thong tin cho cac sinh vien
name: 
	li 	$v0, 54 			# Goi hop thoai nhap ten sinh vien
	la 	$a0, input_name 		# Tieu de "Nhap ten sinh vien"
	la 	$a1, 4($t1) 			# Chi ra vi trí luu ten
	li 	$a2, 46 			# Gioi han do dai ten 46 ki tu
	syscall 

mark: 

do:	li 	$v0, 52 			# Goi hop thoai nhap diem (Kieu float)
	la 	$a0, input_mark 		# Tieu de "Nhap diem sinh vien"
	syscall 
	
	l.s 	$f1,($s4)	
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
	s.s 	$f0, ($t1) 			# Luu diem vào mang
	li 	$v0, 2 
	mov.s 	$f12, $f0 			# In diem ra màn hinh console
	syscall 
	li 	$v0, 11 
	li 	$a0, '\t' 			# In dau tab
	syscall 
	li 	$v0, 4 
	la 	$a0, 4($t1) 			# In ten sinh vien ra man hinh console
	syscall 
	addi 	$t0, $t0, 1 
	addi 	$t1, $t1, 52 			# block tiep theo
	j 	loop 				# Lap lai vong lap
end_loop:

#################################
# Bat dau sap xep #
#################################
#-----------------------------------------------------------
#@case_study: Sap xep bang phuong phap bubble sort
#@input: danh sach sinh vien - chua duoc sap xep theo diem
#@output: danh sach sinh vien - da duoc sap xep theo thu tu tang dan cua diem so
#-----------------------------------------------------------
__bubble_sort:
	la 	$s0, students 			#load dia chi mang a vào $s0
	la 	$s3, students 			#load dia chi mang a vào $s3
	addi 	$t2, $t0, 0 			#i = n
loop1: # for i = n-1 to 0
	addi 	$t2, $t2, -1 			# i = i - 1
	add 	$s0, $s3, $zero 		#luu dia chi mang a
	li 	$t3, 0 				#gan j = 0
	beq 	$t2, 0, break_1 		# so sanh i voi 0 neu bang nhau thi re nhanh xuong nhan break
loop2: #for j = 0 to i - 1
	beq 	$t2, $t3, loop1 		# if j == i then loop1
	l.s 	$f1, 0($s0) 			# Load a[j] luu vào $s1
	addi 	$s0, $s0, 52 			# tang dia chi len 52
	l.s 	$f2, 0($s0) 			# Load a[j+1]
	#slt $a0, $s2, $s1 # if a[j+1] < a[j] then
	c.lt.s 	$f2, $f1
	li 	$a0, 1
	movt 	$a0, $zero
	bne 	$a0, $zero, incre
	jal 	swap
incre: 
	addi 	$t3, $t3, 1 			# j = j + 1
	j 	loop2 				#nhay vao loop2

break_1:

	j 	__show_student
swap:
	li 	$s7, 0
	addi 	$t4, $s0, -52
loopx:
	slti 	$v0, $s7, 13
	beqz 	$v0, end_loopx
	lw 	$a1, 0($t4)
	lw 	$a2, 52($t4)
	sw 	$a1, 52($t4)
	sw 	$a2, 0($t4)
	addi 	$t4, $t4, 4
	addi 	$s7, $s7, 1
	j 	loopx
end_loopx:
	jr 	$ra
#in ra danh sach sinh vien da duoc sap xep
__show_student:
	add 	$s0, $s7, $zero
	la 	$t1, students 			# Nap dia chi ðau mang cac block luu thong tin sinh vien
	li 	$v0, 4 				# Goi ham in string
	la 	$a0, sorted_list 
	syscall 
	la 	$a0, mark_and_name 		# in ra chuoi "Diem Ho va Ten"
	syscall
	li 	$t0, 0 				# Khoi tao $t0 = 0, $t0 là bien diem so sinh vien da duoc duyet
loop3:
	slt 	$v0, $t0, $s6 			# So sanh $t0 (So sv da duyet) và $s0 (Tong so sinh vien)
	beqz 	$v0, exit 			# Thoat vong lap khi duyet het sinh vien
	li 	$v0, 2 

	l.s 	$f12, 0($t1) 			# In diem ra man hinh console
	syscall 
	li 	$v0, 11 
	li 	$a0, '\t' 			# In dau tab
	syscall 
	li 	$v0, 4 
	la 	$a0, 4($t1) 			# In ten sinh vien ra man hinh console
	syscall 
continue:
	addi 	$t0, $t0, 1 			# Tang bien dem so luong sv da duyet
	addi 	$t1, $t1, 52
	j 	loop3 				# Lap lai vong lap
exit:
	li 	$v0, 10
	syscall
#-----------------------------------------------------------
# END
#-----------------------------------------------------------
