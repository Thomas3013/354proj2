// most significant bit alu slice 
// handles overflow detection and set output for slt
module alu_1bit_slt (
    input A,
    input B,
    input Binvert,
    input CarryIn,
    input [2:0] Operation,
    input Less,  // from slt handling logic
    output Result,
    output CarryOut,
    output Set,      // for slt
    output Overflow  // overflow flag
);
    // internal signals
    wire b_mux, sum, and_out, or_out, 
         nand_out, nor_out;

    // b input handling
    wire not_b;
    not (not_b, B);   // invert b
    assign b_mux = Binvert ? not_b : B;  // mux for selecting b or ~b

    // and/or operations
    and (and_out, A, B);    // bit-wise and
    or  (or_out, A, B);     // bit-wise or
    
    
    // nand/nor operations
    nand (nand_out, A, B);  // bit-wise nand
    nor  (nor_out, A, B);   // bit-wise nor

    // addition/subtraction
    wire axorb;
    xor (axorb, A, b_mux);
    xor (sum, axorb, CarryIn);  // sum output

    // carry chain
    wire tmp1, tmp2;
    and (tmp1, A, b_mux);
    and (tmp2, axorb, CarryIn);
    or  (CarryOut, tmp1, tmp2);

    // detect overflow for signed arithmetic
    wire is_math = (Operation == 3'b010) | (Operation == 3'b110); // add or sub
    wire ov_bit;
    xor (ov_bit, CarryIn, CarryOut);   // overflow detection
    assign Overflow = is_math ? ov_bit : 1'b0;  // only signal overflow for arithmetic
    
    // slt handling - we need the sign bit after subtraction
    assign Set = sum;  // this is the sign bit of subtraction result
                       // used for "set if less than"

    // select the appropriate output based on operation code
    assign Result = 
        (Operation == 3'b000) ? and_out :
        (Operation == 3'b001) ? or_out  :
        (Operation == 3'b010) ? sum     :
        (Operation == 3'b011) ? nand_out :
        (Operation == 3'b100) ? nor_out  :
        (Operation == 3'b110) ? sum     :
        (Operation == 3'b111) ? Less     : // slt
        sum;  // default for unspecified operations
endmodule
