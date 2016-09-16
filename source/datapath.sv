/*
	Jordan Huffaker
	jhuffak@purdue.edu

	datapath contains register file, control, hazard,
	muxes, and glue logic for processor
*/

// data path interface
`include "datapath_cache_if.vh"
`include "request_unit_if.vh"
`include "control_unit_if.vh"
`include "ALU_if.vh"
`include "register_file_if.vh"

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

	regbits_t Rw;
	word_t Ext_Out, Selector_Out, PC, next_PC;

	PC_Register #(PC_INIT) _PC(CLK, nRST, ruif.Adv, cuif.Halt, next_PC, PC);
	Extender _Extender(CLK, nRST, cuif.ExtOp, cuif.Upper, cuif.imm16, Ext_Out);
	control_unit _control_unit(CLK, nRST, cuif);
	request_unit _request_unit(CLK, nRST, ruif);
	ALU _ALU(aluif);
	register_file _register_file(CLK, nRST, rfif);

	assign Rw = !cuif.RegDst ? cuif.Rd : cuif.Rt;
	assign Selector_Out = cuif.ALUSrc ? Ext_Out : rfif.rdat2;

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
	assign ruif.rw = rfif.rdat2;
	assign ruif.PC = PC;

	// ALU connections
	assign aluif.ALUOP = cuif.ALUCtr;
	assign aluif.portA = rfif.rdat1;
	assign aluif.portB = Selector_Out;

	// register_file_connections
	assign rfif.WEN = cuif.RegWr && ruif.Adv;
	assign rfif.wsel = Rw;
	assign rfif.rsel1 = cuif.Rs;
	assign rfif.rsel2 = cuif.Rt;
	always_comb begin
		if (cuif.JAL)
			rfif.wdat = PC + 32'd4;
		else if (cuif.MemtoReg)
			rfif.wdat = ruif.out_ddata;
		else
			rfif.wdat = aluif.portOut;
	end

	// datapath
	assign dpif.halt = cuif.Halt;
	assign dpif.imemREN = ruif.iren;
	assign dpif.imemaddr = ruif.iaddr;
	assign dpif.dmemREN = ruif.dren;
	assign dpif.dmemWEN = ruif.wren;
	assign dpif.dmemstore = ruif.store;
	assign dpif.dmemaddr = ruif.daddr;

	always_comb begin
		if (cuif.JR)
			next_PC = rfif.rdat1;
		else if (cuif.Jmp)
			next_PC = {PC[31:28], cuif.imm26, 2'b0};
		else if (cuif.PCSrc)
			next_PC = (Ext_Out << 2) + 32'd4 + PC;
		else
			next_PC = 32'd4 + PC;
	end

endmodule
