# Assignment 1 - Week 10

.eqv	SEVENSEG_LEFT	0xFFFF0010

.eqv	SEVENSEG_RIGHT	0xFFFF0011

.text
main:
	li	$a0, 63
	jal	SHOW_7SEG_LEFT
	li	$a0, 91
	jal	SHOW_7SEG_RIGHT

exit:	
	li 	$v0, 10
	syscall
endmain:

#--------------------------------------------------------------- 
# Function SHOW_7SEG_LEFT : turn on/off the 7seg
# param[in] $a0 value to shown
# remark $t0 changed 
#---------------------------------------------------------------

SHOW_7SEG_LEFT:
	li	$t0, SEVENSEG_LEFT
	sb	$a0, 0($t0)
	jr	$ra

#---------------------------------------------------------------
# Function SHOW_7SEG_RIGHT : turn on/off the 7seg
# param[in] $a0 value to shown
# remark $t0 changed
#---------------------------------------------------------------

SHOW_7SEG_RIGHT:
	li	$t0, SEVENSEG_RIGHT
	sb	$a0, 0($t0)
	jr	$ra
	