#----------------------------------------------------------
# Team 4: Nguyen Trung Thanh - Hoang Thi Thu Trang
# Project 8: students
#
#- Input the number of students in class.        
#- Input the name of students in class, mark.        
#- Sort students due to their mark. 
#-----------------------------------------------------------


#-----------------------------------------------------------
#@idea:
# - Nhap so luong sinh vien.
# - Nhap ma so sinh vien.
# - Nhap ten sinh vien.
# - Nhap diem sinh vien voi dieu kien 0 <= diem <= 10.
# - Sap xep nhan vien theo diem dung thuat toan bubble sort.
#-----------------------------------------------------------

.data
	students: .space 5200 			# Array to store blocks (52) of 100 student
	input_count: .asciiz "Nhap so luong sinh vien"
	error_count: .asciiz "So sinh vien phai la so tu nhien nho hon hoac bang 100"
	input_mssv: .asciiz "Nhap ma so sinh vien"
	error_mssv: .asciiz "20170000<= MSSV < 20180000\nMSSV khong trung nhau."
	trung: .asciiz "MSSV nay da ton tai"
	input_name: .asciiz "Nhap ten sinh vien"
	error_in: .asciiz "Ten ban da nhap qua dai hoac khong nhap gi! Toi da 47 ki tu"
	input_mark: .asciiz "Nhap diem sinh vien"
	note: .asciiz "Diem duoc nhap phai thoa man: 0 <= diem <=10"
	error: .asciiz "Gia tri nhap vao khong dung kieu!"
	st_list: .asciiz "Danh sach sinh vien"
	mark_and_name: .asciiz "\nMSSV\t\tDiem\tHo va Ten\n"
	sorted_list: .asciiz "\nDanh sach da sap xep:\n"
	so_sinh_vien: .word
	ten: .float 10.0
	zero: .float 0.0
	number: .space 4

.text
#Doc thong tin sinh vien
main:
	la 	$s1, students 			# Nap dia chi cua mang $s1
	move 	$t1, $s1 			# Gan dia chi cua mang vao $t1
	la 	$s4, ten			#$s4 = 10.0
	la 	$s5, zero			#$s5 = 0.0
	li	$t2, 101			#$t2 = 101
	li 	$t4, 20170001			# Cho t4 = 20170001
	li 	$t5, 20180000			# Cho t5 = 20180000
	jal 	__count				# Ham nhap so luong SV
	nop
	la 	$s2, number			# s2 la dia chi bien number
	lw 	$s0, 0($s2)			# Doc gia tri number cho vao s0
	move 	$s6, $s0			# s6, s7 = SSV
	move 	$s7, $s0
	jal 	__input_info			# Goi ham de nhap thong tin sinh vien
	nop
	
	li 	$v0, 4 				# In string 
	la 	$a0, st_list			# In "Danh sach sinh vien" 
	syscall
	jal 	__show_student			# Goi ham show student
	nop
	
	jal 	__bubble_sort			# Sap xep student theo diem tang dan 
	nop
	
	li 	$v0, 4 				# In string 
	la 	$a0, sorted_list		# In "Danh sach sinh vien da sap xep" 
	syscall
	
	jal 	__show_student			# In lai danh sach sau khi sap xep 
	nop
	li 	$v0, 10				# Exit chuong trinh
	syscall
#nhap so sinh vien
__count:
do_count:
	li 	$v0, 51 			# Goi hop thoai nhap so luong sinh vien
	la 	$a0, input_count 		# $a0 tieu de: "Nhap so luong sinh vien"
	syscall 				# $a0 so sinh vien
	
	bnez 	$a1, error_input

	slt 	$t0, $a0, $zero			# neu gia tri nhap vao < 0 => return 1
	bne 	$t0, $zero, error_input
	
	slt 	$v0, $a0, $t2			# Neu a0 (so sinh vien) < t2 ( = 100 ) --> v0 = 1
	beqz 	$v0, nhap_lai			# Neu v0 == 0 --> Nhap lai
	
	la 	$s7, number			# doc dia chi cua number
	sw 	$a0, 0($s7)			# ghi SSV vao number	
	jr 	$ra  				# Thoat khoi ham nhap so SV
	
nhap_lai:
	li 	$v0, 55				# Goi hop thoai Thong bao 
	la 	$a0, error_count			
	li 	$a1, 0				# Hop thoai Error
	syscall
	j 	do_count			# Quay lai ham Nhap so SV 
error_input:
	la 	$v0, 55
	la 	$a0, error
	syscall 
	j 	do_count

__input_info:
	li 	$t0, 0 				# khoi tao $t0 = 0, $t0 là bien dem (i) cua sinh vien vua duoc nhap thong tin
	addi 	$sp, $sp, -4			# Tao vung nho
	sw 	$ra, 0($sp)			# luu dia chi thanh ghi $ra
loop:
	slt 	$v0, $t0, $s0 			# So sanh $t0 (So sinh vien nhap thong tin) < $s0 (Tong so sinh vien)-> v0 = 1 
	beqz 	$v0, end_loop 			# Thoat vong lap khi nhap du thong tin cho cac sinh vien

# Nhap mssv	
mssv_loop:
	li 	$v0, 51 			# Goi hop thoai nhap diem (Kieu Int)
	la 	$a0, input_mssv 		# Tieu de "Nhap MSSV"
	syscall 				# Tra ve gia tri vua nhap vao a0
	
	bnez 	$a1, re_input_mssv	
	
	slt 	$v0, $a0, $t4			# Neu a0 (so sinh vien) < t4 ( = 20170001 ) --> v0 = 1
	bnez 	$v0, re_input_mssv		# v0 != 0 --> Nhap lai
	
	slt 	$v0, $a0, $t5			# Neu a0 (so sinh vien) < t5 ( = 20180000 ) --> v0 = 1
	beqz 	$v0, re_input_mssv		# Neu v0 == 0 --> Nhap lai
	
	jal 	check_mssv
	nop	
	bnez 	$t9, re_mssv			# Neu t9 != 0 --> Nhap lai
	
	j 	name

re_input_mssv:
	li 	$v0, 55				# Goi hop thoai Thong bao 
	la 	$a0, error_mssv			# Goi xau bao loi
	li 	$a1, 0				# Hop thoai Error
	syscall
	j 	mssv_loop			# Quay lai ham Nhap so SV 
re_mssv:
	li 	$v0, 55				# Goi hop thoai Thong bao 
	la 	$a0, trung			# Goi xau : "MSSV nay da ton tai"
	li 	$a1, 0				# Hop thoai Error
	syscall
	j 	mssv_loop			# Quay lai ham Nhap so SV 

# Kiem tra MSSV co bi trung khong
check_mssv:
	addi 	$sp, $sp, -12			# Tao vung nho cho $t1, $t2
	sw 	$ra, 8($sp)			# Luu gia tri thanh ghi $ra
	sw 	$t2, 4($sp)			# Luu gia tri $t2 vao $sp
	sw 	$t1, 0($sp)			# Luu gia tri $t1 vao sp
	li 	$t1, 0				# Cho $t1 = 0
	la 	$t2, students			# Gan dia chi mang
	li 	$t9, 0				# Thanh ghi kiem tra
	
loop_mssv:
	slt 	$v0, $t1, $t0 			# Neu t1 ( bien dem ) < t0 ( so SV da nhap ) --> v0 = 1
	beqz 	$v0, end_check 			# v0 == 0 --> Thoat vong lap 
	lw 	$t8, 0($t2)			# Doc mssv SV thu t1
	beq 	$t8, $a0, mssv_trung		# Neu t8 == a0 ( MSSV trung nhau ) thi thoat 
	
	addi 	$t1, $t1, 1			# Tang bien dem 
	addi 	$t2, $t2, 52			# Tang vung nho
	j 	loop_mssv
mssv_trung:
	li 	$t9, 1				# t9 = 1 MSSV bi trung	
end_check:	
	lw 	$t1, 0($sp)
	lw 	$t2, 4($sp)
	lw 	$ra, 8($sp)			# Tra lai gia tri cho cac thanh ghi $t1, $t2, $ra
	addi 	$sp, $sp, 12
	jr 	$ra
#Nhap ten sinh vien
name: 
	sw 	$a0,0($t1)			# Luu mssv
do_name:
	li 	$v0, 54 			# Goi hop thoai nhap ten sinh vien
	la 	$a0, input_name 		# Tieu de "Nhap ten sinh vien"
	la 	$a1, 8($t1) 			# Chi ra vi trí luu ten
	li 	$a2, 44 			# Gioi han do dai ten 43 ki tu
	syscall 
	
	bnez 	$a1, re_input 			# Neu a1 != 0 --> Nhap ten qua dai ( a1 = 0 la trang thai dung ) --> Nhap lai name 
	j 	mark				# Chay den ham nhap diem 

# Nhap lai ten 	
re_input:
	li 	$v0, 55				# Goi hop thoai thong bao String
	la 	$a0, error_in			# Goi string loi 
	li 	$a1, 0				# Goi hop thoai error 
	syscall
	j 	do_name				# Quay lai Nhap name
#Nhap diem
mark: 
do:	li 	$v0, 52 			# Goi hop thoai nhap diem (Kieu float)
	la 	$a0, input_mark 		# Tieu de "Nhap diem sinh vien"
	syscall 
		
	bnez  	$a1, err_input
	
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
err_input:
	la 	$v0, 55
	la 	$a0, error
	syscall 
	j 	do
condi:		
	la 	$v0, 55
	la 	$a0, note
	syscall 
	j 	do	
#Thoat nhap diem
exit_do:
	s.s 	$f0, 4($t1) 			# Luu diem vào mang
	addi 	$t0, $t0, 1 			#Tang bien dem len 1
	addi 	$t1, $t1, 52 			# Chuyen sang vung nho tiep theo, moi vung nho 52 bit
	j 	loop 				# Lap lai vong lap
end_loop:
	lw 	$ra, 0($sp)			# Lay gia tri thanh ghi $ra
	addi 	$sp, $sp, 4
	jr 	$ra
#################################
# Bat dau sap xep #
#################################
#-----------------------------------------------------------
#@case_study: Sap xep bang phuong phap bubble sort
#@input: danh sach sinh vien - chua duoc sap xep theo diem
#@output: danh sach sinh vien - da duoc sap xep theo thu tu tang dan cua diem so
#-----------------------------------------------------------
__bubble_sort:
	addi 	$sp, $sp, -4			# Tao 1 o nho
	sw 	$ra, 0($sp)			# cat gia tri thanh ghi ra
	la 	$s3, students 			# Doc dia chi cua mang student vao s3		
	addi 	$t2, $t0, 0 			# So sinh vien la t2 la bien dem 
loop1: # for i = n-1 to 0 ( loop 1 )
	addi 	$t2, $t2, -1 			# i = i - 1 ( t2 la bien diem tu phai sai  i)
	add 	$s0, $s3, $zero 		# Cho dia chi cua mang s0 = s3
	li 	$t3, 0 				# gán j = 0 ( t3 la bien dem 2 tu trai sang j)
	beq 	$t2, 0, break_1 		# Neu t2 (i) == 0 --> Exit loop 1 
loop2: #for j = 0 to i - 1 ( loop 2 )
	beq 	$t2, $t3, loop1 		# Neu j == i -->  loop1
	l.s 	$f1, 4($s0) 			# Load diem students[j] = f1
	addi 	$s0, $s0, 52 			# Tang dia chi len 52 --> Chuyen sang student khac  --> s0 = a[j+1] = f2
	l.s 	$f2, 4($s0) 			# Load diem students[j+1] = f2
	c.lt.s 	$f2, $f1			# Neu f1 < f2
	li 	$a0, 1
	movt 	$a0, $zero 
	bne 	$a0, $zero, incre 		# --> incre 			
	jal 	swap				# Neu f2 < f1 --> swap 
	nop
incre: 
	addi 	$t3, $t3, 1 			# j = j + 1
	j 	loop2 				# Quay ve Loop 2 

break_1:
	lw 	$ra, 0($sp)			# Lay gia tri thanh ghi ra
	addi 	$sp, $sp, 4			# Tra vung nho cho stack		
	jr 	$ra				# Show Students
#a[j-1] vs a[j]	
swap:
	addi 	$sp, $sp, -4			# Tao 1 vung nho trong tron stack
	sw 	$ra, 0($sp) 			# Cat gia tri thanh ghi $ra
	li 	$s7, 0				# s7 = 0
	addi 	$t4, $s0, -52			# t4 = students[j] --> f1 --> Vung nho dau tien 
loopx:
	slti 	$v0, $s7, 13			# s7 < 13 --> v0 = 1
	beqz 	$v0, end_loopx			# v0 == 0 --> s7 >= 13 --> Thoat vong lap . 1 phan tu cos 52 byte moi o 4 byte --> 13 byte 
	lw 	$a1, 0($t4)			# Load gia tri cua f1 ( a[j] ) vao a1 4 byte sau
	lw 	$a2, 52($t4)			# Load gia tri cua f2 ( a[j+1] ) vao a2 4 byte lien ke 
	sw 	$a1, 52($t4)			# Ghi gia tri cua a1 vao a[j+1] 4 byte
	sw 	$a2, 0($t4)			# Ghi gia tri cua a2 vao a[j] 4 byte
	addi 	$t4, $t4, 4			# Tang vung nho cua students[j] len 4 
	addi 	$s7, $s7, 1			# Tang bien dem len 1
	j loopx					# Chay lai loopx
end_loopx:
	lw	$ra, 0($sp)			# Lay gia tri thanh ghi $ra da cat
	addi 	$sp, $sp, 4			# Tra lai vung nho stack
	jr 	$ra				# Quay ve incre 
#in ra danh sach sinh vien da duoc sap xep
__show_student:
	add 	$s0, $s7, $zero			#so sinh vien = 0
	la 	$t1, students 			# Nap dia chi dau mang cac block luu thong tin sinh vien
	
	la 	$a0, mark_and_name 		# in ra chuoi "Diem Ho va Ten"
	syscall
	li 	$t0, 0 				# Khoi tao $t0 = 0, $t0 là bien diem so sinh vien da duoc duyet
loop3:
	slt 	$v0, $t0, $s6 			# So sanh $t0 (So sv da duyet) và $s0 (Tong so sinh vien)
	beqz 	$v0, exit_show 			# Thoat vong lap khi duyet het sinh vien
	
	li 	$v0, 1				# Hien thi console
	lw 	$a0, 0($t1) 			# In mssv ra màn hinh console
	syscall 			
	
	li 	$v0, 11 			# In char 
	li 	$a0, '\t' 			# In dau tab
	syscall
	 
	li 	$v0, 2 				
	l.s 	$f12, 4($t1) 			# In diem ra man hinh console
	syscall 
	
	li 	$v0, 11 			#in char
	li 	$a0, '\t' 			# In dau tab
	syscall 
	
	li 	$v0, 4 				#in string
	la 	$a0, 8($t1) 			# In ten sinh vien ra man hinh console
	syscall 

	addi 	$t0, $t0, 1 			# Tang bien dem so luong sv da duyet
	addi 	$t1, $t1, 52			#tang dia chi t1 len 52
	j 	loop3 				# Lap lai vong lap
exit_show:
	jr $ra
#-----------------------------------------------------------
# END
#-----------------------------------------------------------
