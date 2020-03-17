.text
	li 	$s0, 0x0563 #load test value for these function
	andi 	$t0, $s0, 0xff #Extract the LSB of $s0
	andi 	$t1, $s0, 0x0400 #Extract bit 10 of $s0
	
	# extract MSB
	srl	$t2, $s0, 12
	andi	$t3, $t2, 0xff
	
	# clear LSB
	andi	$t4, $s0, 0xffffff00
	
	# set LSB
	ori	$t5, $s0, 0xff
	
	xor	$s0, $s0, $s0