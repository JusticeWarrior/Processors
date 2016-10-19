// interfaces
`include "datapath_cache_if.vh"
`include "cache_control_if.vh"
`include "cpu_ram_if.vh"
`include "caches_if.vh"

// types
`include "cpu_types_pkg.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ps

module icache_tb;
	// clock period
	parameter PERIOD = 20;

	// signals
	logic CLK = 1, nRST;

	// clock
	always #(PERIOD/2) CLK++;

	//interfaces
	datapath_cache_if dcif ();
	caches_if cif0();
  	caches_if cif1();
  	cache_control_if #(.CPUS(1)) ccif (cif0, cif1);
	cpu_ram_if rif ();

	// test program
  	test PROG (CLK, nRST, ccif, rif, dcif);

	// dut
	ram #(.LAT(3)) RAM (CLK, nRST, rif);
	memory_control MC (CLK, nRST, ccif);
	icache DUT (CLK, nRST, dcif, ccif);

	assign rif.ramaddr = ccif.ramaddr;
	assign ccif.ramload = rif.ramload;
	assign rif.ramstore = ccif.ramstore;
	assign ccif.ramstate = rif.ramstate;
	assign rif.ramREN = ccif.ramREN;
	assign rif.ramWEN = ccif.ramWEN;
endmodule

program test(
	input logic CLK,
	output logic nRST,
	cache_control_if ccif,
    	cpu_ram_if  rif,
    	datapath_cache_if dcif
);

    parameter PERIOD = 20;

    import cpu_types_pkg::*;
  
    initial begin
	$display("Starting icache Testing...");
	$display("Reset");
	nRST = 1'b0;
    	#(2*PERIOD);
    	nRST = 1'b1;
   	ccif.cif0.dREN = 0;
   	ccif.cif0.dWEN = 0;
   	#(PERIOD);
    
    	$display("Loading Instruction 0x0000 from MEMORY");
	@(posedge CLK);
    	dcif.imemaddr = 32'h0000;
    	dcif.imemREN = 1;
	dcif.dmemREN = '0;
    	dcif.dmemWEN = '0;
 	@(posedge dcif.ihit);
	$display("Instruction loaded from MEMORY");
	$display("%b\n", dcif.imemload);
	$display("Loading Instruction 0x0004 from MEMORY");
	@(posedge CLK);
    	dcif.imemaddr = 32'h0004;
	@(posedge dcif.ihit);
	$display("Instruction loaded from MEMORY");
	$display("%b\n", dcif.imemload);
	$display("Reloading Instruction 0x0000 from CACHE");
	@(posedge CLK);
    	dcif.imemaddr = 32'h0000;
	if(!dcif.ihit) begin
		$display("ERROR: Instruction not loaded from CACHE in single cycle");
		@(posedge dcif.ihit);
		@(posedge CLK);
	end
	else begin
		@(posedge CLK);
		$display("Instruction loaded from CACHE");
		$display("%b\n", dcif.imemload);
	end
	$display("Overwriting Instruction at Index 0");
    	dcif.imemaddr = 32'h0100;
	@(posedge dcif.ihit);
	$display("Instruction loaded from MEMORY");
	$display("%b\n", dcif.imemload);
	$display("Loading Instruction 0x0000 from MEMORY");
	@(posedge CLK);
    	dcif.imemaddr = 32'h0000;
	@(posedge CLK);
	if(dcif.ihit)
		$display("ERROR: Instruction loaded from CACHE");
	else begin
		@(posedge dcif.ihit)
 		$display("Instruction loaded from MEMORY");
		$display("%b\n", dcif.imemload);
	end
	@(posedge CLK);
    	$finish;
    end
endprogram 