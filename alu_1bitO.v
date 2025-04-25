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
    wire Bmux, Sum, AndResult, OrResult, NandResult, NorResult;

    // Invert B if Binvert is 1
    wire B_not;
    not (B_not, B);
    assign Bmux = Binvert ? B_not : B;

    // Logic operations
    and (AndResult, A, B);
    or  (OrResult, A, B);
    
    // NAND and NOR operations
    nand (NandResult, A, B);
    nor  (NorResult, A, B);

    // Full Adder
    wire AxorB;
    xor (AxorB, A, Bmux);
    xor (Sum, AxorB, CarryIn);

    wire c1, c2;
    and (c1, A, Bmux);
    and (c2, AxorB, CarryIn);
    or  (CarryOut, c1, c2);

    // Overflow only for arithmetic operations
    wire isArithmetic = (Operation == 3'b010) | (Operation == 3'b110);
    wire overflowWire;
    xor (overflowWire, CarryIn, CarryOut);
    assign Overflow = isArithmetic ? overflowWire : 1'b0;
    
    // Set is used for SLT - it's 1 if A < B
    // For signed numbers, A < B if:
    // - A is negative and B is positive, OR
    // - Both have same sign AND subtraction result is negative
    assign Set = Sum; // Subtraction result (A-B) sign bit

    // Output MUX
    assign Result = (Operation == 3'b000) ? AndResult :
                    (Operation == 3'b001) ? OrResult  :
                    (Operation == 3'b011) ? NandResult :
                    (Operation == 3'b100) ? NorResult  :
                    (Operation == 3'b111) ? Less      :
                    Sum; // for ADD/SUB
endmodule
