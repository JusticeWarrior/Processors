/*
	Eric Villasenor
	evillase@gmail.com

	datapath contains register file, control, hazard,
	muxes, and glue logic for processor
*/

// data path interface
`include "datapath_cache_if.vh"
`include "request_unit_if.vh"
`include "control_unit_if.vh"
`include "ALU_if.vh"
`include "register_file.vh"

// alu op, mips op, and instruction type
`include "cpu_types_pkg.vh"

module datapath (
	input logic CLK, nRST,
	datapath_cache_if.dp dpif
);
	// import types
	import cpu_types_pkg::*;

	// pc init
	parameter PC_INIT = 0;

	control_unit_if cuif ();
	request_unit_if ruif ();
	ALU_if aluif ();
	register_file_if rfif ();

	// control unit connections
	assign cuif.Instr = ruif.out_instr;
	assign cuif.Zero = aluif.zero;

	// request unit connections
	assign ruif.MemWr = cuif.MemWr;
	assign ruif.MemRd = cuif.MemRd;
	assign ruif.aluDaddr = aluif.portOut;
	assign ruif.dhit = dpif.dhit;
	assign ruif.ddata = dpif.dmemload;
	assign ruif.ihit = dpif.ihit;
	assign ruif.instr = dpif.imemload;
	assign ruif.rw = // logic wire goes here

	// ALU connections
	assign aluif.ALUOP = cuif.ALUCtr;
	assign aluif.portA = rfif.rdat1;
	assign aluif.portB = // logic wire goes here

	// register_file_connections
	assign rfif.WEN = cuif.RegWr;
	assign rfif.wsel = // logic wire goes here
	assign rfif.rsel1 = cuif.Rs;
	assign rfif.rsel2 = cuif.Rt;
	assign rfif.wdat = // logic wire goes here

	PC #(PC_INIT) _PC(CLK, nRST, ruif.ihit, cuif.Halt, ruif.PC);

	Extender _Extender(CLK, nRST, cuif.ExtOp, cuif.Upper, cuif.imm16, /* logic wire goes here */);

	control_unit _control_unit(CLK, nRST, cuif);
	request_unit _request_unit(CLK, nRST, ruif);
	ALU _ALU(aluif);
	register_file _register_file(CLK, nRST, rfif);



endmodule
