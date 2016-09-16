/*
	Jordan Huffaker
	jhuffak@purdue.edu

	request unit test bench
*/

// mapped needs this
`include "request_unit_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module request_unit_tb;

	parameter PERIOD = 10;

	logic CLK = 0, nRST;

	// test vars
	int v1 = 1;
	int v2 = 4721;
	int v3 = 25119;

	// clock
	always #(PERIOD/2) CLK++;

	// interface
	request_unit_if ruif ();
	// test program
	test PROG ();
	// DUT
`ifndef MAPPED
	request_unit DUT(CLK, nRST, ruif);
`else
	request_unit DUT(
		.\ruif.store (ruif.store),
		.\ruif.aluDaddr (ruif.aluDaddr),
		.\ruif.wren (ruif.wren),
		.\ruif.dren (ruif.dren),
		.\ruif.iaddr (ruif.iaddr),
		.\ruif.iren (ruif.iren),
		.\ruif.out_instr (ruif.out_instr),
		.\ruif.out_ddata (ruif.out_ddata),
		.\ruif.Adv (ruif.Adv),

		.\ruif.dhit (ruif.dhit),
		.\ruif.ddata (ruif.ddata),
		.\ruif.ihit (ruif.ihit),
		.\ruif.instr (ruif.instr),
		.\ruif.daddr (ruif.daddr),
		.\ruif.MemWr (ruif.MemWr),
		.\ruif.MemRd (ruif.MemRd),
		.\ruif.PC (ruif.PC),
		.\ruif.rw (ruif.rw),
		.\ruif.aluDaddr (ruif.aluDaddr),
		.\nRST (nRST),
		.\CLK (CLK)
	);
`endif

	initial begin
	nRST = 1'b0;
	ruif.dhit = '0;
	ruif.ddata = '0;
	ruif.ihit = '0;
	ruif.instr = 32'd6;
	ruif.aluDaddr = '0;
	ruif.MemWr = '0;
	ruif.MemRd = '0;
	ruif.PC = '0;
	ruif.rw = '0;
	ruif.aluDaddr = '0;

	#PERIOD;

	nRST = 1'b1;

	#PERIOD;

	assert (ruif.iren == '1) else
		$display("DIDNT SET INITIAL iren CORRECTLY");
	assert (ruif.wren == '0) else
		$display("DIDNT SET INITIAL wren CORRECTLY");
	assert (ruif.dren == '0) else
		$display("DIDNT SET INITIAL dren CORRECTLY");
	assert (ruif.iaddr == '0) else
		$display("DIDNT SET INITIAL iaddr CORRECTLY");
	assert (ruif.Adv == '0) else
		$display("DIDNT SET INITIAL Adv CORRECTLY");

	ruif.MemWr = '1;
	ruif.rw = 32'd5;
	ruif.aluDaddr = 32'd3;

	#PERIOD;

	assert (ruif.iren == '1) else
		$display("1 DIDNT SET iren CORRECTLY");
	assert (ruif.wren == '0) else
		$display("1 DIDNT SET INITIAL wren CORRECTLY");
	assert (ruif.dren == '0) else
		$display("1 DIDNT SET INITIAL dren CORRECTLY");
	assert (ruif.iaddr == '0) else
		$display("1 DIDNT SET INITIAL iaddr CORRECTLY");
	assert (ruif.out_instr == 32'd6) else
		$display("1 DIDNT SET INITIAL out_instr CORRECTLY");
	assert (ruif.Adv == '0) else
		$display("1 DIDNT SET INITIAL Adv CORRECTLY");

	ruif.ihit = '1;

	#PERIOD;

	assert (ruif.iren == '0) else
		$display("2 DIDNT SET INITIAL iren CORRECTLY");
	assert (ruif.dren == '0) else
		$display("2 DIDNT SET INITIAL dren CORRECTLY");
	assert (ruif.wren == '1) else
		$display("2 DIDNT SET INITIAL wren CORRECTLY");
	assert (ruif.store == 32'd5) else
		$display("2 DIDNT SET INITIAL store CORRECTLY");
	assert (ruif.daddr == 32'd3) else
		$display("2 DIDNT SET INITIAL daddr CORRECTLY");
	assert (ruif.Adv == '0) else
		$display("2 DIDNT SET INITIAL Adv CORRECTLY");

	ruif.ihit = '0;

	#PERIOD

	assert (ruif.iren == '0) else
		$display("3 DIDNT SET INITIAL iren CORRECTLY");
	assert (ruif.dren == '0) else
		$display("3 DIDNT SET INITIAL dren CORRECTLY");
	assert (ruif.wren == '1) else
		$display("3 DIDNT SET INITIAL wren CORRECTLY");
	assert (ruif.store == 32'd5) else
		$display("3 DIDNT SET INITIAL store CORRECTLY");
	assert (ruif.daddr == 32'd3) else
		$display("3 DIDNT SET INITIAL daddr CORRECTLY");
	assert (ruif.Adv == '0) else
		$display("3 DIDNT SET INITIAL Adv CORRECTLY");

	ruif.dhit = '1;

	#PERIOD;

	assert (ruif.iren == '1) else
		$display("4 DIDNT SET INITIAL iren CORRECTLY");
	assert (ruif.dren == '0) else
		$display("4 DIDNT SET INITIAL dren CORRECTLY");
	assert (ruif.wren == '0) else
		$display("4 DIDNT SET INITIAL wren CORRECTLY");
	assert (ruif.iaddr == '0) else
		$display("4 DIDNT SET INITIAL iaddr CORRECTLY");
	assert (ruif.out_instr == 32'd6) else
		$display("4 DIDNT SET INITIAL out_instr CORRECTLY");
	assert (ruif.Adv == '0) else
		$display("4 DIDNT SET INITIAL Adv CORRECTLY");

	ruif.MemWr = '0;
	ruif.dhit = '0;
	ruif.ihit = '1;
	ruif.MemRd = '1;
	ruif.aluDaddr = 32'd3;
	ruif.ddata = 32'd1;

	#PERIOD;

	assert (ruif.iren == '0) else
		$display("5 DIDNT SET INITIAL iren CORRECTLY");
	assert (ruif.dren == '1) else
		$display("5 DIDNT SET INITIAL dren CORRECTLY");
	assert (ruif.wren == '0) else
		$display("5 DIDNT SET INITIAL wren CORRECTLY");
	assert (ruif.daddr == 32'd3) else
		$display("5 DIDNT SET INITIAL daddr CORRECTLY");
	assert (ruif.out_ddata == 32'd1) else
		$display("5 DIDNT SET INITIAL out_ddata CORRECTLY");
	assert (ruif.Adv == '0) else
		$display("5 DIDNT SET INITIAL Adv CORRECTLY");

	ruif.dhit = '1;

	#PERIOD;

	assert (ruif.iren == '1) else
		$display("6 DIDNT SET INITIAL iren CORRECTLY");
	assert (ruif.dren == '0) else
		$display("6 DIDNT SET INITIAL dren CORRECTLY");
	assert (ruif.wren == '0) else
		$display("6 DIDNT SET INITIAL wren CORRECTLY");
	assert (ruif.iaddr == '0) else
		$display("6 DIDNT SET INITIAL iaddr CORRECTLY");
	assert (ruif.out_instr == 32'd6) else
		$display("6 DIDNT SET INITIAL out_instr CORRECTLY");
	assert (ruif.Adv == '0) else
		$display("6 DIDNT SET INITIAL Adv CORRECTLY");

	$display("ALL TESTS FINISHED!");

	end

endmodule

program test;
endprogram
