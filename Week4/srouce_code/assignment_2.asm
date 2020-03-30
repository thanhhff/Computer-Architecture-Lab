# Nguyen Trung Thanh - 20176874

# abs $s0, $s1 # s0 <= | $s1 |
### Phan 4: ble $s1,s2,L
.text 
	li $s1, 0x1
	li $s2, 0x2

	### $s1 <= $s2 
	slt $t1, $s2, $s1  # If: $s2 < $s1 =>  $t1 = 1 else: $t1 = 0
	beq $t1, $zero, L
	j END_IF
L:
	li $s3, 0x3

END_IF:


###########################
	j END 

## Phan 3: Not $s0

.text 
	li $s1, 0xfffffff6
	nor $s0, $s1, $t0


###############################3
	j END
### Phan 2: MOVE $s0, $s1

.text 
	li $s1, 0xfffffff6
	add $s0, $zero, $s1


###############################3
	j END 
### Phan 1: 
.text 
	li $s1, 0xfffffff6 # -10 
	bgtz $s1, POSITIVE # Chuyen di neu $s1 > 0
	xori $t1, $s1, 0xffffffff
	addi $s0, $t1, 0x1
	
	j END # Ket thuc
	
POSITIVE: 
	add $s0, $0, $s1
	
END:

