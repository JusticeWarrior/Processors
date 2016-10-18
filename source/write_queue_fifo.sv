/*
	Jordan Huffaker
	jhuffak@purdue.edu


	write queue fifo
*/

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

	reg [2:0] fifo_counter, read_ptr, write_ptr, next_read_ptr, next_write_ptr;

	/*
		module write_queue_ram
		(
				output reg [63:0] q,
				input [63:0] ddata,
				input [2:0] write_address, read_address,
				input we, clk
		);
	*/

	write_queue_ram ID (
						.q(r_data),
						.ddata(w_data),
						.write_address(write_ptr),
						.read_address(next_read_ptr),
						.we(write),
						.clk(clk)
						);

	always_comb
	begin
		if (fifo_counter == 3'd0)
			wempty = 1'b1;
		else
			wempty = 1'b0;

		if (fifo_counter == 3'd8)
			full = 1'b1;
		else
			full = 1'b0;

		if (!full && write)
			next_write_ptr = write_ptr + 1;
		else
			next_write_ptr = write_ptr;

		if (!wempty && read)
			next_read_ptr = read_ptr + 1;
		else
			next_read_ptr = read_ptr;
	end

	always_ff @ (negedge reset, posedge clk)
	begin
		if (reset == 1'b0)
		begin
			fifo_counter <= '0;
		end
		else if ((!full && write) && (!wempty && read))
			fifo_counter <= fifo_counter;
		else if (!full && write)
			fifo_counter <= fifo_counter + 1;
		else if (!wempty && read)
			fifo_counter <= fifo_counter - 1;
		else
			fifo_counter <= fifo_counter;
	end

	always_ff @ (negedge reset, posedge clk)
	begin
		if (reset == 1'b0)
		begin
			write_ptr <= 3'd0;
			read_ptr <= 3'd0;
		end
		else
		begin
			write_ptr <= next_write_ptr;
			read_ptr <= next_read_ptr;
		end
	end

endmodule
