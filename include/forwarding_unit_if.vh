`ifndef FORWARDING_UNIT_IF_VH
`define FORWARDING_UNIT_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface forwarding_unit_if;
	// import types
	import cpu_types_pkg::*;

	logic	regWEN_ex, regWEN_mem;
	regbits_t Rd_mem, Rs_dec, Rt_dec, Rd_ex;
	logic [1:0] forwardA, forwardB;

	// forwarding unit ports
	modport fu (
		input	regWEN_ex, regWEN_mem, Rd_mem, Rs_dec, Rt_dec, Rd_ex,
		output	forwardA, forwardB
	);
	// forwarding unit tb
	modport tb (
		input	forwardA, forwardB,
		output	regWEN_ex, regWEN_mem, Rd_mem, Rs_dec, Rt_dec, Rd_ex
	);
endinterface

`endif //FORWARDING_UNIT_IF_VH