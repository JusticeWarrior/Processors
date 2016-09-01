/*
  Eric Villasenor
  evillase@gmail.com

  register file test bench
*/

// mapped needs this
`include "register_file_if.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module register_file_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // test vars
  int v1 = 1;
  int v2 = 4721;
  int v3 = 25119;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  register_file_if rfif ();
  // test program
  test PROG ();
  // DUT
`ifndef MAPPED
  register_file DUT(CLK, nRST, rfif);
`else
  register_file DUT(
    .\rfif.rdat2 (rfif.rdat2),
    .\rfif.rdat1 (rfif.rdat1),
    .\rfif.wdat (rfif.wdat),
    .\rfif.rsel2 (rfif.rsel2),
    .\rfif.rsel1 (rfif.rsel1),
    .\rfif.wsel (rfif.wsel),
    .\rfif.WEN (rfif.WEN),
    .\nRST (nRST),
    .\CLK (CLK)
  );
`endif

  initial begin
    nRST = 1'b0;
	rfif.rsel1 = '0;
	rfif.rsel2 = '0;
	rfif.wsel = '0;
	rfif.wdat = '0;
	rfif.WEN = '0;

	#PERIOD;

	nRST = 1'b1;
    rfif.wsel = 'd1;
	rfif.wdat = 32'd5;
	rfif.WEN = 1'b1;
	rfif.rsel1 = 'd1;

	#PERIOD;

	assert (rfif.rdat1 == 32'd5) else
		$display("DIDNT SET INITIAL VALUE CORRECTLY");
	rfif.WEN = 1'b0;

	#PERIOD;

	nRST = 1'b0;

	#PERIOD;

	nRST = 1'b1;
	rfif.rsel1 = 'd1;

	assert (rfif.rdat1 == '0) else
		$display("DIDNT RESET CORRECTLY");

	#PERIOD;

	rfif.wsel = '0;
	rfif.WEN = 1'b1;

	#PERIOD;

	rfif.WEN = '0;
	assert (rfif.rdat1 == '0) else
		$display("WROTE TO REG1 INCORRECTLY");

	$display("ALL TESTS FINISHED!");

  end

endmodule

program test;
endprogram
