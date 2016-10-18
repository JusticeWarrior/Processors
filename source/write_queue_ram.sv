/*
	Jordan Huffaker
	jhuffak@purdue.edu


	write queue ram
*/

module write_queue_ram
(
	    output reg [63:0] q,
		input [63:0] ddata,
		input [2:0] write_address, read_address,
		input we, clk
);
	reg [63:0] mem [2:0];
	always @ (posedge clk) begin
		if (we)
			mem[write_address] = ddata;
		q = mem[read_address]; // q does get d in this clock cycle
	end
endmodule
