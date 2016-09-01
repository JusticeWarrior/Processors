	org 0x0100
	# Sets stack pointer
	lui $29, 0xFFFF
	ori $29, $29, 0x03
	nor $29, $0, $29

	ori $2, $0, 0x0009 # arg1
	push $2
	ori $3, $0, 0x0007 # arg2
	push $3
mult:
	pop $2
	pop $3
	nor $4, $0, $0
	or $6, $0, $0
loop:
	addi $4, $4, 1
	slt $5, $4, $3
	beq $5, $0, end
	add $6, $6, $2
	j loop
end:
	push $6
	halt
	#jr $31
