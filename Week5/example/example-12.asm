.data
Message: .asciiz "Xin chao"
.text 
	li $v0, 55
	la $a0, Message
	syscall