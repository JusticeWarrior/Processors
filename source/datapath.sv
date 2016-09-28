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
`include "fetch_latch_if.vh"
`include "decode_latch_if.vh"
`include "execute_latch_if.vh"
`include "memory_latch_if.vh"
`include "hazard_unit_if.vh"

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
	ALU_if aluif ();
	register_file_if rfif ();
	fetch_latch_if flif();
	decode_latch_if dlif();
	execute_latch_if elif();
	memory_latch_if mlif();
	hazard_unit_if huif();

	logic en, bsel;
	regbits_t Rw;
	word_t Ext_Out, PC, next_PC;

	control_unit _control_unit(CLK, nRST, cuif);
	ALU _ALU(aluif);
	register_file _register_file(CLK, nRST, rfif);
	fetch_latch _fetch_latch(CLK, nRST, flif);
	decode_latch _decode_latch(CLK, nRST, dlif);
	execute_latch _execute_latch(CLK, nRST, elif);
	memory_latch _memory_latch(CLK, nRST, mlif);
	hazard_unit _hazard_unit(CLK, nRST, huif);

	assign en = (dpif.ihit & !mlif.out_halt);

	//pc conns
	PC_Register #(PC_INIT) _PC(CLK, nRST, en, '0, next_PC, PC);

	//fetch register conns
	assign flif.pc_plus_4 = PC + 32'd4;
	assign flif.imemload = dpif.imemload;
	assign flif.flush = (cuif.Jmp | cuif.JR) | bsel;
	assign flif.en = en & ~huif.stall;

	//control unit conns
	assign cuif.Instr = flif.instr;

	//extender unit conns
	Extender _Extender(CLK, nRST, cuif.ExtOp, cuif.Upper, cuif.imm16, Ext_Out);

	//register file conns
	assign rfif.WEN = mlif.out_regWEN;
	assign rfif.wsel = mlif.out_wsel;
	assign rfif.rsel1 = cuif.Rs;
	assign rfif.rsel2 = cuif.Rt;

	//hazard unit conns
	assign huif.wel_ex = elif.wsel;
	assign huif.rsel1_dec = cuif.Rs;
	assign huif.rsel2_dec = cuif.Rt;

	//decode register conns
	assign dlif.pc_plus_4 = flif.out_pc_plus_4;
	assign dlif.rdat1 = rfif.rdat1;
	assign dlif.rdat2 = rfif.rdat2;
	assign dlif.extout = Ext_Out;
	assign dlif.ALUSrc = cuif.ALUSrc;
	assign dlif.Branch = cuif.branch;
	assign dlif.bne = cuif.bne;
	assign dlif.regWEN = cuif.RegWr;
	assign dlif.halt = cuif.Halt;
	//assign dlif.Jump = cuif.Jmp | cuif.JR;
	assign dlif.MemtoReg = cuif.MemtoReg;
	assign dlif.dREN = cuif.MemRd;
	assign dlif.dWEN = cuif.MemWr;
	assign dlif.ALUop = cuif.ALUCtr;
	assign dlif.regDst = cuif.RegDst;
	//assign dlif.jaddr = cuif.JR ? rfif.rdat1 : {flif.out_pc_plus_4[31:28], cuif.imm26<<2};
	assign dlif.JAL = cuif.JAL;
	assign dlif.flush = bsel;
	assign dlif.en = en & ~huif.stall;
	assign dlif.Rd = cuif.Rd;
	assign dlif.Rt = cuif.Rt;

	//ALU conns
	assign aluif.ALUOP = dlif.out_ALUop;
	assign aluif.portA = dlif.out_porta;
	assign aluif.portB = dlif.out_ALUSrc ? dlif.out_extout : dlif.out_rdat2;

	//execute register conns
	assign elif.pc_plus_4 = dlif.out_pc_plus_4;
	assign elif.baddr = (dlif.out_pc_plus_4 + (dlif.out_extout << 2));
	assign elif.zero = aluif.zero;
	assign elif.portout = aluif.portOut;
	assign elif.rdat2 = dlif.out_rdat2;
	assign elif.Branch = dlif.out_Branch;
	assign elif.bne = dlif.out_bne;
	assign elif.regWEN = dlif.out_regWEN;
	assign elif.halt = dlif.out_halt;
	//assign elif.Jump = dlif.out_Jump;
	assign elif.JAL = dlif.out_JAL;
	assign elif.MemtoReg = dlif.out_MemtoReg;
	assign elif.dREN = dlif.out_dREN;
	assign elif.dWEN = dlif.out_dWEN;
	assign elif.wsel = !dlif.out_regDst ? dlif.out_Rd : dlif.out_Rt;
	//assign elif.jaddr = dlif.out_jaddr;
	assign elif.flush = bsel;
	assign elif.en = en & ~huif.stall;
	assign elif.dhit = dpif.dhit;

	//memory register conns
	assign mlif.pc_plus_4 = elif.out_pc_plus_4;
	assign mlif.portout = elif.out_portout;
	assign mlif.regWEN = elif.out_regWEN;
	assign mlif.halt = elif.out_halt;
	//assign mlif.Jump = elif.out_Jump;
	assign mlif.JAL = elif.out_JAL;
	assign mlif.MemtoReg = elif.out_MemtoReg;
	assign mlif.wsel = elif.out_wsel;
	//assign mlif.jaddr = elif.out_jaddr;
	assign mlif.dload = dpif.dmemload;
	assign mlif.flush = 0;
	assign mlif.en = en;
	assign mlif.dhit = dpif.dhit;

	assign bsel = (elif.zero & elif.Branch) | (~elif.zero & elif.bne);

	always_comb begin
		if (cuif.Jmp | cuif.JR)
			next_PC = cuif.JR ? rfif.rdat1 : {flif.out_pc_plus_4[31:28], cuif.imm26<<2};
		else if (bsel)
			next_PC = elif.out_baddr;
		else
			next_PC = PC + 32'd4;
	end

	always_comb begin
		if (mlif.out_JAL)
			rfif.wdat = mlif.out_pc_plus_4;
		else if (mlif.out_MemtoReg)
			rfif.wdat = mlif.out_dload;
		else
			rfif.wdat = mlif.out_portout;
	end

	// datapath
	assign dpif.halt = mlif.out_halt;
	assign dpif.imemREN = ~mlif.out_halt;
	assign dpif.imemaddr = PC;
	assign dpif.dmemREN = elif.out_dREN & !mlif.out_halt;
	assign dpif.dmemWEN = elif.out_dWEN & !mlif.out_halt;
	assign dpif.dmemstore = elif.out_rdat2;
	assign dpif.dmemaddr = elif.out_portout;

endmodule
