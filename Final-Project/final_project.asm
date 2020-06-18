#----------------------------------------------------------
# Author: Nguyen Trung Thanh - 20176874
# Project 7: Chuong trinh kiem tra cu phap lenh Mips 
#-----------------------------------------------------------

.data
	menu_mess:       .asciiz " MENU\n 1. Kiem tra cu phap lenh\n 2. Thoat \n Chon: "
	menu_error_mess: .asciiz "Nhap sai, vui long nhap lai!\n"
	input_mess:      .asciiz "Nhap vao lenh Mips"
	
	command:  .space 100	# Luu cau lenh
	mnemonic: .space 20	# Luu ma lenh, vi du: add, and,...
	number:   .space 30	# imm | shamt
	ident:    .space 30	# nhan
	token:    .space 30	# cac thanh ghi, vi du: $zero, $at,...
	
	# Cau truc cua library:
	# mnemonic (5 byte) - so luong operation - chu ky lenh
	# Trong so luong operation: 1 - thanh ghi; 2 - hang so nguyen; 3 - dinh danh (ident); 0 - khong co 
	library: .asciiz "or***1111;xor**1111;lui**1201;jr***1001;jal**3002;addi*1121;add**1111;sub**1111;ori**1121;and**1111;beq**1132;bne**1132;j****3002;nop**0001;"
	charGroup: .asciiz "qwertyuiopasdfghjklmnbvcxzQWERTYUIOPASDFGHJKLZXCVBNM_"
	# Moi thanh ghi cach nhau 6 byte
	tokenRegisters: .asciiz "$zero $at   $v0   $v1   $a0   $a1   $a2   $a3   $t0   $t1   $t2   $t3   $t4   $t5   $t6   $t7   $s0   $s1   $s2   $s3   $s4   $s5   $s6   $s7   $t8   $t9   $k0   $k1   $gp   $sp   $fp   $ra   $0    $1    $2    $3    $4    $5    $7    $8    $9    $10   $11   $12   $13   $14   $15   $16   $17   $18   $19   $20   $21   $22   $21   $22   $23   $24   $25   $26   $27   $28   $29   $30   $31   "

.text

main:
# >>>>>>>>>> MENU <<<<<<<<<< 
m_menu_start:
	li $v0, 51
	la $a0, menu_mess
	syscall
	
	beq $a0, 1, m_menu_end
	
	# Bang 2 hoac -2 => Ket thuc chuong trinh
	beq $a0, 2, end_main
	beq $a1, -2, end_main
	
	# Truong hop khac 1,2 se yeu cau nhap lai
	li $v0, 55
	la $a0, menu_error_mess
	syscall
	j  m_menu_start
	
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
	li $v0, 54
	la $a0, input_mess
	la $a1, command
	la $a2, 100
	syscall
	jr $ra

#-----------------------------------------------------------
# 2. @check: Kiem tra cau lenh
# - Buoc 1: Kiem tra mnemonic (add, and, or,...) ten lenh
#-----------------------------------------------------------
check:
	# Luu $ra de tro ve main
	addi $sp, $s0, -4
	sw   $ra, 0($sp)
	
	addi $s7, $zero, 0	# Thanh ghi $s7 luu index cua command
	
	jal check_mnemonic
	nop
	
	# Tra lai $ra de tro ve main
	lw   $ra, 0($sp)
	addi $sp, $sp, 4
	jr   $ra

#-----------------------------------------------------------
# 2.1 @check_opcode: Kiem tra cau lenh
# - Kiem tra mnemonic (add, and, or,...) ten lenh
#-----------------------------------------------------------
check_mnemonic:

	add $t0, $s7, $zero	# i = index command
	li  $s6, 0		# so luong cac ki tu cua mnemonic = 0
	la  $a0, command	# Dia chi cua command
	la  $a1, mnemonic	# Dia chi cua mnemonics
	
read_mnemonic:
	
	add $t1, $a0, $t0	# Dich bit cua command
	add $t2, $a1, $t0	# Dich bit cua mnemonic
	
	lb  $t3, 0($t1)
	
	beq $t3, 32, read_mnemonic_done # Neu co dau cach ' ' ket thuc read mnemonic
	beq $t3, 0, read_mnemonic_done	# Ket thuc chuoi
	
	sb  $t3, 0($t2)
	
	addi $t0, $t0, 1
	j read_mnemonic
	
read_mnemonic_done:	
	
	# $s6: So luong ki tu cua mnemonic
	addi $s6, $t0, -1	
	
check_mnemonic_inlib:

	
	
end_check_mnemonic_inlib:

	addi $s7, $t0, 0
	jr $ra 


	








