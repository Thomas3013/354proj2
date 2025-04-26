module alu_1bit (
    input A,
    input B,
    input Binvert,  // flip b input for subtraction
    input CarryIn,
    input [2:0] Operation,
    input Less,    // from slt handling logic
    output Result,
    output CarryOut
); // declare all the internal wires
    wire b_mux, sum, and_out, or_out, 
        nand_out, nor_out;

    // invert b when needed (for sub)
    wire not_b;
    not (not_b, B);
    assign b_mux = Binvert ? not_b : B;

    // logic functions
    
    // basic logic ops - and, or
    and (and_out, A, B);    // 000
    or  (or_out, A, B);     // 001
    
    // extra logic ops - nand, nor
    nand (nand_out, A, B);  // 011
    nor  (nor_out, A, B);   // 100

    // full adder implementation (for add/sub)
    wire axorb;  // a xor b
    xor (axorb, A, b_mux);
    xor (sum, axorb, CarryIn);  // sum bit

    // generate carry out for ripple carry
    wire tmp1, tmp2;
    and (tmp1, A, b_mux);  // and gate 1
    and (tmp2, axorb, CarryIn);  // and gate 2
    or  (CarryOut, tmp1, tmp2);


    // output mux - pick result based on operation
    assign Result = 
        (Operation == 3'b000) ? and_out :
        (Operation == 3'b001) ? or_out  :
        (Operation == 3'b010) ? sum     :
        (Operation == 3'b011) ? nand_out :
        (Operation == 3'b100) ? nor_out  :
        (Operation == 3'b110) ? sum     :
        (Operation == 3'b111) ? Less    : // slt
        sum; 
endmodule
