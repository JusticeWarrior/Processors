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
	
	typedef enum bit [4:0] {IDLE, RHIT, WHIT, LOAD1, LOAD2, STORE1, STORE2, WCACHE, WCOUNT, HALT} state_t;
	state_t state, next_state;

	word_t [7:0] block1[1:0];
	word_t [7:0] block2[1:0];
	word_t next_data;
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

	logic [25:0] tag1[7:0];
	logic [25:0] tag2[7:0];
	logic [25:0] next_tag1, next_tag2;

	logic block1_flushed, block2_flushed, next_block1_flushed, next_block2_flushed;
	logic [2:0] flush_index, next_flush_index;

	dcachef_t daddr;
	assign daddr = dcachef_t'(dcif.dmemaddr);

	assign dcif.dhit = (dcif.dmemREN || dcif.dmemWEN) && (((tag1[daddr.idx] == daddr.tag) && valid1[daddr.idx]) || ((tag2[daddr.idx] == daddr.tag) && valid2[daddr.idx]));

	always_ff @ (posedge CLK, negedge nRST) begin
		if (nRST == 0) begin
			state <= IDLE;
			valid1 <= '0;
			valid2 <= '0;
			dirty1 <= '0;
			dirty2 <= '0;
			lru1 <= '1;
			lru2 <= '1;
			hitcount <= '0;
			flush_index <= '0; 
			block1_flushed <= 0;
			block2_flushed <= 0;
		end
		else begin
			state <= next_state;
			valid1[daddr.idx] <= next_valid1; 
			valid2[daddr.idx] <= next_valid2;
			dirty1[daddr.idx] <= next_dirty1;
			dirty2[daddr.idx] <= next_dirty2;
			lru1[daddr.idx] <= next_lru1 ^ !lru2[daddr.idx];
			lru2[daddr.idx] <= next_lru2 ^ !lru1[daddr.idx];
			hitcount <= next_hitcount;
			flush_index <= next_flush_index;
			block1_flushed <= next_block1_flushed;
			block2_flushed <= next_block2_flushed;
			block1[daddr.blkoff][daddr.idx] <= lru1[daddr.idx] ? next_data:block1[daddr.blkoff][daddr.idx];
			block2[daddr.blkoff][daddr.idx] <= lru2[daddr.idx] ? next_data:block2[daddr.blkoff][daddr.idx];
		end
	end

	always_comb begin
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
					next_state = LOAD2;
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
							next_state = STORE2;
						end
					end
					else begin
						next_state = STORE1;
					end
				end
				else begin
					if (!cif.dwait) begin
						next_state = STORE2;
					end
					else begin
						next_state = STORE1;
					end
				end
			end
			STORE2: begin//todo: FLUSHING
				if (dcif.halt) begin
					if (!cif.dwait) begin
						next_state = STORE1;
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
		next_flush_index = flush_index;
		next_block1_flushed = block1_flushed;
		next_block2_flushed = block2_flushed;
		dcif.flushed = 0;
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
					end
					else begin
						dcif.dmemload = block2[daddr.blkoff][daddr.idx];
					end
				end
			end
			WHIT: begin
				if(dcif.dhit) begin
					next_hitcount = hitcount + 1;
					next_data = dcif.dmemstore;
				end
			end
			LOAD1: begin
				cif.dREN = 1;
				cif.daddr = dcif.dmemaddr;
				next_data = cif.dload;
				if(lru1[daddr.idx]) begin
					next_tag1 = daddr.tag;
					next_lru1 = 0;
					next_valid1 = 1;
				end
				else begin
					next_tag2 = daddr.tag;
					next_lru2 = 0;
					next_valid2 = 1;
				end
			end
			LOAD2: begin
				cif.dREN = 1;
				cif.daddr = dcif.dmemaddr + 32'h4;
				next_data = cif.dload;
				if(lru1[daddr.idx]) begin
					next_tag1 = daddr.tag;
					next_lru1 = 0;
					next_valid1 = 1;
				end
				else begin
					next_tag2 = daddr.tag;
					next_lru2 = 0;
					next_valid2 = 1;
				end
			end	
			STORE1:	begin//todo: FLUSHING
				cif.dWEN = 1;
				if(dcif.halt) begin
					if (!block1_flushed) begin
						cif.dstore = block1[0][flush_index];
						cif.daddr = {tag1[flush_index], flush_index, '0};
					end
					else if (!block2_flushed) begin
						cif.dstore = block2[0][flush_index];
						cif.daddr = {tag2[flush_index], flush_index, '0};
					end
					else begin
						cif.dWEN = 0;
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
			STORE2: begin//todo: FLUSHING
				cif.dWEN = 1;
				if(dcif.halt) begin
					next_flush_index = flush_index + 1;
					if (flush_index == 'd7 && !block1_flushed) begin
						cif.dstore = block1[1][flush_index];
						cif.daddr = {tag1[flush_index], flush_index, '0};
						next_block1_flushed = 1;
					end
					else if (flush_index == 'd7 && !block2_flushed) begin
						cif.dstore = block2[1][flush_index];
						cif.daddr = {tag2[flush_index], flush_index, '0};
						next_block2_flushed = 1;
					end
					else begin
						cif.dWEN = 0;
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
			WCACHE: begin
				next_data = dcif.dmemstore; 
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