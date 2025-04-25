module alu_1bit_msb (
    input A,
    input B,
    input Binvert,
    input CarryIn,
    input [2:0] Operation,
    input Less,
    output Result,
    output CarryOut,
    output Set,
    output Overflow
);
    wire b_mux, sum, and_out, or_out, nand_out, nor_out;

    // Flip B if needed
    wire not_b;
    not (not_b, B);
    assign b_mux = Binvert ? not_b : B;

    // Basic logic ops
    and (and_out, A, B);
    or  (or_out, A, B);
    
    // More logic ops
    nand (nand_out, A, B);
    nor  (nor_out, A, B);

    // Adder stuff
    wire axorb;
    xor (axorb, A, b_mux);
    xor (sum, axorb, CarryIn);

    wire tmp1, tmp2;
    and (tmp1, A, b_mux);
    and (tmp2, axorb, CarryIn);
    or  (CarryOut, tmp1, tmp2);

    // Check for overflow in add/sub only
    wire is_math = (Operation == 3'b010) | (Operation == 3'b110);
    wire of_bit;
    xor (of_bit, CarryIn, CarryOut);
    assign Overflow = is_math ? of_bit : 1'b0;
    
    // For SLT, we need the sign bit of subtraction
    assign Set = sum; // Sign bit after A-B

    // Choose output based on operation
    assign Result = (Operation == 3'b000) ? and_out :
                    (Operation == 3'b001) ? or_out  :
                    (Operation == 3'b011) ? nand_out :
                    (Operation == 3'b100) ? nor_out  :
                    (Operation == 3'b111) ? Less    :
                    sum; // for ADD/SUB
endmodule
