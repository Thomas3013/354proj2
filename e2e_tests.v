// Test Module 
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
     op = 3'b000; a = 4'b0111; b = 4'b0010;  // AND
     #1 op = 3'b001; a = 4'b0101; b = 4'b0010;  // OR
     #1 op = 3'b010; a = 4'b0101; b = 4'b0001;  // ADD
     #1 op = 3'b010; a = 4'b0111; b = 4'b0001;  // ADD overflow (8+1=-8)
     #1 op = 3'b110; a = 4'b0101; b = 4'b0001;  // SUB
     #1 op = 3'b110; a = 4'b1111; b = 4'b0001;  // SUB
     #1 op = 3'b110; a = 4'b1111; b = 4'b1000;  // SUB no overflow (-1-(-8)=7)
     #1 op = 3'b110; a = 4'b1110; b = 4'b0111;  // SUB overflow (-2-7=7)
     #1 op = 3'b111; a = 4'b0101; b = 4'b0001;  // SLT
     #1 op = 3'b111; a = 4'b0001; b = 4'b0011;  // SLT
     #1 op = 3'b111; a = 4'b1101; b = 4'b0110;  // SLT overflow (-3-6=7 => SLT=0)
    end
endmodule

/* Test Results from Gate-level Implementation
op  a        b        result   zero overflow
000 0111( 7) 0010( 2) 0010( 2) 0    0
001 0101( 5) 0010( 2) 0111( 7) 0    0
010 0101( 5) 0001( 1) 0110( 6) 0    0
010 0111( 7) 0001( 1) 1000(-8) 0    1
110 0101( 5) 0001( 1) 0100( 4) 0    0
110 1111(-1) 0001( 1) 1110(-2) 0    0
110 1111(-1) 1000(-8) 0111( 7) 0    0
110 1110(-2) 0111( 7) 0111( 7) 0    1
111 0101( 5) 0001( 1) 0000( 0) 1    0
111 0001( 1) 0011( 3) 0001( 1) 0    0
111 1101(-3) 0110( 6) 0000( 0) 1    1
*/