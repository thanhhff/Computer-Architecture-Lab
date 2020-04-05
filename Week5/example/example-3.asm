.data 
Message: .asciiz "Bo mon \nKy thuat may tinh"
.text
	li $v0, 4
	la $a0, Message
	syscall