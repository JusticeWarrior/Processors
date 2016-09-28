/*
	Jordan Huffaker
	jhuffak@purdue.edu

	fetch latch interface
*/
`ifndef MEMORY_LATCH_IF_VH
`define MEMORY_LATCH_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface memory_latch_if;
	// import types
	import cpu_types_pkg::*;

	logic	flush, en, regWEN, out_regWEN, halt, out_halt, Jump, out_Jump, JAL, out_JAL, MemtoReg, out_MemtoReg, dhit;
	regbits_t wsel, out_wsel;
	word_t	pc_plus_4, out_pc_plus_4, portout, out_portout, jaddr, out_jaddr, dload, out_dload;

	// fetch latch ports
	modport fl (
		input	pc_plus_4, portout, regWEN, halt, Jump, JAL, MemtoReg, wsel, jaddr, dload, flush, en, dhit,
		output	out_pc_plus_4, out_portout, out_regWEN, out_halt, out_Jump, out_JAL, out_MemtoReg, out_wsel, out_jaddr, out_dload
	);
	// fetch latch tb
	modport tb (
		input	out_pc_plus_4, out_portout, out_regWEN, out_halt, out_Jump, out_JAL, out_MemtoReg, out_wsel, out_jaddr, out_dload,
		output	pc_plus_4, portout, regWEN, halt, Jump, JAL, MemtoReg, wsel, jaddr, dload, flush, en, dhit
	);
endinterface

`endif //MEMORY_LATCH_IF_VH
