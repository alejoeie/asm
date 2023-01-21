.data
separator: .asciiz ","
newLine: .asciiz "\n"
array:
	.word 87, 216, -54, 751, 1, 36, 1225, -446, -6695, -8741, 101, 9635, -9896, 4, 2008, -99, -6, 1, 544, 6, 7899, 74, -42, -9, 0
sorted:
	.word 0

.text
	main:
		la $a0, array  # Guardo en t0 la direccion de array.
		la $a1, sorted # Guardo memoria para el nuevo array ordenado.
		jal sortEvenOddArr
		li $v0, 10
    		syscall
	sortEvenOddArr:
		addi $sp, $sp, -16 # cuatro posiciones de memoria
		sw $ra, 12($sp)
		sw $a0, 8($sp)
		sw $a1, 4($sp)
		
		jal printArray
		
		lw $t0, 8($sp)
		jal bubbleSort
		sw $v0, 0($sp)
		
		lw $a0, 8($sp)
		jal printArray
		
		lw $t0, 8($sp)
		lw $t2, 4($sp)
		lw $t1, 0($sp)
		
		sll $t1, $t1, 2 
		addu $t1, $t1, $t2
		sw $0, 0($t1)
		addi $t1, $t1, -4 # Decrementar t1
	loop:
		lw $t3, 0($t0)
		beq $t3, $0, endloop
		
		andi $t4, $t3, 1
		beq $t4, $0, ev
		sw $t3, 0($t1)
		addi $t1, $t1, -4
		j aum

	ev:
		sw $t3, 0($t2)
		addi $t2, $t2, 4
	aum:
		addi $t0, $t0, 4
		j loop
	endloop:
		lw $t0, 4($sp)
		jal printArray
		lw $ra, 12($sp)
		addi $sp, $sp, 16
		jr $ra
		
	bubbleSort:
		add $v0, $0, $0 # Guarda el numero de elementos del array
		add $t0, $0, $0 # Iterador
		for:
			sll $t1, $v0, 2 # i * 4
			addu $t1, $t1, $a0 # t4 = A + i*4
			lw $t2, 0($t1) # Cargo en t5 el valor de A[i]
			beq $t2, $0, endFor # Comparo hasta llegar al ultimo elemento
			
			addi $v0, $v0, 1 # i++
			lw $t3, 4($t1) # t6 = A[i+1]
			beq $t3, $0, endFor
			
			# Comparacion
			slt $t4, $t3, $t2 # if A[i+1] < A[i]
			beq $t4, $0, for 
			
			sw $t2, 4($t1) # A[i] = A[i+1]
			sw $t3, 0($t1) # A[i+1] = A[i]
			
			add $t0, $0, 1
			j for
		endFor:
			bne $t0, $0, bubbleSort
			jr $ra
			
printArray:
add $t4, $0, $0 #i=0
add $t1, $a0, $0 #$t1 array address
loopP:
sll $t3, $t4, 2 #i*4
addu $t3, $t3, $t1 #$t3=A+i*4
addi $v0, $0, 1 #Print int code (1) in $v0
lw $a0, 0($t3) #int to print in $t0
syscall
beq $a0, $0, printEnd
addi $t4, $t4, 1 #i++
addi $v0, $0, 4 #Print string code (4) in $v0
la $a0, separator #string address to print in $t0
syscall
j loopP
printEnd:
addi $v0, $0, 4 #Print string code (4) in $v0
la $a0, newLine #string address to print in $t0
syscall
jr $ra
		    		
				
			