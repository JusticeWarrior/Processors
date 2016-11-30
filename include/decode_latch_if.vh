/*
	Jordan Huffaker
	jhuffak@purdue.edu

	decode latch interface
*/
`ifndef DECODE_LATCH_IF_VH
`define DECODE_LATCH_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface decode_latch_if;
	// import types
	import cpu_types_pkg::*;

	logic	flush, en, Branch, out_Branch, bne, out_bne, regWEN, out_regWEN, halt, out_halt, Jump, out_Jump, MemtoReg, out_MemtoReg, dREN, out_dREN, dWEN, out_dWEN, regDst, out_regDst, JAL, out_JAL, ALUSrc, out_ALUSrc, datomic, out_datomic;
	aluop_t ALUop, out_ALUop;
	regbits_t Rd, Rt, out_Rd, out_Rt, rsel1, rsel2, out_rsel1, out_rsel2;
	word_t	pc_plus_4, out_pc_plus_4, rdat1, out_porta, rdat2, out_rdat2, extout, out_extout, jaddr, out_jaddr;

	// decode latch ports
	modport fl (
		input	pc_plus_4, rdat1, rdat2, extout, ALUSrc, Branch, bne, regWEN, halt, Jump, MemtoReg, dREN, dWEN, ALUop, regDst, jaddr, JAL, flush, en, Rd, Rt, rsel1, rsel2, datomic,
		output	out_pc_plus_4, out_porta, out_rdat2, out_extout, out_ALUSrc, out_Branch, out_bne, out_regWEN, out_halt, out_Jump, out_MemtoReg, out_dREN, out_dWEN, out_ALUop, out_regDst, out_jaddr, out_JAL, out_Rd, out_Rt, out_rsel1, out_rsel2, out_datomic
	);
	// decode latch tb
	modport tb (
		input	out_pc_plus_4, out_porta, out_rdat2, out_extout, out_ALUSrc, out_Branch, out_bne, out_regWEN, out_halt, out_Jump, out_MemtoReg, out_dREN, out_dWEN, out_ALUop, out_regDst, out_jaddr, out_JAL, out_Rd, out_Rt, out_rsel1, out_rsel2, out_datomic,
		output	pc_plus_4, rdat1, rdat2, extout, ALUSrc, Branch, bne, regWEN, halt, Jump, MemtoReg, dREN, dWEN, ALUop, regDst, jaddr, JAL, flush, en, Rd, Rt, rsel1, rsel2, datomic
	);
endinterface

`endif //FETCH_LATCH_IF_VH
