module alu_1bit (
    input A,
    input B,
    input Binvert,
    input CarryIn,
    input [2:0] Operation,
    output Result,
    output CarryOut
);
    wire b_mux, sum, and_out, or_out, nand_out, nor_out;

    // Invert B when needed
    wire not_b;
    not (not_b, B);
    assign b_mux = Binvert ? not_b : B;

    // Basic logic ops
    and (and_out, A, B);
    or  (or_out, A, B);
    
    // Extra logic ops
    nand (nand_out, A, B);
    nor  (nor_out, A, B);

    // Adder logic
    wire axorb;
    xor (axorb, A, b_mux);
    xor (sum, axorb, CarryIn);

    // Generate carry out
    wire tmp1, tmp2;
    and (tmp1, A, b_mux);
    and (tmp2, axorb, CarryIn);
    or  (CarryOut, tmp1, tmp2);

    // Pick the right output based on op
    assign Result = (Operation == 3'b000) ? and_out :
                    (Operation == 3'b001) ? or_out  :
                    (Operation == 3'b011) ? nand_out :
                    (Operation == 3'b100) ? nor_out  :
                    sum; // for 010 or 110
endmodule
