// Most significant bit ALU slice 
// Handles overflow detection and Set output for SLT
module alu_1bit_msb (
    input A,
    input B,
    input Binvert,
    input CarryIn,
    input [2:0] Operation,
    input Less,  // from SLT handling logic
    output Result,
    output CarryOut,
    output Set,      // for SLT
    output Overflow  // overflow flag
);
    // internal signals
    wire b_mux, sum, and_out, or_out, 
         nand_out, nor_out;

    // B input handling
    wire not_b;
    not (not_b, B);   // invert B
    assign b_mux = Binvert ? not_b : B;  // mux for selecting B or ~B

    // AND/OR operations
    and (and_out, A, B);    // bit-wise AND
    or  (or_out, A, B);     // bit-wise OR
    
    
    // NAND/NOR operations
    nand (nand_out, A, B);  // bit-wise NAND
    nor  (nor_out, A, B);   // bit-wise NOR

    // Addition/Subtraction
    wire axorb;
    xor (axorb, A, b_mux);
    xor (sum, axorb, CarryIn);  // sum output

    // Carry chain
    wire tmp1, tmp2;
    and (tmp1, A, b_mux);
    and (tmp2, axorb, CarryIn);
    or  (CarryOut, tmp1, tmp2);

    // Detect overflow for signed arithmetic
    wire is_math = (Operation == 3'b010) | (Operation == 3'b110); // ADD or SUB
    wire ov_bit;
    xor (ov_bit, CarryIn, CarryOut);   // overflow detection
    assign Overflow = is_math ? ov_bit : 1'b0;  // only signal overflow for arithmetic
    
    // SLT handling - we need the sign bit after subtraction
    assign Set = sum;  // this is the sign bit of subtraction result
                       // used for "set if less than"

    // Select the appropriate output based on operation code
    assign Result = 
        (Operation == 3'b000) ? and_out :
        (Operation == 3'b001) ? or_out  :
        (Operation == 3'b011) ? nand_out :
        (Operation == 3'b100) ? nor_out  :
        (Operation == 3'b111) ? Less     : // SLT
        sum;  // ADD/SUB
endmodule
