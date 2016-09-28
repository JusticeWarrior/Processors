/*
	Jordan Huffaker
	jhuffak@purdue.edu

	forwarding unit interface
*/
`ifndef FORWARDING_UNIT_IF_VH
`define FORWARDING_UNIT_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface fowarding_unit_if;
	// import types
	import cpu_types_pkg::*;

	logic		hazard_dec, hazard_ex, MemtoReg_ex, MemtoReg_mem;
	logic [1:0] rport_dec, rport_ex;
	word_t		rdat1, rdat2, rdat2_ex, porta_ex, portout_ex, dload_mem, out_rdat1, out_rdat2, out_rdat2_ex, out_porta_ex;

	// request unit ports
	modport fu (
		input		hazard_dec, hazard_ex, rport_dec, rport_ex, rdat1, rdat2, MemtoReg_ex, MemtoReg_mem, rdat2_ex, porta_ex, portout_ex, dload_mem,
		output		out_rdat1, out_rdat2, out_rdat2_ex, out_porta_ex
	);
	// request unit tb
	modport tb (
		input		out_rdat1, out_rdat2, out_rdat2_ex, out_porta_ex,
		output		hazard_dec, hazard_ex, rport_dec, rport_ex, rdat1, rdat2, MemtoReg_ex, MemtoReg_mem, rdat2_ex, porta_ex, portout_ex, dload_mem
	);
endinterface

`endif //HAZARD_UNIT_IF_VH
