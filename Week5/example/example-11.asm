.data
Message: .asciiz "Ban la SV CNTT Viet Nhat?"
.text 
	li $v0, 50
	la $a0, Message
	syscall