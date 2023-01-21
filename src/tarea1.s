
#.text 
#main:
#	la $t0, array # Direccion base del arreglo guardada
# 	add $t1, $0, $0 # i = 0
	# Para guardar en $t1 el size del array.
#	while :
#		sll $t2, $t1, 2 # i * 4
#		add $t2, $t2, $t0 # A + i * 4
#		lw $t3, 0($t2) # Guardando en t4 el valor de t2
#		beq $t3, $0, endWhile # Comparo que el iterador no sea 0, de lo contrario, termine
#		sw $0, 0($t3) # Guardo un 0 en t3
#		addi $t1, $t1, 1 # Hago que el iterador incremente
#		j while # de vuelta al while
#	endWhile:
#.data
#array: 
#	.word 87, 216, -54, 751, 1, 36, 1225, -446, -6695, -8741, 101, 9635, -9896, 4, 2008, -99, -6, 1, 544, 6,
#7899, 74, -42, -9, 0
.data
sep: .asciiz ","
bLine: : .asciiz "\n"
array: .word 87, 216, -54, 751, 1, 36, 1225, -446, -6695, -8741, 101, 9635, -9896, 4, 2008, -99, -6, 1, 544, 6, 7899, 74, -42, -9, 0
sorted: .word 0
.text
main:
la $a0, array
la $a1, sorted
jal evenOddSort
li $v0, 10
syscall
evenOddSort:
	addi $sp, $sp, -16
	sw $ra, 12($sp)
	sw $a0, 8($sp) #des
	sw $a1, 4($sp) #ord
	#jal printArray
	lw $a0, 8($sp)
	jal bubbleSort
	sw $v0, 0($sp)
	lw $a0, 8($sp)
	#jal printArray
	lw $t0, 8($sp) #des, pD
	lw $t2, 4($sp) #ord, pE
	lw $t1, 0($sp) #numEle, pO
	sll $t1, $t1, 2
	addu $t1, $t1, $t2
	sw $0, 0($t1) #ord[numEle]=0
	addi $t1, $t1, -4 #pO--
EvenOddSortLoop:
	lw $t3, 0($t0)
	beq $t3, $0, EvenOddSortEnd
	andi $t4, $t3, 1
	beq $t4, $0, even
	sw $t3, 0($t1)
	addi $t1, $t1, -4 #pO--
	j inc
	even:
		sw $t3, 0($t2)
		addi $t2, $t2, 4 #pE++
	inc:
		addi $t0, $t0, 4 #PD++
	j EvenOddSortLoop
	EvenOddSortEnd:
		lw $a0, 4($sp)
		jal printArray
		lw $ra, 12($sp)
		addi $sp, $sp, 16
		jr $ra
	bubbleSort:
		add $v0, $0, $0 #numEle, pD
		add $t0, $0, $0 #swap
	loop:
		sll $t1, $v0, 2 #pD*4
		addu $t1, $t1, $a0 #$t1=A+i*4
		lw $t2, 0($t1) #$t2=A[i]
		beq $t2, $0, endLoop
		addi $v0, $v0, 1 #numEle++
		lw $t3, 4($t1) #$t3=A[i+1]
		beq $t3, $0, endLoop
		slt $t4, $t3, $t2 #$t4=1 si A[i+1]<A[i] so swap
		beq $t4, $0, loop
		sw $t2, 4($t1) #A[i]=A[i+1]
		sw $t3, 0($t1) #A[i+1]=A[i]
		addi $t0, $0, 1 #set swap flag
	j loop
	endLoop:
		bne $t0, $0, bubbleSort #iterate again if swap==1
		jr $ra

printArray:
add $t0, $0, $0 #i=0
add $t1, $a0, $0 #$t1 array address
loopP:
sll $t2, $t0, 2 #i*4
addu $t2, $t2, $t1 #$t2=A+i*4
addi $v0, $0, 1 #Print int code (1) in $v0
lw $a0, 0($t2) #int to print in $a0
syscall
beq $a0, $0, printEnd
addi $t0, $t0, 1 #i++
addi $v0, $0, 4 #Print string code (4) in $v0
la $a0, sep #string address to print in $a0
syscall
j loopP
printEnd:
addi $v0, $0, 4 #Print string code (4) in $v0
la $a0, bLine #string address to print in $a0
syscall
jr $ra