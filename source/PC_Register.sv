/*
	Jordan Huffaker
	jhuffak@purdue.edu

	PC register file
*/

`include "cpu_types_pkg.vh"

module PC_Register (
	input logic CLK, nRST, Adv, Halt,
	input logic [31:0] next_PC,
	output logic [31:0] PC
);
	// pc init
	parameter PC_INIT = 0;
	// import types
	import cpu_types_pkg::*;

	always_ff @(posedge CLK, negedge nRST) begin
		if (nRST == '0)
			PC <= PC_INIT;
		else if (Adv && !Halt)
			PC <= next_PC;
	end

endmodule
