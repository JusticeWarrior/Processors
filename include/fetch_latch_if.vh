/*
	Jordan Huffaker
	jhuffak@purdue.edu

	fetch latch interface
*/
`ifndef FETCH_LATCH_IF_VH
`define FETCH_LATCH_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface fetch_latch_if;
	// import types
	import cpu_types_pkg::*;

	logic	flush, en;
	word_t	pc_plus_4, imemload, instr, out_pc_plus_4;

	// fetch latch ports
	modport fl (
		input	pc_plus_4, imemload, flush, en,
		output	instr, out_pc_plus_4
	);
	// fetch latch tb
	modport tb (
		input	instr, out_pc_plus_4,
		output	pc_plus_4, imemload, flush, en
	);
endinterface

`endif //FETCH_LATCH_IF_VH
