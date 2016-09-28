/*
	Jordan Huffaker
	jhuffak@purdue.edu

	execute latch interface
*/
`ifndef EXECUTE_LATCH_IF_VH
`define EXECUTE_LATCH_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface execute_latch_if;
	// import types
	import cpu_types_pkg::*;

	logic	flush, en, zero, out_zero, Branch, out_Branch, bne, out_bne, regWEN, out_regWEN, halt, out_halt, Jump, out_Jump, JAL, out_JAL, MemtoReg, out_MemtoReg, dREN, out_dREN, dWEN, out_dWEN, dhit;
	regbits_t wsel, out_wsel;
	word_t	pc_plus_4, out_pc_plus_4, baddr, out_baddr, portout, out_portout, rdat2, out_rdat2, jaddr, out_jaddr;

	// fetch latch ports
	modport fl (
		input	pc_plus_4, baddr, zero, portout, rdat2, Branch, bne, regWEN, halt, Jump, JAL, MemtoReg, dREN, dWEN, wsel, jaddr, flush, en, dhit,
		output	out_pc_plus_4, out_baddr, out_zero, out_portout, out_rdat2, out_Branch, out_bne, out_regWEN, out_halt, out_Jump, out_JAL, out_MemtoReg, out_dREN, out_dWEN, out_wsel, out_jaddr
	);
	// fetch latch tb
	modport tb (
		input	out_pc_plus_4, out_baddr, out_zero, out_portout, out_rdat2, out_Branch, out_bne, out_regWEN, out_halt, out_Jump, out_JAL, out_MemtoReg, out_dREN, out_dWEN, out_wsel, out_jaddr,
		output	pc_plus_4, baddr, zero, portout, rdat2, Branch, bne, regWEN, halt, Jump, JAL, MemtoReg, dREN, dWEN, wsel, jaddr, flush, en, dhit
	);
endinterface

`endif //EXECUTE_LATCH_IF_VH
