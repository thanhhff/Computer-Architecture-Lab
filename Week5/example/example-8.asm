.data
Message: .asciiz "Nhap ho ten:"
string: .space 100 
.text 
	li $v0, 54
	la $a0, Message
	la $a1, string
	la $a2, 100
	syscall