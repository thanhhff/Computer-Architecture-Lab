.data
	students: .space 5200 # Array to store blocks (52) of 100 student
	input_name: .asciiz "Nhap ten sinh vien"
	input_mark: .asciiz "Nhap diem sinh vien"
	input_count: .asciiz "Nhap so luong sinh vien"
	st_list: .asciiz "Danh sach sinh vien "
	mark_and_name: .asciiz "\nDiem\tHo va Ten\n"
	sorted_list: .asciiz "\nDanh sach da sap xep:\n"
	so_sinh_vien: .word
	ten: .float 10.0
	zero: .float 0.0
.text
__read_info_student:
	la $s1, students # Nap dia chi cua mang $s1
	move $t1, $s1 # Gán dia chi cua mang vao $t1
	la $s4, ten
	la $s5, zero

count:
	li $v0, 51 # Goi hop thoai nhap so luong sinh viên
	la $a0, input_count # $a0 tiêu de: "Nhap so luong sinh vien"
	syscall #
	
	move $s0, $a0 # So vua nhap vao $a0, gán cho $s0
	move $s7, $a0 # So vua nhap vao $a0, gán cho $s7
	# sw $s0, so_sinh_vien
	move $s6, $a0
	
	li $v0, 4 #
	la $a0, st_list # In ra chuoi "Danh sach sinh vien "
	syscall # trên giao dien console
	
	la $a0, mark_and_name # in ra chuoi "Diem Ho va Ten"
	syscall

	li $t0, 0 # khoi tao $t0 = 0, $t0 là bien dem cua sinh viên vua duoc nhap thong tin
loop:
	slt $v0, $t0, $s0 # So sánh $t0 (So sinh vien nhap thông tin) và $s0 (Tong so sinh viên)
	beqz $v0, end_loop # Thoát vong lap khi nhap du thông tin cho các sinh viên
name: 
	li $v0, 54 # Goi hop thoai nhap ten sinh viên
	la $a0, input_name # Tieu de "Nhap ten sinh vien"
	la $a1, 4($t1) # Chi ra vi trí luu tên
	li $a2, 46 # Gioi han do dài tên 46 ki tu
	syscall 

mark: 

do:	li $v0, 52 # Goi hop thoai nhap ðiem (Kieu float)
	la $a0, input_mark # Tiêu de "Nhap diem sinh vien"
	syscall 
	
	l.s $f1,($s4)	
	c.le.s $f0, $f1		# f2 < f1
	li $a0, 1		# 
	movt $a0, $zero
	bne $a0, $zero, condi	# Neu a0 != 0 --> incre
	
	l.s $f1,($s5)
	c.le.s $f1, $f0		# f2 < f1
	li $a0, 1		# 
	movt $a0, $zero
	beq $a0, $zero, exit_do	# Neu a0 != 0 --> incre
condi:	
	j do	

exit_do:
	s.s $f0, ($t1) # Luu diem vào mang
	li $v0, 2 #
	mov.s $f12, $f0 # In diem ra màn hinh console
	syscall #
	li $v0, 11 #
	li $a0, '\t' # In dau tab
	syscall #
	li $v0, 4 #
	la $a0, 4($t1) # In tên sinh viên ra màn hinh console
	syscall #
	addi $t0, $t0, 1 
	addi $t1, $t1, 52 # block tiep theo
	j loop # Lap lai vong lap
end_loop:

#################################
# Bat dau sap xep #
#################################
__bubble_sort:
	la $s0, students #load dia chi mang a vào $s0
	la $s3, students #load dia chi mang a vào $s3
	addi $t2, $t0, 0 #i = n
loop1: # for i = n-1 to 0
	addi $t2, $t2, -1 # i = i - 1
	add $s0, $s3, $zero #luu diaa chi mang a
	li $t3, 0 #gán j = 0
	beq $t2, 0, break_1 # so sánh i voi 0 neu bang nhau thì re nhánh xuong nhãn break
loop2: #for j = 0 to i - 1
	beq $t2, $t3, loop1 # if j == i then loop1
	l.s $f1, 0($s0) # Load a[j] luu vào $s1
	addi $s0, $s0, 52 #tang dia chi lên 52
	l.s $f2, 0($s0) # Load a[j+1]
	#slt $a0, $s2, $s1 # if a[j+1] < a[j] then
	c.lt.s $f2, $f1
	li $a0, 1
	movt $a0, $zero
	bne $a0, $zero, incre
	jal swap
incre: 
	addi $t3, $t3, 1 # j = j + 1
	j loop2 #nhay vao loop2

break_1:

	j __show_student
swap:
	li $s7, 0
	addi $t4, $s0, -52
loopx:
	slti $v0, $s7, 13
	beqz $v0, end_loopx
	lw $a1, 0($t4)
	lw $a2, 52($t4)
	sw $a1, 52($t4)
	sw $a2, 0($t4)
	addi $t4, $t4, 4
	addi $s7, $s7, 1
	j loopx
end_loopx:
	jr $ra

__show_student:
	add $s0, $s7, $zero
	la $t1, students # Nap ðia chi ð?u m?ng các block lýu thông tin sinh viên
	li $v0, 4 # Go i hàm in string
	la $a0, sorted_list #
	syscall #
	la $a0, mark_and_name # in ra chuoi "Diem Ho va Ten"
	syscall
	li $t0, 0 # Khoi tao $t0 = 0, $t0 là bien ðiem so sinh viên da duoc duyet
loop3:
	slt $v0, $t0, $s6 # So sánh $t0 (So sv da duyet) và $s0 (Tong so sinh viên)
	beqz $v0, exit # Thoát vong lap khi duyet het sinh viên
	li $v0, 2 #

	l.s $f12, 0($t1) # In ðiem ra màn hinh console
	syscall #
	li $v0, 11 #
	li $a0, '\t' # In dau tab
	syscall #
	li $v0, 4 #
	la $a0, 4($t1) # In tên sinh viên ra màn hinh console
	syscall #
continue:
	addi $t0, $t0, 1 # Tãng bien ðem so luong sv da duyet
	addi $t1, $t1, 52
	j loop3 # Lap lai vong lap
exit:
	li $v0, 10
	syscall

