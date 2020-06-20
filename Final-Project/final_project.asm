#----------------------------------------------------------
# Author: Nguyen Trung Thanh - 20176874
# Project 7: Chuong trinh kiem tra cu phap lenh Mips 
#-----------------------------------------------------------

.data
	menu_mess:       .asciiz "\n>>>>>>>>>>MENU<<<<<<<<<<\n1. Kiem tra cu phap lenh\n2. Thoat \nChon: "
	menu_error_mess: .asciiz "\nNhap sai, vui long nhap lai!\n"
	input_mess:      .asciiz "\nNhap vao lenh Mips: "
	
	opcode_mess: 	.asciiz "Opcode: "
	toanHang_mess: 	.asciiz "Toan hang: "
	hopLe_mess: 	.asciiz " - hop le.\n"
	error_mess: 	.asciiz "Lenh hop ngu khong hop le, sai khuon dang lenh !\n"
	completed_mess: .asciiz "\nLenh hop ngu chinh xac !\n"
	chuKy_mess:	.asciiz "So chu ky cua lenh la: "
	
	command:  .space 100	# Luu cau lenh
	opcode:   .space 30	# Luu ma lenh, vi du: add, and,...
	ident:    .space 30	# nhan | hoac number
	token:    .space 30	# cac thanh ghi, vi du: $zero, $at,...
	
	# Cau truc cua library:
	# opcode (5 byte) - so luong operation - chu ky lenh
	# Trong so luong operation: 1 - thanh ghi; 2 - hang so nguyen; 3 - dinh danh (ident); 0 - khong co 
	
	library:	.asciiz "add***1111;sub***1111;addi**1121;addu**1111;addiu*1121;subu**1111;mfc0**1101;mult**1101;multu*1101;div***1101;mfhi**1001;mflo**1001;and***1111;or****1111;andi**1121;ori***1121;sll***1121;srl***1121;lw****1401;sw****1401;lbu***1401;sb****1401;lui***1201;beq***1132;bne***1132;slt***1111;slti**1121;sltiu*1121;j*****3001;jal***3001;jr****1001;nop***0001"
	
	#library: 	.asciiz "or***1111;xor**1111;lui**1201;jr***1001;jal**3002;addi*1121;add**1111;sub**1111;ori**1121;and**1111;beq**1132;bne**1132;j****3002;nop**0001;mult*1101;"
	numberGroup: 	.asciiz "0123456789"
	characterGroup: .asciiz "0123456789qwertyuiopasdfghjklmnbvcxzQWERTYUIOPASDFGHJKLZXCVBNM_"
	# Moi thanh ghi cach nhau 6 byte
	tokenRegisters: .asciiz "$zero $at   $v0   $v1   $a0   $a1   $a2   $a3   $t0   $t1   $t2   $t3   $t4   $t5   $t6   $t7   $s0   $s1   $s2   $s3   $s4   $s5   $s6   $s7   $t8   $t9   $k0   $k1   $gp   $sp   $fp   $ra   $0    $1    $2    $3    $4    $5    $7    $8    $9    $10   $11   $12   $13   $14   $15   $16   $17   $18   $19   $20   $21   $22   $21   $22   $23   $24   $25   $26   $27   $28   $29   $30   $31   "

.text

main:
# >>>>>>>>>> MENU <<<<<<<<<< 
m_menu_start:
	li $v0, 4
	la $a0, menu_mess
	syscall
	
	# Read number input menu
	li $v0, 5
	syscall
	
	beq $v0, 2, end_main	# 2: ket thuc
	beq $v0, 1, m_menu_end	# 1: thuc hien kiem tra
	
	li $v0, 4
	la $a0, menu_error_mess # Nhap sai
	syscall
	
	j m_menu_start
m_menu_end:

# >>>>>>>>>> READ INPUT <<<<<<<<<< 
m_input:
	jal  input
	nop

# >>>>>>>>>> START CHECK <<<<<<<<<< 

m_check:
	jal check
	nop
	
	j m_menu_start
	
end_main:
	li $v0, 10
	syscall
	
#-----------------------------------------------------------
# 1. @input: Nhap vao lenh Mips tu ban phim
#-----------------------------------------------------------
input:
	li $v0, 4
	la $a0, input_mess 
	syscall
	
	li $v0, 8
	la $a0, command
	li $a1, 100
	syscall

	jr $ra

#-----------------------------------------------------------
# 2. @check: Kiem tra cau lenh
# - Buoc 1: Kiem tra opcode (add, and, or,...) ten lenh
# - Buoc 2: Kiem tra Operand thu nhat 
#          
#-----------------------------------------------------------
check:
	# Luu $ra de tro ve main
	addi $sp, $sp, -4
	sw   $ra, 0($sp)
	
	addi $s7, $zero, 0		# Thanh ghi $s7 luu index cua command
	
	# START CHECK OPCODE
	jal check_opcode
	nop
	
	# START CHECK OPERAND 1
	li  $s3, 6			# Vi tri operand trong Library
	jal check_operand
	nop
	
	# START CHECK OPERAND 2		# Neu khong co dau ',' ngan cach giua operand_1 va operand_2 => FALSE
	li  $s3, 7			# Vi tri operand trong Library
	add $t0, $s5, $s3
	lb  $t0, 0($t0)
	beq $t0, 48, check_none		# Kiem tra neu operand = 0 -> ket thuc; ky tu 0 trong ASCII
	
	la   $a0, command
	add  $t0, $a0, $s7 		# tro toi vi tri tiep tuc cua command
	lb   $t1, 0($t0)        
	bne  $t1, 44, not_found		# Dau ','
	add  $s7, $s7, 1
	
	jal check_operand
	nop
	
	# START CHECK OPERAND 3		# Neu khong co dau ',' ngan cach giua operand_1 va operand_2 => FALSE
	li  $s3, 8			# Vi tri operand trong Library
	add $t0, $s5, $s3
	lb  $t0, 0($t0)
	beq $t0, 48, check_none		# Kiem tra neu operand = 0 -> ket thuc; ky tu 0 trong ASCII
	
	la   $a0, command
	add  $t0, $a0, $s7 		# tro toi vi tri tiep tuc cua command
	lb   $t1, 0($t0)        
	bne  $t1, 44, not_found		# Dau ','
	add  $s7, $s7, 1
	
	jal check_operand
	nop
	
	# KIEM TRA KY TU THUA
	j check_none
	
	# Tra lai $ra de tro ve main
	lw   $ra, 0($sp)
	addi $sp, $sp, 4
	jr   $ra

#-----------------------------------------------------------
# 2.1 @check_opcode: Kiem tra cau lenh
# - Buoc 1: Lay cac opcode trong command da nhap 
# - Buoc 2: So sanh voi trong bo tu dien xem co opcode do khong
# 	    - Neu khong co ket thuc va quay lai menu
#	    - Meu co, luu lai dia chi opcode trong library va tiep tuc kiem tra 
#-----------------------------------------------------------
check_opcode:
	
	li $t0, 0					# i = 0
	li  $s6, 0					# so luong cac ki tu cua opcode = 0
	la  $a0, command				# Dia chi cua command
	la  $a1, opcode					# Dia chi cua opcode
	
read_opcode:
	add $t1, $a0, $t0				# Dich bit cua command
	add $t2, $a1, $t0				# Dich bit cua opcode
	
	lb  $t3, 0($t1)
	
	beq $t3, 32, read_opcode_done  			# Neu co dau cach ' ' ket thuc read opcode
	beq $t3, 10, read_opcode_done			# Neu dau '\n' ket thuc read opcode
	beq $t3, 0,  read_opcode_done			# Ket thuc chuoi
	
	sb  $t3, 0($t2)
	
	addi $t0, $t0, 1
	j read_opcode
read_opcode_done:	
	
	addi $s6, $t0, 0				# $s6: So luong ki tu cua opcode
	addi $s7, $t0, 1				# luu index cua command
	
	la $a2, library
	li $t0, -11
	
check_opcode_inlib:
	addi $t0, $t0, 11				# Buoc nhay bang 10 de nhay den tung Instruction
	
	li $t1, 0 					# i = 0
	li $t2, 0					# j = 0
	
	add $t1, $t1, $t0				# Cong buoc nhay
	
	compare_opcode:
		add $t3, $a2, $t1			# t3 tro thanh vi tri tro den dau cua tung Instruction
		lb  $t4, 0($t3)
		beq $t4, 0, not_found
		beq $t4, 42, check_len_opcode		# Neu gap ky tu `*` => Kiem tra do dai 
	
		add $t5, $a1, $t2			# Load opcode
		lb  $t6, 0($t5)
	
		bne $t4, $t6, check_opcode_inlib	# So sanh 2 ki tu, neu khong bang nhau thi tinh den Instruction tiep theo.
		addi $t1, $t1, 1			# i = i + 1
		addi $t2, $t2, 1			# j = j + 1
		j compare_opcode
	
	check_len_opcode:
		bne $t2, $s6, check_opcode_inlib
end_check_opcode_inlib:

	add $s5, $t0, $a2				# Luu lai vi tri Instruction trong Library.
	
	# In thong tin ra man hinh
	li $v0, 4
	la $a0, opcode_mess
	syscall
	li $v0, 4
	la $a0, opcode
	syscall 
	li $v0, 4
	la $a0, hopLe_mess
	syscall
	
	jr $ra 
	
	
#-----------------------------------------------------------
# 2.2 @check_operand: 
# a0: command
# s7: Luu index cua command
# s5: vi tri cua instruction trong library
#-----------------------------------------------------------
	
check_operand:
	# Luu $ra de tro ve check_operand
	addi $sp, $sp, -4
	sw   $ra, 0($sp)

	add $t9, $s5, $s3			# Tro toi operand trong Library
	lb  $t9, 0($t9)
	addi $t9, $t9, -48			# Char -> Number
	
	la  $a0, command
	add $t0, $a0, $s7
	
	li $t1, 0				# i = 0
	space_remove:				# Xoa cac khoang trang thua
		add $t2, $t0, $t1
		lb  $t2, 0($t2)			# Lay ky tu tiep theo
		bne $t2, 32, end_space_remove	# Ky tu ' ' 
		addi $t1, $t1, 1		# i = i + 1	
		j space_remove
	end_space_remove:
	
	add $s7, $s7, $t1			# Cap nhat lai index command
		
	li $t8, 0				# Khong co
	beq $t8, $t9, check_none

	li $t8, 1				# Thanh ghi
	beq $t8, $t9, go_register
	
	li $t8, 2				# So hang nguyen
	beq $t8, $t9, go_number
	
	li $t8, 3				# Ident
	beq $t8, $t9, go_ident
	
end_check_operand:
	# Tra lai $ra de tro ve check_operand
	lw   $ra, 0($sp)
	addi $sp, $sp, 4
	jr   $ra

#-----------------------------------------------------------
#  jal toi cac ham check de kiem tra
#-----------------------------------------------------------
	go_register:				# Check register
		jal check_register
		nop
	j end_check_operand
	
	go_number:				# Check number
		la $a2, numberGroup
		jal check_ident
		nop
	j end_check_operand
	
	go_ident:				# Check Ident
		la $a2, characterGroup
		jal check_ident
		nop
	j end_check_operand
	

#-----------------------------------------------------------
#  @check_none: Kiem tra xem con ky tu nao o cuoi khong
#-----------------------------------------------------------
check_none:
	la $a0, command
	add $t0, $a0, $s7
				
	lb $t1, 0($t0)
			
	beq $t1, 10, none_ok	# Ky tu '\n'
	beq $t1, 0, none_ok	# Ket thuc chuoi
	
	j not_found
		
none_ok:
	li $v0, 4
	la $a0, chuKy_mess
	syscall
	
	li  $s3, 9			# Vi tri operand trong Library
	add $t0, $s5, $s3
	lb  $t0, 0($t0)
	
	li $v0, 11
	add $a0, $t0, $zero
	syscall

	li $v0, 4
	la $a0, completed_mess
	syscall
	j m_menu_start
	
#-----------------------------------------------------------
# @check_register: Kiem tra xem register co hop le hay khong
# a0: command (vi tri luu command)
# a1: token (vi tri luu thanh ghi)
# a2: tokenRegisters
# s7: Luu index cua command
# $t9: index cua token
#-----------------------------------------------------------

check_register:
	la $a0, command
	la $a1, token
	la $a2, tokenRegisters
	add $t0, $a0, $s7				# Tro den vi tri cac instruction
	
	li $t1, 0					# i = 0
	li $t9, 0					# index cua token
	
read_token_register:
	add $t2, $t0, $t1				# command
	add $t3, $a1, $t1				# token
	lb $t4, 0($t2)
		
	beq $t4, 44, end_read_token			# Gap ky tu ' , '
	beq $t4, 10, end_read_token			# Gap ky tu '\n'
	beq $t4, 0, end_read_token			# Ket thuc
		
	addi $t1, $t1, 1
	beq $t4, 32, read_token_register		 # Neu gap dau ' ' thi tiep tuc 
		
	sb $t4, 0($t3)
	addi $t9, $t9, 1
	j read_token_register
		
end_read_token:
	add $s7, $s7, $t1				# Cap nhat lai gia tri index
		
	li $t0, -6
compare_token_register:
	addi $t0, $t0, 6				# Buoc nhay bang 6 de nhay den tung Register
	
	li $t1, 0 					# i = 0
	li $t2, 0					# j = 0
	
	add $t1, $t1, $t0				# Cong buoc nhay
	
	compare_reg:
		add $t3, $a2, $t1			# t3 tro thanh vi tri tro den dau cua tung Register
		lb  $t4, 0($t3)
		beq $t4, 0, not_found
		beq $t4, 32, check_len_reg		# Neu gap ky tu ` ` => Kiem tra do dai 
	
		add $t5, $a1, $t2			# Load token
		lb  $t6, 0($t5)
	
		bne $t4, $t6, compare_token_register	# So sanh 2 ki tu, neu khong bang nhau thi tinh den Register tiep theo.
		addi $t1, $t1, 1			# i = i + 1
		addi $t2, $t2, 1			# j = j + 1
		j compare_reg
	
	check_len_reg:
		bne $t2, $t9, compare_token_register	# Neu do dai khong bang nhau di den register tiep theo
		
end_compare_token_register:

	li $v0, 4
	la $a0, toanHang_mess
	syscall
	li $v0, 4
	la $a0, token
	syscall 
	li $v0, 4
	la $a0, hopLe_mess
	syscall
	
	jr $ra

#-----------------------------------------------------------
# @check_ident: Kiem tra ident (label) HOAC number
# a0: command (vi tri luu command)
# a1: ident (vi tri luu ident)
# a2: characterGroup | numberGroup
# $s7: luu index cua command
# $t9: index cua ident
#-----------------------------------------------------------
check_ident:
	la $a0, command
	la $a1, ident
	
	add $t0, $a0, $s7			# Tro den vi tri cac instruction
	
	li $t1, 0				# i = 0
	li $t9, 0				# index cua ident
	
read_ident:
	add $t2, $t0, $t1			# command
	add $t3, $a1, $t1			# ident
	lb $t4, 0($t2)
		
	beq $t4, 44, end_read_ident		# Gap ky tu ' , '
	beq $t4, 10, end_read_ident		# Gap ky tu '\n'
	beq $t4, 0, end_read_ident		# Ket thuc
		
	addi $t1, $t1, 1
	beq $t4, 32, read_ident	 		# Neu gap dau ' ' thi tiep tuc 
		
	sb $t4, 0($t3)
	addi $t9, $t9, 1
	j read_ident
		
end_read_ident:
	add $s7, $s7, $t1			# Cap nhat lai gia tri index
	beq $t9, 0, not_found			# Khong co label

	li $t2, 0				# index cho Ident
compare_ident:
	beq  $t2, $t9, end_compare_ident	# ket thuc chuoi
	li   $t1, 0				# index cho characterGroup
	
	add  $t3, $a1, $t2		
	lb   $t3, 0($t3)			# Tung char trong Ident
	
	loop_Group:				# Kiem tra tung ky tu Ident co trong Group hay khong
		add $t4, $a2, $t1
		lb $t4, 0($t4)
		beq $t4, 0, not_found		# Khong co -> Khong tim thay
		beq $t4, $t3, end_loop_Group
		
		addi $t1, $t1, 1
		j loop_Group
		
	end_loop_Group:
	
	addi $t2, $t2, 1
	
	j compare_ident

end_compare_ident:

	# In thong tin ra man hinh
	li $v0, 4
	la $a0, toanHang_mess
	syscall
	li $v0, 4
	la $a0, ident
	syscall 
	li $v0, 4
	la $a0, hopLe_mess
	syscall

	jr $ra

#-----------------------------------------------------------
#  @not_found: Khong tim thay khuon dang lenh
#-----------------------------------------------------------
not_found:
	li $v0, 4
	la $a0, error_mess
	syscall
	
	j m_menu_start
	



