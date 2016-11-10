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

	logic c2c;

	coherence_control coco (CLK, nRST, ccif, c2c);

	always_comb begin
		ccif.ramstore = '0;
		ccif.ramWEN = '0;
		ccif.ramREN = '0;
		ccif.ramaddr = '0;

		ccif.iwait = '1;
		ccif.dwait = '1;
		ccif.iload[0] = ccif.ramload;
		ccif.dload[0] = ccif.ramload;
		ccif.iload[1] = ccif.ramload;
		ccif.dload[1] = ccif.ramload;

		if (ccif.dWEN[0]) begin
			ccif.ramWEN = 1'b1;
			ccif.ramaddr = ccif.daddr[0];
			ccif.ramstore = ccif.dstore[0];
			if (ccif.ramstate == ACCESS) begin
				ccif.dwait[0] = '0;
			end
		end
		else if (ccif.dWEN[1]) begin
			ccif.ramWEN = 1'b1;
			ccif.ramaddr = ccif.daddr[1];
			ccif.ramstore = ccif.dstore[1];
			if (ccif.ramstate == ACCESS) begin
				ccif.dwait[1] = '0;
			end
		end
		else if (ccif.dREN[0]) begin
			if (!c2c) begin
				ccif.ramREN = 1'b1;
				ccif.ramaddr = ccif.daddr[0];
				if (ccif.ramstate == ACCESS) begin
					ccif.dwait[0] = '0;
				end
			end
		end
		else if (ccif.dREN[1]) begin
			if (!c2c) begin
				ccif.ramREN = 1'b1;
				ccif.ramaddr = ccif.daddr[1];
				if (ccif.ramstate == ACCESS) begin
					ccif.dwait[1] = '0;
				end
			end
		end
		else if (ccif.iREN[0]) begin
			ccif.ramREN = 1'b1;
			ccif.ramaddr = ccif.iaddr[0];
			if (ccif.ramstate == ACCESS) begin
				ccif.iwait[0] = '0;
			end
		end
		else if (ccif.iREN[1]) begin
			ccif.ramREN = 1'b1;
			ccif.ramaddr = ccif.iaddr[1];
			if (ccif.ramstate == ACCESS) begin
				ccif.iwait[1] = '0;
			end
		end
	end

endmodule
