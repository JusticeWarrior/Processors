/*
	Jordan Huffaker
	jhuffak@purdue.edu

	request unit interface
*/
`ifndef REQUEST_UNIT_IF_VH
`define REQUEST_UNIT_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface request_unit_if;
	// import types
	import cpu_types_pkg::*;

	logic	dhit, MemWr, MemRd, wren, dren, ihit, iren;
	word_t		ddata, out_ddata, store, daddr, instr, out_instr, iaddr, aluDaddr, PC, rw;

	// request unit ports
	modport ru (
		input		dhit, ddata, ihit, instr, MemWr, MemRd, PC, rw, aluDaddr,
		output	store, daddr, wren, dren, iaddr, iren, out_instr, out_ddata
	);
	// request unit tb
	modport tb (
		input		store, daddr, wren, dren, iaddr, iren, out_instr, out_ddata,
		output	dhit, ddata, ihit, instr, MemWr, MemRd, PC, rw, aluDaddr
	);
endinterface

`endif //REQUEST_UNIT_IF_VH
