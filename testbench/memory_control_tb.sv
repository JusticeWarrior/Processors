/*
  Eric Villasenor
  evillase@gmail.com

  register file test bench
*/

// mapped needs this
`include "cache_control_if.vh"
`include "caches_if.vh"
`include "cpu_types_pkg.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module memory_control_tb;

  import cpu_types_pkg::*;

  parameter PERIOD = 10;

  logic CLK = 0, nRST;

  // test vars
  int v1 = 1;
  int v2 = 4721;
  int v3 = 25119;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  caches_if cif0();
  caches_if cif1();
  cache_control_if #(.CPUS(1)) ccif (cif0, cif1);
  // test program
  test PROG (CLK,nRST,ccif);
  // DUT
  memory_control DUT(CLK, nRST, ccif);


endmodule

program test(input logic CLK, output logic nRST, cache_control_if.cc ccif);
  import cpu_types_pkg::*;

  parameter PERIOD = 10;

  initial begin
    nRST = 1'b0;
	cif0.iREN = '0;
	cif0.dREN = '0;
	cif0.dWEN = '0;
	cif0.dstore = '0;
	cif0.iaddr = '0;
	cif0.daddr = '0;
	ccif.ramload = '0;
	ccif.ramstate = FREE;

	#PERIOD;

	nRST = 1'b1;

	#PERIOD;

	assert (cif0.iwait == '1) else
		$display("1 DIDNT SET iwait VALUE CORRECTLY");
	assert (cif0.dwait == '1) else
		$display("1 DIDNT SET dwait VALUE CORRECTLY");

	cif0.dREN = '1;
	ccif.ramstate = BUSY;
	cif0.daddr = 32'd5;

	#PERIOD;

	assert (cif0.iwait == '1) else
		$display("2 DIDNT SET iwait VALUE CORRECTLY");
	assert (cif0.dwait == '1) else
		$display("2 DIDNT SET dwait VALUE CORRECTLY");

	#PERIOD;

	assert (cif0.iwait == '1) else
		$display("3 DIDNT SET iwait VALUE CORRECTLY");
	assert (cif0.dwait == '1) else
		$display("3 DIDNT SET dwait VALUE CORRECTLY");

	ccif.ramstate = ACCESS;
	ccif.ramload = 32'd1;

	#PERIOD;

	assert (cif0.iwait == '1) else
		$display("4 DIDNT SET iwait VALUE CORRECTLY");
	assert (cif0.dwait == '0) else
		$display("4 DIDNT SET dwait VALUE CORRECTLY");
	assert (ccif.dload == 32'd1) else
		$display("4 DIDNT SET dload VALUE CORRECTLY");

	ccif.ramstate = FREE;
	cif0.dREN = '0;

	#PERIOD;

	assert (cif0.iwait == '1) else
		$display("5 DIDNT SET iwait VALUE CORRECTLY");
	assert (cif0.dwait == '1) else
		$display("5 DIDNT SET dwait VALUE CORRECTLY");

	cif0.dWEN = '1;
	cif0.iREN = '1;
	cif0.iaddr = 32'd6;
	ccif.ramstate = BUSY;
	cif0.daddr = 32'd5;
	cif0.dstore = 32'd1;

	#PERIOD;

	assert (cif0.iwait == '1) else
		$display("6 DIDNT SET iwait VALUE CORRECTLY");
	assert (cif0.dwait == '1) else
		$display("6 DIDNT SET dwait VALUE CORRECTLY");
	assert (ccif.ramstore == 32'd1) else
		$display("6 DIDNT SET ramstore VALUE CORRECTLY");

	ccif.ramstate = ACCESS;

	#PERIOD;

	assert (cif0.iwait == '1) else
		$display("7 DIDNT SET iwait VALUE CORRECTLY");
	assert (cif0.dwait == '0) else
		$display("7 DIDNT SET dwait VALUE CORRECTLY");

	cif0.dWEN = '0;
	ccif.ramload = 32'd7;

	#PERIOD;

	assert (cif0.iwait == '0) else
		$display("8 DIDNT SET iwait VALUE CORRECTLY");
	assert (cif0.dwait == '1) else
		$display("8 DIDNT SET dwait VALUE CORRECTLY");
	assert (cif0.iload == 32'd7) else
		$display("8 DIDNT SET iload VALUE CORRECTLY");

	ccif.ramstate = FREE;
	cif0.iREN = '0;

	#PERIOD;

	assert (cif0.iwait == '1) else
		$display("9 DIDNT SET iwait VALUE CORRECTLY");
	assert (cif0.dwait == '1) else
		$display("9 DIDNT SET dwait VALUE CORRECTLY");

	$display("ALL TESTS FINISHED!");
	dump_memory();

  end


  task automatic dump_memory();
    string filename = "memcpu.hex";
    int memfd;

    //syif.tbCTRL = 1;
    ccif.ramaddr = 0;
    ccif.ramWEN = 0;
    ccif.ramREN = 0;

    memfd = $fopen(filename,"w");
    if (memfd)
      $display("Starting memory dump.");
    else
      begin $display("Failed to open %s.",filename); $finish; end

    for (int unsigned i = 0; memfd && i < 16384; i++)
    begin
      int chksum = 0;
      bit [7:0][7:0] values;
      string ihex;

      ccif.ramaddr = i << 2;
      ccif.ramREN = 1;
      repeat (4) @(posedge CLK);
      if (ccif.ramload === 0)
        continue;
      values = {8'h04,16'(i),8'h00,ccif.ramload};
      foreach (values[j])
        chksum += values[j];
      chksum = 16'h100 - chksum;
      ihex = $sformatf(":04%h00%h%h",16'(i),ccif.ramload,8'(chksum));
      $fdisplay(memfd,"%s",ihex.toupper());
    end //for
    if (memfd)
    begin
      //syif.tbCTRL = 0;
      ccif.ramREN = 0;
      $fdisplay(memfd,":00000001FF");
      $fclose(memfd);
      $display("Finished memory dump.");
    end
  endtask
endprogram
