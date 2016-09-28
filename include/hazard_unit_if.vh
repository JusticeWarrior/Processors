/*
	Jordan Huffaker
	jhuffak@purdue.edu

	hazard unit interface
*/
`ifndef HAZARD_UNIT_IF_VH
`define HAZARD_UNIT_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface hazard_unit_if;
	// import types
	import cpu_types_pkg::*;

	logic		stall;
	regbits_t	wsel_ex, wsel_mem, rsel1_dec, rsel2_dec;

	// request unit ports
	modport hu (
		input		wsel_ex, wsel_mem, rsel1_dec, rsel2_dec,
		output		stall
	);
	// request unit tb
	modport tb (
		input		stall,
		output		wsel_ex, wsel_mem, rsel1_dec, rsel2_dec
	);
endinterface

`endif //HAZARD_UNIT_IF_VH
