	org 0x0000
	# Sets stack pointer
	lui $29, 0xFFFF
	ori $29, $29, 0x03
	nor $29, $0, $29

	lw $2, 0x0100($0)
	push $2
	lw $2, 0x0104($0)
	push $2
	jal mult
	ori $30, $0, 0x04
args:
	addi $30, $30, 4
	slti $28, $30, 0x10 # number of args
	beq $28, $0, endend
	lw $2, 0x0100($30)
	push $2
	jal mult
	j args
endend:
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

# Args
mem:
	org 0x0100
	cfw 0x0001
	cfw 0x0005
	cfw 0x0008
	cfw 0x0003
