#Chuong trinh :  "Display list the name of all students who have not passed Math exam"
#--------------------------------------------------------------------------------------


.data
#-------------------------------------------------------------------------
# mark, arrName, pos  lan luot la cac mang de luu tru diem thi, 
# ten sinh vien, vi tri cua ten sinh vien truot mon co trong arrName
#-------------------------------------------------------------------------

	arrName: .space 1000
	MessageName1: .asciiz "Nhap ten : "
	MessageName2: .asciiz "Ten sinh vien : "
	
	mark: .word 0
	MessageNum1: .asciiz "Nhap so diem : "
	MessageNum2: .asciiz "So diem vua nhap : "
	
	pos: .word 0,0,0,0
	
	MessageNummberN: .asciiz "Nhap so sinh vien : "
	
	MessagePrint: .asciiz "Bat dau nhap lieu!"
	MessageList: .asciiz "Danh sach sinh vien truot mon"
	MessageAgain: .asciiz "Nhap lai diem do diem vua nhap sai "
	MessageNumberFailed: .asciiz "So sinh vien truot mon la "
	MessageNoone: .asciiz "Khong co sinh vien nao truot mon!"
	MessageStart: .asciiz "Chao mung ban den voi phan mem kiem tra diem"
	MessageDone: .asciiz "Ket Thuc!"
.text
main:


	la $a0, mark		#load dia chi cua mark vao a0
	la $a1, pos		#load dia chi cua pos vao a1
	la $a2, arrName		#load dia chi cua arrName vao a2
	
	
	add $s0, $a2, $zero	#s0 = a2 = dia chi cua arrName[0]
	add $s1, $a0, $zero	#s1 = a0 = dia chi cua mark[0]
	add $s2, $a1, $zero	#s2 = a1 = dia chi cua pos[0]
	
	add $sp, $sp , -24	#danh stack cho 6 muc
	sw $a0, 8($sp)		# cat dia chi cua a0
	sw $a1, 4($sp)		# cat dia chi cua a1
	sw $a2, 0($sp)		# cat dia chi cua a2
	
	li $v0, 55
	la $a0, MessageStart
	syscall	
	
	
inputfunction:	
	jal input
outputfunction:
	jal output
done:
	add $sp, $sp, 24
	li $v0, 55
	la $a0, MessageDone
	syscall			# Thong bao ket thuc chuong trinh
	
	li $v0, 10
	syscall			# exit
endmain:
#-------------------------------------------------------------------------------------------
#Procedure input: Nhap so luong sinh vien, ten sinh vien, diem tuong ung voi moi sinh vien
#param[in] $s0 mang kieu string 
#param[in] $s1 mang kieu integer 
#param[in] $s3 integer 
#rerurn
#	$s3 so luong sinh vien duoc nhap vao
#	$s1 mang kieu integer chua diem cua cac sinh vien
#	$s0 mang kieu string chua ten cac sinh vien

#-------------------------------------------------------------------------------------------
input:
	
	sw $ra, 12($sp)		# cat dia chi tro ve cua procedure input

inputNumberN:		
	li $v0, 51
	la $a0, MessageNummberN
	syscall			# Nhap N la so sinh vien
	add $s3, $a0, $zero	# s3 = N	
	
	li $v0, 55
	la $a0, MessagePrint
	syscall
	
	add $t0, $zero,$zero		#Khoi tao i = 0  
	add $t1, $zero, $zero		#	  j = 0
loop:	
	add $t2, $s0, $t1		#t2 = dia chi cua arrName[i]

inputName:	
	li $v0, 54
	la $a0, MessageName1
	la $a1, 0($t2)			# Nhap ten sinh vien va luu vao t2=arrName[i]
	syscall	
	
	jal changetonull		

inputMark:
	sll $t3, $t0, 2			#t3 = 4*t0 tuc k = 4*i la chi so cua day mark
	add $t4, $s1, $t3		#t4 = dia chi cua mark[k]

	li $v0, 51
	la $a0, MessageNum1
	syscall				#Nhap diem
	add $t8, $zero, $a0		# t8 = a0 = diem vua nhap
	j checkInputMark		

continueInputMark:	
	sw $t8, 0($t4)			# mark[k] = t8 luu diem vao day mark


test:	
	addi $t0, $t0, 1		# i = i + 1
	addi $t1, $t1, 32		# j = j + 32 , tang them 32 vi cap cho moi phan tu trong mang arrName la 32 bit 
	beq $t0, $s3, change 		# kiem tra i = N khong?	
	j loop

change:
	jal check
doneInput:
	lw $ra, 12($sp)			# load gia tri tra ve cua procedure input vao thanh ghi ra
	jr $ra
#----------------------------------------------------------------------------------------------
#Procedure check : kiem tra diem cua cac sinh vien
#Param[in] $s1 mang kieu integer chua diem cua cac sinh vien
#Param[in] $s2 mang kieu integer
#Param[in] $s3 so sinh vien
#return
#	$s2 mang chua vi tri cua sinh vien co so diem nho hon 5 ( tuc sinh vien bi truot mon )
#	$t1 so sinh vien truot mon 
#----------------------------------------------------------------------------------------------
check:
	sw $ra, 20($sp)			# luu gia tri tra ve cua procedure check vao thanh ghi ra
	
	li $t9, 5			# t9 = 5 la so diem can dat de sinh vien khong bij truot
	add $t5, $zero,$zero		# khoi tao i = 0
	add $t4, $zero, $zero		#	   j = 0
	add $t1, $zero, $zero		#	   k = 0
checkMark:
	sll $t6, $t5, 2			# t6 = 4*i
	add $t2, $s1,$t6		# t2 = dia chi cua mark[i]
	lw $t7, 0($t2)			# load gia tri cua mark[i] vao t7
	slt $t8, $t7, $t9		
	beq $t8, $zero, testMark	# kiem tra mark[i] <5 khong?
	add $t3, $s2, $t4		# t3 = dia chi cua pos[j]
	sw $t5, 0($t3)			# pos[j] = t5, luu gia tri cua thanh ghi t5 vao pos[j]
	addi $t4, $t4, 4		# j = j + 4 chi so chi dia chi cua cac phan tu trong pos
	addi $t1, $t1, 1		# k = k +1
testMark:
	addi $t5, $t5, 1		# i = i+1
	beq $t5, $s3, doneCheck 	# kiem tra i = N khong?
	j checkMark
doneCheck:
	lw $ra, 20($sp)			# load gia tri tra ve cua procedure check vao thanh ghi ra
	jr $ra

	

#---------------------------------------------------------
#Procedure output: hien thi ten sinh vien bi truot mon
#Param[in] $t1 so sinh vien truot mon
#Param[in] $s2 mang chua vi tri cua sinh vien truot mon
#Param[in] $s0 mang chua ten cac sinh vien
#---------------------------------------------------------
output:	
	sw $ra, 16($sp)			# luu gia tri dia chi cua procedure check vao thanh ghi sp
	
	bne $t1, $zero, continueOutput	# kiem tra t1 ( so sinh vien truot mon ) =  0 khong? 
	li $v0, 55
	la $a0, MessageNoone
	syscall				# Thong bao khong co sinh vien nao truot mon
	
	j doneOutput
continueOutput:
	li $v0, 56
	la $a0, MessageNumberFailed
	add $a1, $t1, $zero
	syscall				# Thong bao so sinh vien truot mon
	
	li $v0, 55
	la $a0, MessageList
	syscall				# Thong bao danh sach sinh vien truot mon
	
	add $t6, $zero, $zero		#Khoi tao  i = 0
	
	
loop1:	
	beq $t6, $t1, doneOutput	# kiem tra i = t1 -so sinh vien truot mon khong?
	sll $t5, $t6, 2			# t5 = 4*i
	add $t3, $s2, $t5		# t3 = gia tri dia chi cua pos[i]
	lw $t4, 0($t3)			# t4 = pos[i] , load gia tri cua pos[i] luu vao t4
	sll $t9, $t4, 5			# t9 = t4 * 32 , vi  moi phan tu trong mang arrName duoc cap phat la 32 bit
	add $t7, $s0, $t9		# t7 = gia tri dia chi cua arrName[pos[i]] = arrName[t4]

printNameFailed:	
	li $v0, 59
	la $a0, MessageName2
	la $a1, 0($t7)
	syscall				# hien thi ten duoc luu trong arrName[pos[i]]
	
test1:	
	addi $t6, $t6, 1		# i = i + 1
	j loop1
	
doneOutput:
	lw $ra, 16($sp)			#load gia tri tra ve cua procedure output vao thanh ghi ra
	jr $ra

#---------------------------------------------------------------------------------------------------------
#Procedure changetonull: chuyen ki tu cuoi cung trong chuoi khi nhap la ki tu xuong dong thanh ki tu null
#Param[in] $t2=y vi tri dia chi cua chuoi truoc khi chuyen doi
#Return
#	$t2 vi tri dia chi chuoi sau khi chuyen doi
#---------------------------------------------------------------------------------------------------------
changetonull:	
	li $t9, 10
strcpy:
	add $t5,$zero,$zero 			# $t5 = i = 0
L1:
	add $t6,$t5,$t2 			# $t6 = $t5 + $t2 = i + y[0]
								# = address of y[i]
	lb $t3,0($t6) 				# $t3 = value at $t6 = y[i]
	
	beq $t3,$t9,end_of_strcpy 		# if y[i] == '\n', exit
	nop
	addi $t5,$t5,1 				# $t5 = $t5 + 1 <-> i = i + 1
	j L1 					# next character
	nop
end_of_strcpy:
	add $t4, $zero, $zero			#$t4 = 0
	sb $t4, 0($t6)				#  value at $t6 = y[i] = '\0'
		
	jr $ra
#--------------------------------------------------------------------------
#Procedure checkInputMark: kiem tra diem nhap vao co hop le khong
#Param[in] $t8	diem can kiem tra
#Neu diem khong nam trong khoang tu 0 den 10 thi thong bao loi va nhap lai
#Neu hop le thi tiep tuc cac lenh tep theo sau procedure
#--------------------------------------------------------------------------
checkInputMark:
	li $t7, 10			# $t7 = 10
	
	slt $t3, $t8, $zero		# kiem tra t8<0 khong?
	bne $t3, $zero, inputError	# dung thi thong bao loi inputError
	slt $t3, $t7, $t8		# kiem tra 10<t8 khong?
	bne $t3, $zero, inputError	# dung thi thong bao loi inputError
	j continueInputMark
	
inputError:
	li $v0, 55
	la $a0, MessageAgain
	syscall				#Thong bao loi nhap diem
	
	j inputMark
