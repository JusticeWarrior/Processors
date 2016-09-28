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

	logic		hazard_dec, hazard_ex;
	logic [1:0] rport_dec, rport_ex;
	regbits_t	wsel_mem, wsel_ex, rsel1_dec, rsel2_dec, rsel1_ex, rsel2_ex;

	// request unit ports
	modport hu (
		input		wsel_mem, wsel_ex, rsel1_dec, rsel2_dec, rsel1_ex, rsel2_ex,
		output		hazard_dec, hazard_ex, rport_dec, rport_ex
	);
	// request unit tb
	modport tb (
		input		hazard_dec, hazard_ex, rport_dec, rport_ex,
		output		wsel_mem, wsel_ex, rsel1_dec, rsel2_dec, rsel1_ex, rsel2_ex
	);
endinterface

`endif //HAZARD_UNIT_IF_VH
