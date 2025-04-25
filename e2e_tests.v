`timescale 1ns / 1ps

// 4-bit ALU Test Bench
module testALU;
  reg signed [3:0] a;
  reg signed [3:0] b;
  reg [2:0] op;
  wire signed [3:0] result;
  wire zero, overflow;
  
  // Instantiate the ALU with corrected module name and parameter order
  alu_4bit alu (
    .A(a),
    .B(b),
    .Operation(op),
    .Result(result),
    .Zero(zero),
    .Overflow(overflow)
  );
  
  initial
    begin
     $display("op   a        b        result   zero overflow");
     $monitor ("%b %b(%d) %b(%d) %b(%d) %b    %b",op,a,a,b,b,result,result,zero,overflow);
     
     // AND: 7 & 2 = 2
     $display("AND");
     op = 3'b000;
     a = 4'b0111;
     b = 4'b0010;
     #1;
     
     // OR: 5 | 2 = 7
     $display("OR");
     op = 3'b001;
     a = 4'b0101;
     b = 4'b0010;
     #1;
     
     // NAND: ~(5 & 2) = -1
     $display("NAND");
     op = 3'b011;
     a = 4'b0101;
     b = 4'b0010;
     #1;
     
     // NOR: ~(5 | 2) = -8
     $display("NOR");
     op = 3'b100;
     a = 4'b0101;
     b = 4'b0010;
     #1;
     
     // NAND: ~(-1 & -1) = 0 (all 1s with all 1s)
     $display("NAND");
     op = 3'b011;
     a = 4'b1111;
     b = 4'b1111;
     #1;
     
     // NAND: ~(0 & -1) = -1 (all 0s with all 1s)
     $display("NAND");
     op = 3'b011;
     a = 4'b0000;
     b = 4'b1111;
     #1;
     
     // NAND: ~(0 & 0) = -1 (all 0s with all 0s)
     $display("NAND");
     op = 3'b011;
     a = 4'b0000;
     b = 4'b0000;
     #1;
     
     // NOR: ~(0 | 0) = -1 (all 0s with all 0s)
     $display("NOR");
     op = 3'b100;
     a = 4'b0000;
     b = 4'b0000;
     #1;
     
     // NOR: ~(-1 | 0) = 0 (all 1s with all 0s)
     $display("NOR");
     op = 3'b100;
     a = 4'b1111;
     b = 4'b0000;
     #1;
     
     // NOR: ~(-1 | -1) = 0 (all 1s with all 1s)
     $display("NOR");
     op = 3'b100;
     a = 4'b1111;
     b = 4'b1111;
     #1;
     
     // ADD: 5 + 1 = 6 (normal case)
     $display("ADD");
     op = 3'b010;
     a = 4'b0101;
     b = 4'b0001;
     #1;
     
     // ADD: 7 + 1 = -8 (overflow case)
     $display("ADD");
     op = 3'b010;
     a = 4'b0111;
     b = 4'b0001;
     #1;
     
     // SUB: 5 - 1 = 4 (positive numbers)
     $display("SUB");
     op = 3'b110;
     a = 4'b0101;
     b = 4'b0001;
     #1;
     
     // SUB: -1 - 1 = -2 (negative - positive)
     $display("SUB");
     op = 3'b110;
     a = 4'b1111;
     b = 4'b0001;
     #1;
     
     // SUB: -1 - (-8) = 7 (negative - negative, no overflow)
     $display("SUB");
     op = 3'b110;
     a = 4'b1111;
     b = 4'b1000;
     #1;
     
     // SUB: -2 - 7 = 7 (overflow case)
     $display("SUB");
     op = 3'b110;
     a = 4'b1110;
     b = 4'b0111;
     #1;
     
     // SLT: 5 < 1 is false (0)
     $display("SLT");
     op = 3'b111;
     a = 4'b0101;
     b = 4'b0001;
     #1;
     
     // SLT: 1 < 3 is true (1)
     $display("SLT");
     op = 3'b111;
     a = 4'b0001;
     b = 4'b0011;
     #1;
     
     // SLT: -3 < 6 is true with overflow (special case)
     $display("SLT");
     op = 3'b111;
     a = 4'b1101;
     b = 4'b0110;
     #1;
    end
endmodule

/* Expected Test Results:
op  a        b        result   zero overflow | Description
----------------------------------------------------------------------------------
000 0111( 7) 0010( 2) 0010( 2) 0    0       | AND: 7 & 2 = 2
001 0101( 5) 0010( 2) 0111( 7) 0    0       | OR: 5 | 2 = 7
011 0101( 5) 0010( 2) 1111(-1) 0    0       | NAND: ~(5 & 2) = -1
100 0101( 5) 0010( 2) 1000(-8) 0    0       | NOR: ~(5 | 2) = -8
011 1111(-1) 1111(-1) 0000( 0) 1    0       | NAND: ~(-1 & -1) = 0
011 0000( 0) 1111(-1) 1111(-1) 0    0       | NAND: ~(0 & -1) = -1
011 0000( 0) 0000( 0) 1111(-1) 0    0       | NAND: ~(0 & 0) = -1
100 0000( 0) 0000( 0) 1111(-1) 0    0       | NOR: ~(0 | 0) = -1
100 1111(-1) 0000( 0) 0000( 0) 1    0       | NOR: ~(-1 | 0) = 0
100 1111(-1) 1111(-1) 0000( 0) 1    0       | NOR: ~(-1 | -1) = 0
010 0101( 5) 0001( 1) 0110( 6) 0    0       | ADD: 5 + 1 = 6
010 0111( 7) 0001( 1) 1000(-8) 0    1       | ADD: 7 + 1 = overflow (-8)
110 0101( 5) 0001( 1) 0100( 4) 0    0       | SUB: 5 - 1 = 4
110 1111(-1) 0001( 1) 1110(-2) 0    0       | SUB: -1 - 1 = -2
110 1111(-1) 1000(-8) 0111( 7) 0    0       | SUB: -1 - (-8) = 7
110 1110(-2) 0111( 7) 0111( 7) 0    1       | SUB: -2 - 7 = overflow (7)
111 0101( 5) 0001( 1) 0000( 0) 1    0       | SLT: 5 < 1 is false (0)
111 0001( 1) 0011( 3) 0001( 1) 0    0       | SLT: 1 < 3 is true (1)
111 1101(-3) 0110( 6) 0000( 0) 1    1       | SLT: -3 < 6 is true with overflow
*/