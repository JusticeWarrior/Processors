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
	word_t cocodload[1:0];
	word_t memdload[1:0];

	typedef enum bit [2:0] {
			WAIT,
			READ1,
			READ2,
			WRITE1,
			WRITE2
	} StateType;

	StateType state;
	StateType nextState;

	always_ff @(posedge CLK, negedge nRST) begin
			if (nRST == 0)
					state <= WAIT;
			else
					state <= nextState;
	end

	always_comb begin
			 nextState = state;
			 casez(state)
					WAIT : begin
							if ( (ccif.cctrans[0] && !ccif.ccwrite[0]) || (ccif.cctrans[1] && !ccif.ccwrite[1]) )
									nextState = READ1;
							else if ( (ccif.cctrans[0] && ccif.ccwrite[0]) || (ccif.cctrans[1] && ccif.ccwrite[1]) )
									nextState = WRITE1;
					end

					READ1 : begin
							if ( (!ccif.dwait[0] || (ccif.cctrans[1] && ccif.ccwrite[1] && !ccif.dwait[1])) || (!ccif.dwait[1] || (ccif.cctrans[0] && ccif.ccwrite[0] && !ccif.dwait[0])) )
									nextState = READ2;
					end

					READ2 : begin
							if ( (!ccif.dwait[0] || (ccif.cctrans[1] && ccif.ccwrite[1] && !ccif.dwait[1])) || (!ccif.dwait[1] || (ccif.cctrans[0] && ccif.ccwrite[0] && !ccif.dwait[0])) )
									nextState = WAIT;
					end

					WRITE1 : begin
							if (!ccif.cctrans[0])
								nextState = WAIT;
					end

					WRITE2 : begin
							if ( (!ccif.dwait[0] && ccif.dREN[0]) || (!ccif.dwait[1] && ccif.dREN[1]) )
								nextState = WAIT;
					end

			endcase
	end

	always_comb begin
			ccif.ccwait[0] = '0;
			ccif.ccwait[1] = '0;
			ccif.ccinv[0] = '0;
			ccif.ccinv[1] = '0;
			ccif.ccsnoopaddr[0] = '0;
			ccif.ccsnoopaddr[1] = '0;
			c2c = 0;
			cocodload[0] = ccif.dstore[0];
			cocodload[1] = ccif.dstore[1];

			casez(state)
					WAIT: begin
						if (ccif.cctrans[0])
							ccif.ccwait[1] = 1;
						else if (ccif.cctrans[1])
							ccif.ccwait[0] = 1;
					end

					READ1: begin
						if (ccif.cctrans[0]) begin
							ccif.ccwait[1] = 1;
							ccif.ccsnoopaddr[1] = ccif.daddr[0];

							if (ccif.ccwrite[1]) begin
								c2c = 1;
								cocodload[0] = ccif.dstore[1];
								//ccif.dwait[0] = 0;
							end
						end else if (ccif.cctrans[1]) begin
							ccif.ccwait[0] = 1;
							ccif.ccsnoopaddr[0] = ccif.daddr[1];

							if (ccif.ccwrite[0]) begin
								c2c = 1;
								cocodload[1] = ccif.dstore[0];
								//ccif.dwait[1] = 0;
							end
						end
					end

					READ2: begin
						if (ccif.cctrans[0]) begin
							ccif.ccwait[1] = 1;
							ccif.ccsnoopaddr[1] = ccif.daddr[0];

							if (ccif.ccwrite[1]) begin
								c2c = 1;
								cocodload[0] = ccif.dstore[1];
								//ccif.dwait[0] = 0;
							end
						end else if (ccif.cctrans[1]) begin
							ccif.ccwait[0] = 1;
							ccif.ccsnoopaddr[0] = ccif.daddr[1];

							if (ccif.ccwrite[0]) begin
								c2c = 1;
								cocodload[1] = ccif.dstore[0];
								//ccif.dwait[1] = 0;
							end
						end
					end

					WRITE1: begin
						if (ccif.cctrans[0]) begin
							ccif.ccwait[1] = 1;
							ccif.ccsnoopaddr[1] = ccif.daddr[0];
							ccif.ccinv[1] = 1;
						end else if (ccif.cctrans[1]) begin
							ccif.ccwait[0] = 1;
							ccif.ccsnoopaddr[0] = ccif.daddr[1];
							ccif.ccinv[0] = 1;
						end
					end

					WRITE2: begin
						if (ccif.cctrans[0]) begin
							ccif.ccwait[1] = 1;
							ccif.ccsnoopaddr[1] = ccif.daddr[0];
							ccif.ccinv[1] = 1;
						end else if (ccif.cctrans[1]) begin
							ccif.ccwait[0] = 1;
							ccif.ccsnoopaddr[0] = ccif.daddr[1];
							ccif.ccinv[0] = 1;
						end
					end

			endcase
	end

	assign ccif.dload[0] = c2c ? cocodload[0] : memdload[0];
	assign ccif.dload[1] = c2c ? cocodload[1] : memdload[1];

	always_comb begin
		ccif.ramstore = '0;
		ccif.ramWEN = '0;
		ccif.ramREN = '0;
		ccif.ramaddr = '0;

		ccif.iwait = '1;
		ccif.dwait = '1;
		ccif.iload[0] = ccif.ramload;
		memdload[0] = ccif.ramload;
		ccif.iload[1] = ccif.ramload;
		memdload[1] = ccif.ramload;

		if (ccif.dWEN[0]) begin
			ccif.ramWEN = 1'b1;
			ccif.ramaddr = ccif.daddr[0];
			ccif.ramstore = ccif.dstore[0];
			if (ccif.ramstate == ACCESS) begin
				ccif.dwait[0] = '0;
				ccif.dwait[1] = c2c ? ccif.dwait[0] : ccif.dwait[1];
			end
		end
		else if (ccif.dWEN[1]) begin
			ccif.ramWEN = 1'b1;
			ccif.ramaddr = ccif.daddr[1];
			ccif.ramstore = ccif.dstore[1];
			if (ccif.ramstate == ACCESS) begin
				ccif.dwait[1] = '0;
				ccif.dwait[0] = c2c ? ccif.dwait[1] : ccif.dwait[0];
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
