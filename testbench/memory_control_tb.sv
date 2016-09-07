/*
  Eric Villasenor
  evillase@gmail.com

  register file test bench
*/

// mapped needs this
`include "cache_control_if.vh"
`include "caches_if.vh"
`include "cpu_types_pkg.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module memory_control_tb;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // test vars
  int v1 = 1;
  int v2 = 4721;
  int v3 = 25119;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  caches_if cif0();
  caches_if_cif1();
  cache_control_if #(.CPUS(1)) ccif (cif0, cif1);
  // test program
  test PROG ();
  // DUT
  memory_control DUT(CLK, nRST, ccif);

  initial begin
    nRST = 1'b0;
	cif0.iREN = '0;
	cif0.dREN = '0;
	cif0.dWEN = '0;
	cif0.dstore = '0;
	cif0.iaddr = '0;
	cif0.daddr = '0;
	ccif.ramload = '0;
	ccif.ramstate = FREE;

	#PERIOD;

	nRST = 1'b1;

	#PERIOD;

	assert (ccif.dREN == '0) else
		$display("DIDNT SET INITIAL VALUE CORRECTLY");

	$display("ALL TESTS FINISHED!");

  end

endmodule

program test;
endprogram
