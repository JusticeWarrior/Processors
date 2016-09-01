	org 0x0000
	# Sets stack pointer
	lui $29, 0xFFFF
	ori $29, $29, 0x03
	nor $29, $0, $29

	lw $2, 0x0104($0)
	addiu $2, $2, -1
	push $2
	ori $2, $0, 0x001E
	push $2
	jal mult

	lw $2, 0x0108($0)
	ori $3, $0, 0x07D0
	sub $2, $2, $3
	push $2
	ori $2, $0, 0x016D
	push $2
	jal mult

	pop $2
	pop $3

	add $2, $2, $3
	lw $3, 0x0100($0)
	add $2, $2, $3
	push $2
	halt

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
	jr $31

mem:
	org 0x0100
	cfw 0x0013 # CurrentDay
	cfw 0x0008 # CurrentMonth
	cfw 0x07E0 # CurrentYear
