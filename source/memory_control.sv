/*
	Eric Villasenor
	evillase@gmail.com

	this block is the coherence protocol
	and artibtration for ram
*/

// interface include
`include "cache_control_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module memory_control (
	input CLK, nRST,
	cache_control_if.cc ccif
);
	// type import
	import cpu_types_pkg::*;

	// number of cpus for cc
	parameter CPUS = 2;

	always_comb begin
		ccif.ramstore = '0;
		ccif.ramWEN = '0;
		ccif.ramREN = '0;
		ccif.ramaddr = '0;

		ccif.iwait = '0;
		ccif.dwait = '0;
		ccif.iload = ccif.ramload;
		ccif.dload = ccif.ramload;

		if (ccif.ramstate != FREE || ccif.ramstate != ERROR) begin
			ccif.dwait = 1'b1;
			ccif.rwait = 1'b1;
		end

		if (ccif.dWEN) begin
			if (ccif.ramstate != FREE || ccif.ramstate != ERROR)
				ccif.dwait = 1'b1;
			else
				ccif.ramWEN = 1'b1;
			ccif.ramaddr = ccif.daddr;
			ccif.ramstore = ccif.dstore;
		end
		else if (ccif.dREN) begin
			if (ccif.ramstate != FREE || ccif.ramstate != ERROR) begin
				ccif.dwait = 1'b1;
			end
			ccif.ramREN = ccif.dREN;
			ccif.ramaddr = ccif.daddr;
			ccif.ramstore = ccif.dstore;
		end
		else if (ccif.)
	end

endmodule
