/*
  Eric Villasenor
  evillase@gmail.com

  register file test bench
*/

// mapped needs this
`include "ALU_if.vh"
`include "cpu_types_pkg.vh"

// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module ALU_tb;

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
  ALU_if A ();
  // test program
  test PROG ();
  // DUT
`ifndef MAPPED
  ALU DUT(A);
`else
  ALU DUT(
    .\A.ALUOP (A.ALUOP),
    .\A.portA (A.portA),
    .\A.portB (A.portB),
    .\A.portOut (A.portOut),
    .\A.neg (A.neg),
    .\A.overflow (A.overflow),
    .\A.zero (A.zero)
  );
`endif

  initial begin
	A.ALUOP = ALU_SLL;
	A.portA = '0;
	A.portB = '0;

	#PERIOD;

	A.ALUOP = ALU_SLL;
	A.portA = 32'd4294967295;
	A.portB = 32'd2;

	#PERIOD;

	assert (A.portOut == 32'd4294967292) else
		$display("Shift Left test failed, wrong portOut");
	assert (A.neg == 1'b1) else
		$display("Shift Left test failed, wrong neg");
	assert (A.zero == 1'b0) else
		$display("Shift Left test failed, wrong zero");
	assert (A.overflow == 1'b0) else
		$display("Shift Left test failed, wrong overflow");

	A.ALUOP = ALU_SRL;
	A.portA = 32'd4294967295;
	A.portB = 32'd2;

	#PERIOD;

	assert (A.portOut == 32'd1073741823) else
		$display("Shift Right test failed, wrong portOut");
	assert (A.neg == 1'b0) else
		$display("Shift Right test failed, wrong neg");
	assert (A.zero == 1'b0) else
		$display("Shift Right test failed, wrong zero");
	assert (A.overflow == 1'b0) else
		$display("Shift Right test failed, wrong overflow");

	A.ALUOP = ALU_ADD;
	A.portA = 32'd2147483647;
	A.portB = 32'd1;

	#PERIOD;

	assert (A.portOut == 32'd2147483648) else
		$display("Add test failed, wrong portOut");
	assert (A.neg == 1'b1) else
		$display("Add test failed, wrong neg");
	assert (A.zero == 1'b0) else
		$display("Add test failed, wrong zero");
	assert (A.overflow == 1'b1) else
		$display("Add test failed, wrong overflow");

	A.ALUOP = ALU_SUB;
	A.portA = 32'd0;
	A.portB = 32'd1;

	#PERIOD;

	assert (A.portOut == 32'd4294967295) else
		$display("Sub test failed, wrong portOut");
	assert (A.neg == 1'b1) else
		$display("Sub test failed, wrong neg");
	assert (A.zero == 1'b0) else
		$display("Sub test failed, wrong zero");
	assert (A.overflow == 1'b1) else
		$display("Sub test failed, wrong overflow");

	A.ALUOP = ALU_AND;
	A.portA = 32'd4294967295;
	A.portB = 32'd0;

	#PERIOD;

	assert (A.portOut == 32'd0) else
		$display("And test failed, wrong portOut");
	assert (A.neg == 1'b0) else
		$display("And test failed, wrong neg");
	assert (A.zero == 1'b1) else
		$display("And test failed, wrong zero");
	assert (A.overflow == 1'b0) else
		$display("And test failed, wrong overflow");

	A.ALUOP = ALU_OR;
	A.portA = 32'd4294967295;
	A.portB = 32'd0;

	#PERIOD;

	assert (A.portOut == 32'd4294967295) else
		$display("Or test failed, wrong portOut");
	assert (A.neg == 1'b1) else
		$display("Or test failed, wrong neg");
	assert (A.zero == 1'b0) else
		$display("Or test failed, wrong zero");
	assert (A.overflow == 1'b0) else
		$display("Or test failed, wrong overflow");

	A.ALUOP = ALU_XOR;
	A.portA = 32'd4294967294;
	A.portB = 32'd4294967295;

	#PERIOD;

	assert (A.portOut == 32'd1) else
		$display("Xor test failed, wrong portOut");
	assert (A.neg == 1'b0) else
		$display("Xor test failed, wrong neg");
	assert (A.zero == 1'b0) else
		$display("Xor test failed, wrong zero");
	assert (A.overflow == 1'b0) else
		$display("Xor test failed, wrong overflow");

	A.ALUOP = ALU_NOR;
	A.portA = 32'd4294967295;
	A.portB = 32'd0;

	#PERIOD;

	assert (A.portOut == 32'd0) else
		$display("Nor test failed, wrong portOut");
	assert (A.neg == 1'b0) else
		$display("Nor test failed, wrong neg");
	assert (A.zero == 1'b1) else
		$display("Nor test failed, wrong zero");
	assert (A.overflow == 1'b0) else
		$display("Nor test failed, wrong overflow");

	A.ALUOP = ALU_SLT;
	A.portA = 32'd4294967294;
	A.portB = 32'd0;

	#PERIOD;

	assert (A.portOut == 32'd1) else
		$display("Less than test failed, wrong portOut");
	assert (A.neg == 1'b0) else
		$display("Less than test failed, wrong neg");
	assert (A.zero == 1'b0) else
		$display("Less than test failed, wrong zero");
	assert (A.overflow == 1'b0) else
		$display("Less than test failed, wrong overflow");

	A.ALUOP = ALU_SLTU;
	A.portA = 32'd4294967294;
	A.portB = 32'd0;

	#PERIOD;

	assert (A.portOut == 32'd0) else
		$display("Less than unsigned test failed, wrong portOut");
	assert (A.neg == 1'b0) else
		$display("Less than unsigned test failed, wrong neg");
	assert (A.zero == 1'b1) else
		$display("Less than unsigned test failed, wrong zero");
	assert (A.overflow == 1'b0) else
		$display("Less than unsigned test failed, wrong overflow");

  end

endmodule

program test;
endprogram
