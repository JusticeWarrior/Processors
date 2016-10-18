/*
	Jordan Huffaker
	jhuffak@purdue.edu

	write queue code
*/

// interface
`include "write_queue_if.vh"

module write_queue (
	input wire clk,
	input wire n_rst,
	write_queue_if.wq W
);

	/*
		module write_queue_fifo
		(
			input wire clk,
			input wire reset,
			input wire write,
			input wire read,
			input wire [63:0] w_data,
			output wire [63:0] r_data,
			output reg wempty,
			output reg full
		);
	*/


	write_queue_fifo FIFO (
						.clk(clk),
						.reset(n_rst),
						.write(W.ddirtyWEN),
						.read(!W.dwait && !W.dmissREN),
						.w_data({ W.ddirtyaddr, W.ddirtydata }),
						.r_data({ W.wdaddr, W.dstore }),
						.wempty(W.wempty),
						.full(W.full)
						);

	assign W.dqueueWEN = !W.dmissREN && !W.wempty;

endmodule
