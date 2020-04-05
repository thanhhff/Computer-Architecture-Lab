.data
Message: .asciiz "Nhap so nguyen:"

Status: .asciiz "So nguyen vua nhap la:"
.text 
	li $v0, 51
	la $a0, Message
	syscall 