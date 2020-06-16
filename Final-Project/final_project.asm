#----------------------------------------------------------
# Author: Nguyen Trung Thanh - 20176874
# Project 7: Chuong trinh kiem tra cu phap lenh Mips 
#-----------------------------------------------------------

.data
	menu_mess: .asciiz " >>>>>>>>>> MENU <<<<<<<<<<\n 1. Kiem tra cu phap lenh\n 2. Thoat \n Chon: "
	menu_error_mess: .asciiz "Nhap sai, vui long nhap lai!\n"
	input_mess: .asciiz "Nhap vao lenh Mips"
	input_buffer: .space 100
	
	tokenRegisters: .asciiz 

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
# >>>>>>>>>> END MENU <<<<<<<<<< 

# >>>>>>>>>> READ INPUT <<<<<<<<<< 
m_input:
	jal  input
	nop
	

end_main:
	li $v0, 10
	syscall
	
#-----------------------------------------------------------
# 1. @input: Nhap vao lenh Mips tu ban phim
#-----------------------------------------------------------
input:
	li $v0, 54
	la $a0, input_mess
	la $a1, input_buffer
	la $a2, 100
	syscall
	jr $ra










