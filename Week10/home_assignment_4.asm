.eqv KEY_CODE 0xFFFF0004 	# ASCII code from keyboard, 1 byte
.eqv KEY_READY 0xFFFF0000 	# =1 if has a new keycode ?
 				# Auto clear after lw
.eqv DISPLAY_CODE 0xFFFF000C 	# ASCII code to show, 1 byte
.eqv DISPLAY_READY 0xFFFF0008 	# =1 if the display has already to do
 				# Auto clear after sw
.text
 	li $k0, KEY_CODE
 	li $k1, KEY_READY

 	li $s0, DISPLAY_CODE
 	li $s1, DISPLAY_READY
 	
loop: 
	nop

WaitForKey:
 	lw $t1, 0($k1) 		# $t1 = [$k1] = KEY_READY
 	beq $t1, $zero, WaitForKey 	# if $t1 == 0 then Polling

ReadKey: 
 	lw $t0, 0($k0) 		# $t0 = [$k0] = KEY_CODE
 	
WaitForDis: 
 	lw $t2, 0($s1) 		# $t2 = [$s1] = DISPLAY_READY
 	beq $t2, $zero, WaitForDis 	# if $t2 == 0 then Polling

ShowKey:
 	sw $t0, 0($s0) 		# show key
 	nop
 
CheckExit:
	beq $t0, 101, to_state_1
	beq $t0, 120, to_state_2
	beq $t0, 105, to_state_3
 	beq $t0, 116, finish
 	
to_state_0:			# state 0: wait e
 	add $t3, $zero, $zero
 	j continue
to_state_1:			# state 1: wait x
 	bne $t3, 0, to_state_0		
 	add $t3, $t3, 1
 	j continue
to_state_2:			# state 2: wait i
 	bne $t3, 1, to_state_0
 	add $t3, $t3, 1
 	j continue
to_state_3:			# state 0: wait t
 	bne $t3, 2, to_state_0		
 	add $t3, $t3, 1
 	j continue
finish:
 	bne $t3, 3, to_state_0	
 	j exit
 
continue:
 	j loop
 
exit:
 	li $v0, 10
 	syscall
 	
 	
 	
 	