// interface include
`include "datapath_cache_if.vh"
`include "caches_if.vh"

// memory types
`include "cpu_types_pkg.vh"
//todo: flushing - write dirty entries to memory and invalidate
module mydcache (
	input logic CLK, nRST,
	datapath_cache_if dcif,
	caches_if cif
);
	import cpu_types_pkg::*;

	typedef enum bit [4:0] {IDLE, RHIT, WHIT, LOAD1, LOAD2, STORE1, STORE2, WCACHE, WCOUNT, HALT, WAIT1, WAIT2} state_t;
	state_t state, next_state;

	word_t [7:0] block1[1:0];
	word_t [7:0] block2[1:0];
	word_t next_data11, next_data12, next_data21, next_data22;
	//word_t b1w1[7:0], b1w2[7:0], b2w1[7:0], b2w2[7:0];

	word_t hitcount, next_hitcount;

	logic [7:0] valid1;
	logic [7:0] valid2;
	logic next_valid1, next_valid2;
	logic [7:0] dirty1;
	logic [7:0] dirty2;
	logic next_dirty1, next_dirty2;
	logic [7:0] lru1;
	logic [7:0] lru2;
	logic next_lru1, next_lru2;

	logic force_write1, force_write2;

	logic [25:0] tag1[7:0];
	logic [25:0] tag2[7:0];
	logic [25:0] next_tag1, next_tag2;

	logic block1_flushed, block2_flushed, next_block1_flushed, next_block2_flushed;
	logic [2:0] flush_index, next_flush_index;

	dcachef_t daddr;
	assign daddr = dcachef_t'(dcif.dmemaddr);

	assign dcif.dhit = (((tag1[daddr.idx] == daddr.tag) && valid1[daddr.idx]) || ((tag2[daddr.idx] == daddr.tag) && valid2[daddr.idx]));

	always_ff @ (posedge CLK, negedge nRST) begin
		if (nRST == 0) begin
			state <= IDLE;
			valid1 <= '0;
			valid2 <= '0;
			dirty1 <= '0;
			dirty2 <= '0;
			lru1 <= '1;
			lru2 <= '0;
			hitcount <= '0;
			flush_index <= '0;
			block1_flushed <= 0;
			block2_flushed <= 0;
		end
		else begin
			state <= next_state;
			tag1[daddr.idx] <= next_tag1;
			tag2[daddr.idx] <= next_tag2;
			valid1[daddr.idx] <= next_valid1;
			valid2[daddr.idx] <= next_valid2;
			dirty1[daddr.idx] <= next_dirty1;
			dirty2[daddr.idx] <= next_dirty2;
			lru1[daddr.idx] <= next_lru1;
			lru2[daddr.idx] <= next_lru2;
			hitcount <= next_hitcount;
			flush_index <= next_flush_index;
			block1_flushed <= next_block1_flushed;
			block2_flushed <= next_block2_flushed;
			block1[0][daddr.idx] <= next_data11;
			block1[1][daddr.idx] <= next_data12;
			block2[0][daddr.idx] <= next_data21;
			block2[1][daddr.idx] <= next_data22;
		end
	end

	always_comb begin
		next_flush_index = flush_index;
		casez (state)
			IDLE: begin
				if (dcif.halt) begin
					next_state = STORE1;
				end
				else if (dcif.dmemREN) begin
					next_state = RHIT;
				end
				else if (dcif.dmemWEN) begin
					next_state = WHIT;
				end
				else begin
					next_state = IDLE;
				end
			end
			RHIT: begin
				if (dcif.dhit) begin
					next_state = IDLE;
				end
				else if (!dcif.dhit) begin
					next_state = LOAD1;
				end
				else begin
					next_state = RHIT;
				end
			end
			WHIT: begin
				if (dcif.dhit) begin
					next_state = IDLE;
				end
				else if (!dcif.dhit && (dirty1[daddr.idx] || dirty2[daddr.idx])) begin
					next_state = STORE1;
				end
				else if (!dcif.dhit && (!dirty1[daddr.idx] && !dirty2[daddr.idx])) begin
					next_state = WCACHE;
				end
				else begin
					next_state = WHIT;
				end
			end
			LOAD1: begin
				if (!cif.dwait) begin
					if (dcif.dmemWEN) begin
						next_state = IDLE;
					end
					else begin
						next_state = LOAD2;
					end
				end
				else begin
					next_state = LOAD1;
				end
			end
			LOAD2: begin
				if (!cif.dwait) begin
					next_state = IDLE;
				end
				else begin
					next_state = LOAD2;
				end
			end
			STORE1: begin//todo: FLUSHING
				if (dcif.halt) begin
					if (!cif.dwait) begin
						if(block1_flushed && block2_flushed) begin
							next_state = WCOUNT;
						end
						else begin
							next_state = WAIT1;
						end
					end
					else begin
						next_state = STORE1;
					end
				end
				else begin
					if (!cif.dwait) begin
						next_state = WAIT1;
					end
					else begin
						next_state = STORE1;
					end
				end
			end
			WAIT1: begin//todo: FLUSHING
				next_state = STORE2;
			end
			STORE2: begin//todo: FLUSHING
				if (dcif.halt) begin
					if (!cif.dwait) begin
						next_state = WAIT2;
						next_flush_index = flush_index + 1;
					end
					else begin
						next_state = STORE2;
					end
				end
				else begin
					if (!cif.dwait) begin
						next_state = WCACHE;
					end
					else begin
						next_state = STORE2;
					end
				end
			end
			WAIT2: begin//todo: FLUSHING
				next_state = STORE1;
			end
			WCACHE: begin
				if (daddr.blkoff) begin
					next_state = LOAD1;
				end
				else begin
					next_state = LOAD2;
				end
			end
			WCOUNT: begin
				if (!cif.dwait) begin
					next_state = HALT;
				end
				else begin
					next_state = WCOUNT;
				end
			end
			HALT: begin
				next_state = HALT;
			end
		endcase
	end

	always_comb begin
		next_valid1 = valid1[daddr.idx];
		next_valid2 = valid2[daddr.idx];
		next_dirty1 = dirty1[daddr.idx];
		next_dirty2 = dirty2[daddr.idx];
		next_lru1 = lru1[daddr.idx];
		next_lru2 = lru2[daddr.idx];
		next_tag1 = tag1[daddr.idx];
		next_tag2 =  tag2[daddr.idx];
		next_hitcount = hitcount;
		next_block1_flushed = block1_flushed;
		next_block2_flushed = block2_flushed;
		dcif.flushed = 0;
		next_data11 = block1[0][daddr.idx];
		next_data12 = block1[1][daddr.idx];
		next_data21 = block2[0][daddr.idx];
		next_data22 = block2[1][daddr.idx];
		casez(state)
			IDLE: begin
				dcif.dmemload = '0;
				cif.dstore = '0;
				cif.dREN = 0;
				cif.dWEN = 0;
				cif.daddr = '0;
			end
			RHIT: begin
				if(dcif.dhit) begin
					next_hitcount = hitcount + 1;
					if (tag1[daddr.idx] == daddr.tag) begin
						dcif.dmemload = block1[daddr.blkoff][daddr.idx];
						next_lru1 = 0;
						next_lru2 = 1;
					end
					else begin
						dcif.dmemload = block2[daddr.blkoff][daddr.idx];
						next_lru1 = 1;
						next_lru2 = 0;
					end
				end
			end
			WHIT: begin
				if(dcif.dhit) begin
					next_hitcount = hitcount + 1;
					if ((tag1[daddr.idx] == daddr.tag) && valid1[daddr.idx]) begin
						next_lru1 = 0;
						next_lru2 = 1;
						if(!daddr.blkoff)
							next_data11 = dcif.dmemstore;
						else
							next_data12 = dcif.dmemstore;
					end
					else begin
						next_lru1 = 1;
						next_lru2 = 0;
						if(!daddr.blkoff)
							next_data21 = dcif.dmemstore;
						else
							next_data22 = dcif.dmemstore;
					end
				end
			end
			LOAD1: begin
				cif.dREN = 1;
				cif.dWEN = 0;
				if(!daddr.blkoff) begin
					cif.daddr = dcif.dmemaddr;
					dcif.dmemload = cif.dload;
				end
				else begin
					cif.daddr = dcif.dmemaddr - 4;
				end
				if(lru1[daddr.idx]) begin
					next_tag1 = daddr.tag;
					if (!cif.dwait) begin
						next_data11 = cif.dload;
						if (dcif.dmemWEN) begin
							next_valid1 = 1;
							next_lru1 = 0;
							next_lru2 = 1;
						end
						else
							next_valid1 = 0;
					end
				end
				else begin
					next_tag2 = daddr.tag;
					if (!cif.dwait) begin
						next_data21 = cif.dload;
						if (dcif.dmemWEN) begin
							next_valid2 = 1;
							next_lru1 = 1;
							next_lru2 = 0;
						end
						else
							next_valid2 = 0;
					end
				end
			end
			LOAD2: begin
				cif.dREN = 1;
				cif.dWEN = 0;
				if(!daddr.blkoff) begin
					cif.daddr = dcif.dmemaddr + 4;
				end
				else begin
					cif.daddr = dcif.dmemaddr;
					dcif.dmemload = cif.dload;
				end
				if(lru1[daddr.idx]) begin
					next_tag1 = daddr.tag;
					if (!cif.dwait) begin
						next_lru1 = 0;
						next_lru2 = 1;
						next_data12 = cif.dload;
						next_valid1 = 1;
					end
				end
				else begin
					next_tag2 = daddr.tag;
					if (!cif.dwait) begin
						next_lru1 = 1;
						next_lru2 = 0;
						next_data22 = cif.dload;
						next_valid2 = 1;
					end
				end
			end
			STORE1:	begin//todo: FLUSHING
				cif.dWEN = 1;
				cif.dREN = 0;
				if(dcif.halt) begin
					if (!block1_flushed) begin
						if(valid1[flush_index] && dirty1[flush_index]) begin
							cif.dstore = block1[0][flush_index];
							cif.daddr = {tag1[flush_index], flush_index, '0};
						end
					end
					else if (!block2_flushed) begin
						if(valid2[flush_index] && dirty2[flush_index]) begin
						next_lru1 = 1;
						next_lru2 = 0;
							cif.dstore = block2[0][flush_index];
							cif.daddr = {tag2[flush_index], flush_index, '0};
						end
					end
				end
				else begin
					if(lru1[daddr.idx]) begin
						cif.dstore = block1[0][daddr.idx];
						cif.daddr = {tag1[daddr.idx], daddr.idx, '0};
					end
					else begin
						cif.dstore = block2[0][daddr.idx];
						cif.daddr = {tag2[daddr.idx], daddr.idx, '0};
					end
				end
			end
			WAIT1: begin
				cif.dWEN = 0;
			end
			STORE2: begin//todo: FLUSHING
				cif.dWEN = 1;
				cif.dREN = 0;
				if(dcif.halt) begin
					if (!block1_flushed) begin
						if(valid1[flush_index] && dirty1[flush_index]) begin
							cif.dstore = block1[1][flush_index];
							cif.daddr = {tag1[flush_index], flush_index, '0};
						end
						if (!cif.dwait && (flush_index == 7)) begin
							next_block1_flushed = 1;
						end
					end
					else if (!block2_flushed) begin
						if(valid2[flush_index] && dirty2[flush_index]) begin
							cif.dstore = block2[1][flush_index];
							cif.daddr = {tag2[flush_index], flush_index, '0};
						end
						if (!cif.dwait && (flush_index == 7)) begin
							next_block2_flushed = 1;
						end
					end
				end
				else begin
					if(lru1[daddr.idx]) begin
						cif.dstore = block1[1][daddr.idx];
						cif.daddr = {tag1[daddr.idx], daddr.idx, '0} + 32'h4;
					end
					else begin
						cif.dstore = block2[1][daddr.idx];
						cif.daddr = {tag1[daddr.idx], daddr.idx, '0} + 32'h4;
					end
				end
			end
			WAIT2: begin
				cif.dWEN = 0;
			end
			WCACHE: begin
				cif.dREN = 0;
				cif.dWEN = 0;
				if (lru1[daddr.idx]) begin
					next_dirty1 = '1;
					if(!daddr.blkoff)
						next_data11 = dcif.dmemstore;
					else
						next_data12 = dcif.dmemstore;
				end
				else begin
					next_dirty2 = '1;
					if(!daddr.blkoff)
						next_data21 = dcif.dmemstore;
					else
						next_data22 = dcif.dmemstore;
				end

			end
			WCOUNT: begin
				cif.dWEN = 1;
				cif.dREN = 0;
				cif.daddr = 32'h3100;
				cif.dstore = hitcount;
			end
			HALT: begin
				cif.dWEN = 0;
				cif.dREN = 0;
				cif.daddr = 32'h3100;
				cif.dstore = hitcount;
				dcif.flushed = 1;
			end
		endcase
	end
endmodule
