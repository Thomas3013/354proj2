module alu_1bit (
    input A,
    input B,
    input Binvert,  // flip B input for subtraction
    input CarryIn,
    input [2:0] Operation,
    output Result,
    output CarryOut
);
    // Declare all the internal wires
    wire b_mux, sum, and_out, or_out, 
        nand_out, nor_out;

    // Invert B when needed (for SUB)
    wire not_b;
    not (not_b, B);
    assign b_mux = Binvert ? not_b : B;

    // Logic functions
    
    // Basic logic ops - AND, OR
    and (and_out, A, B);    // 000
    or  (or_out, A, B);     // 001
    
    // Extra logic ops - NAND, NOR
    nand (nand_out, A, B);  // 011
    nor  (nor_out, A, B);   // 100

    // Full adder implementation (for ADD/SUB)
    wire axorb;  // A XOR B
    xor (axorb, A, b_mux);
    xor (sum, axorb, CarryIn);  // sum bit

    // Generate carry out for ripple carry
    wire tmp1, tmp2;
    and (tmp1, A, b_mux);  // AND gate 1
    and (tmp2, axorb, CarryIn);  // AND gate 2
    or  (CarryOut, tmp1, tmp2);

    // Output mux - pick result based on operation
    assign Result = 
        (Operation == 3'b000) ? and_out :
        (Operation == 3'b001) ? or_out  :
        (Operation == 3'b011) ? nand_out :
        (Operation == 3'b100) ? nor_out  :
        sum; // default for ADD (010) or SUB (110)
endmodule
