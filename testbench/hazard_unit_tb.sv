/*
	Jordan Huffaker
	jhuffak@purdue.edu

	hazard unit test bench
*/

// mapped needs this
`include "hazard_unit_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module hazard_unit_tb;

	parameter PERIOD = 10;

	logic CLK = 0, nRST;

	// test vars
	int v1 = 1;
	int v2 = 4721;
	int v3 = 25119;

	// clock
	always #(PERIOD/2) CLK++;

	// interface
	hazard_unit_if huif ();
	// test program
	test PROG ();
	// DUT
`ifndef MAPPED
	hazard_unit DUT(CLK, nRST, huif);
`else
	hazard_unit DUT(
		.\huif.wsel_ex (huif.wsel_ex),
		.\huif.rsel1_dec (huif.rsel1_dec),
		.\huif.rsel2_dec (huif.rsel2_dec),

		.\huif.stall (huif.stall),

		.\nRST (nRST),
		.\CLK (CLK)
	);
`endif

	initial begin
	nRST = 1'b0;
	huif.wsel_ex = '0;
	huif.rsel1_dec = '0;
	huif.rsel2_dec = '0;

	#PERIOD;

	nRST = 1'b1;

	#PERIOD;

	assert (huif.stall == '0) else
		$display("DIDNT SET INITIAL stall CORRECTLY");

	huif.wsel_ex = 5'd1;
	huif.rsel1_dec = 5'd1;
	huif.rsel2_dec = 5'd1;

	#PERIOD;

	assert (huif.stall == '1) else
		$display("DIDNT SET INITIAL stall CORRECTLY");

	huif.wsel_ex = 5'd1;
	huif.rsel1_dec = 5'd7;
	huif.rsel2_dec = 5'd1;

	#PERIOD;

	assert (huif.stall == '1) else
		$display("DIDNT SET INITIAL stall CORRECTLY");

	huif.wsel_ex = 5'd1;
	huif.rsel1_dec = 5'd7;
	huif.rsel2_dec = 5'd3;

	#PERIOD;

	assert (huif.stall == '0) else
		$display("DIDNT SET INITIAL stall CORRECTLY");

	huif.wsel_ex = 5'd0;
	huif.rsel1_dec = 5'd0;
	huif.rsel2_dec = 5'd1;

	#PERIOD;

	assert (huif.stall == '0) else
		$display("DIDNT SET INITIAL stall CORRECTLY");

	$display("ALL TESTS FINISHED!");

	end

endmodule

program test;
endprogram
