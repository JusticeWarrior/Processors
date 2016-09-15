/*
	Jordan Huffaker
	jhuffak@purdue.edu

	control unit interface
*/
`ifndef CONTROL_UNIT_IF_VH
`define CONTROL_UNIT_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface control_unit_if;
	// import types
	import cpu_types_pkg::*;

	logic	Zero, MemtoReg, ALUCtr, PCSrc, Jmp, RegDst, RegWr, JAL, Upper, ExtOp, ALUSrc, MemRd, MemWr;
	word_t		Instr;
	regbits_t	Rd, Rt, Rs;

	// control unit ports
	modport cu (
		input		Zero, Instr,
		output	MemtoReg, ALUCtr, Rd, Rt, Rs, PCSrc, Jmp, imm26, RegDst, RegWr, JAL, imm16, Upper, ExtOp, ALUSrc, MemRd, MemWr
	);
	// control unit tb
	modport tb (
		input	MemtoReg, ALUCtr, Rd, Rt, Rs, PCSrc, Jmp, imm26, RegDst, RegWr, JAL, imm16, Upper, ExtOp, ALUSrc, MemRd, MemWr
		output		Zero, Instr,
	);
endinterface

`endif //CONTROL_UNIT_IF_VH
