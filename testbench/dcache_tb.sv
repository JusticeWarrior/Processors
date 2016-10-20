// interfaces
`include "datapath_cache_if.vh"
`include "cache_control_if.vh"
`include "cpu_ram_if.vh"
`include "caches_if.vh"

// types
`include "cpu_types_pkg.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ps

module dcache_tb;
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
	mydcache DUT (CLK, nRST, dcif, cif0);

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
	$display("Starting dcache Testing...");
	$display("Reset");
	nRST = 1'b0;
    	#(2*PERIOD);
    	nRST = 1'b1;
   	ccif.cif0.dREN = 0;
   	ccif.cif0.dWEN = 0;
   	#(PERIOD);

    	$display("Loading Data 0x4000 from MEMORY");
	@(posedge CLK);
    	dcif.dmemaddr = 32'h4000;
    	dcif.dmemREN = 1;
	dcif.imemREN = '0;
    	dcif.dmemWEN = '0;
 	@(posedge dcif.dhit);
	$display("Data loaded from MEMORY");
	$display("%b\n", dcif.dmemload);
	$display("Loading Data 0x4004 from MEMORY");
	@(posedge CLK);
    	dcif.dmemaddr = 32'h4004;
	@(posedge CLK);
	if (!dcif.dhit) begin
		$display("ERROR: Data not loaded from CACHE in single cycle");
		@(posedge dcif.dhit);
		@(posedge CLK);
	end
	$display("Data loaded from MEMORY");
	$display("%b\n", dcif.dmemload);
	$display("Reloading Data 0x4000 from CACHE");
	@(posedge CLK);
    	dcif.dmemaddr = 32'h4000;
	@(posedge CLK);
	if(!dcif.dhit) begin
		$display("ERROR: Data not loaded from CACHE in single cycle");
		@(posedge dcif.dhit);
		@(posedge CLK);
	end
	else begin
		$display("Data loaded from CACHE");
		$display("%b\n", dcif.dmemload);
		@(posedge CLK);
	end
	$display("Overwriting Data at Index 0");
    	dcif.dmemaddr = 32'h4100;
	@(posedge dcif.dhit);
	$display("Data loaded from MEMORY");
	$display("%b\n", dcif.dmemload);
	$display("Loading Data 0x4000 from MEMORY");
	@(posedge CLK);
    	dcif.dmemaddr = 32'h4000;
	@(posedge CLK);
	if(!dcif.dhit)
		$display("ERROR: Data not loaded from CACHE in single cycle");
		@(posedge dcif.dhit)
	else begin
 		$display("Data loaded from MEMORY");
		$display("%b\n", dcif.dmemload);
	end
	@(posedge CLK);
    	$finish;
    end
endprogram
