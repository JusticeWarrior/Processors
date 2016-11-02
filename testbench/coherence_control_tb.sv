// interfaces
`include "cache_control_if.vh"
`include "caches_if.vh"

// types
`include "cpu_types_pkg.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ps

module coherence_control_tb;
	// clock period
	parameter PERIOD = 20;

	// signals
	logic CLK = 1, nRST;
	logic c2c;

	// clock
	always #(PERIOD/2) CLK++;

	//interfaces
	caches_if cif0();
  	caches_if cif1();
  	cache_control_if #(.CPUS(2)) ccif (cif0, cif1);

	// dut
	test PROG (CLK, nRST, ccif);

	// dut
	`ifndef MAPPED
	coherence_control CC (CLK, nRST, c2c, ccif);
	`endif

endmodule

program test (input logic CLK, output logic nRST, cache_control_if ccif);

	import cpu_types_pkg::*;
	parameter PERIOD = 20;

	initial begin
		integer testcase;
		testcase = 0;
		#(2*PERIOD);
		nRST = 0;
		#(PERIOD);
		nRST = 1;
		cif0.ccwrite = '0;
		cif1.ccwrite = '0;
		cif0.cctrans = '0;
		cif1.cctrans = '0;
		cif0.dstore = '0;
		cif1.dstore = '0;
		cif0.daddr = '0;
		cif1.daddr = '0;
		ccif.dwait[0] = 1;
		ccif.dwait[1] = 1;

		$display("Testing LW on C0 (from memory)...");
		testcase = 1; 
		cif0.cctrans = 1;
		cif0.daddr = 32'hDEAD0000;
		#(PERIOD);
		if (!cif1.ccwait || (cif1.ccsnoopaddr != cif0.daddr))
			$display("ERROR1: C1 not waiting and/or not snooping");
		#(10*PERIOD);
		ccif.dwait[0] = 0;
		cif0.daddr = 32'hDEAD0100;
		#(PERIOD);
		ccif.dwait[0]= 1;
		if (!cif1.ccwait || (cif1.ccsnoopaddr != cif0.daddr))
			$display("ERROR2: C1 not waiting and/or not snooping");
		#(PERIOD);
		ccif.dwait[0]= 0;
		#(PERIOD);
		ccif.dwait[0] = 1;
		cif0.cctrans = 0;
		#(2*PERIOD);

		$display("Testing LW on C1 (from memory)...");
		testcase = 2; 
		cif1.cctrans = 1;
		cif1.daddr = 32'hBEEF0000;
		#(PERIOD);
		if (!cif0.ccwait || (cif0.ccsnoopaddr != cif1.daddr))
			$display("ERROR1: C0 not waiting and/or not snooping");
		#(10*PERIOD);
		ccif.dwait[1] = 0;
		cif1.daddr = 32'hBEEF0100;
		#(PERIOD);
		ccif.dwait[1]= 1;
		if (!cif0.ccwait || (cif0.ccsnoopaddr != cif1.daddr))
			$display("ERROR2: C0 not waiting and/or not snooping");
		#(PERIOD);
		ccif.dwait[1]= 0;
		#(PERIOD);
		ccif.dwait[1] = 1;
		cif1.cctrans = 0;
		#(2*PERIOD);

		$display("Testing LW on C0 (from C1)...");
		testcase = 3; 
		cif0.cctrans = 1;
		cif0.daddr = 32'hFEED0000;
		#(PERIOD);
		cif1.cctrans = 1;
		cif1.ccwrite = 1;
		if (!cif1.ccwait || (cif1.ccsnoopaddr != cif0.daddr))
			$display("ERROR1: C1 not waiting and/or not snooping");
		#(PERIOD);
		ccif.dwait[0] = 0;
		cif0.daddr = 32'hFEED0100;
		#(PERIOD);
		ccif.dwait[0]= 1;
		#(PERIOD);
		if (!cif1.ccwait || (cif1.ccsnoopaddr != cif0.daddr))
			$display("ERROR2: C1 not waiting and/or not snooping");
		#(PERIOD);
		ccif.dwait[0]= 0;
		#(PERIOD);
		ccif.dwait[0] = 1;
		cif0.cctrans = 0;
		cif1.cctrans = 0;
		#(2*PERIOD);

		$display("Testing SW on C0...");
		testcase = 4; 
		cif0.cctrans = 1;
		cif0.ccwrite = 1;
		cif0.daddr = 32'hDEAD0000;
		#(PERIOD);
		if (!cif1.ccwait || (cif1.ccsnoopaddr != cif0.daddr) || !cif1.ccinv)
			$display("ERROR1: C1 not waiting and/or not snooping and/or not invalidating");
		#(10*PERIOD);
		ccif.dwait[0] = 0;
		cif0.daddr = 32'hDEAD0100;
		#(PERIOD);
		ccif.dwait[0]= 1;
		if (!cif1.ccwait || (cif1.ccsnoopaddr != cif0.daddr) || !cif1.ccinv)
			$display("ERROR2: C1 not waiting and/or not snooping and/or not invalidating");
		#(PERIOD);
		ccif.dwait[0]= 0;
		#(PERIOD);
		ccif.dwait[0] = 1;
		cif0.cctrans = 0;
		cif0.ccwrite = 0;
		#(2*PERIOD);

		$display("Testing SW on C1...");
		testcase = 5; 
		cif1.cctrans = 1;
		cif1.ccwrite = 1;
		cif1.daddr = 32'hBEEF0000;
		#(PERIOD);
		if (!cif0.ccwait || (cif0.ccsnoopaddr != cif1.daddr) || !cif0.ccinv)
			$display("ERROR1: C0 not waiting and/or not snooping and/or not invalidating");
		#(10*PERIOD);
		ccif.dwait[1] = 0;
		cif1.daddr = 32'hBEEF0100;
		#(PERIOD);
		ccif.dwait[1]= 1;
		if (!cif0.ccwait || (cif0.ccsnoopaddr != cif1.daddr) || !cif0.ccinv)
			$display("ERROR2: C0 not waiting and/or not snooping and/or not invalidating");
		#(PERIOD);
		ccif.dwait[1]= 0;
		#(PERIOD);
		ccif.dwait[1] = 1;
		cif1.cctrans = 0;
		#(2*PERIOD);

		$finish;
	end
endprogram 