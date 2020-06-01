
# Assignment 2 - Week 10

.eqv	MONITOR_SCREEN 	0x10010000
.eqv 	RED		0x00FF0000
.eqv 	GREEN		0x0000FF00
.eqv 	BLUE		0x000000FF
.eqv 	WHITE		0x00FFFFFF
.eqv 	YELLOW		0x00FFFF00

.text
	li	$k0, MONITOR_SCREEN
	
	li	$t0, YELLOW
	sw	$t0, 72($k0)
	
	li	$t0, YELLOW
	sw	$t0, 76($k0)
	
	li	$t0, YELLOW
	sw	$t0, 80($k0)
	
	li	$t0, YELLOW
	sw	$t0, 84($k0)
	
	li	$t0, BLUE
	sw	$t0, 104($k0)
	
	li	$t0, BLUE
	sw	$t0, 136($k0)
	
	li	$t0, GREEN
	sw	$t0, 116($k0)
	
	li	$t0, GREEN
	sw	$t0, 148($k0)
	
	li	$t0, RED
	sw	$t0, 168($k0)
	
	li	$t0, RED
	sw	$t0, 172($k0)
	
	li	$t0, RED
	sw	$t0, 176($k0)
	
	li	$t0, RED
	sw	$t0, 180($k0)
	
	
	