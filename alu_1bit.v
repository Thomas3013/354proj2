module alu_1bit (
    input A,
    input B,
    input Binvert,
    input CarryIn,
    input [2:0] Operation,
    output Result,
    output CarryOut
);
    wire Bmux, Sum, AndResult, OrResult;

    // Bmux = Binvert ? ~B : B
    wire B_not;
    not (B_not, B);
    assign Bmux = Binvert ? B_not : B;

    // AND and OR
    and (AndResult, A, B);
    or  (OrResult, A, B);

    // Full Adder
    wire AxorB;
    xor (AxorB, A, Bmux);
    xor (Sum, AxorB, CarryIn);

    // CarryOut = (A & Bmux) | (AxorB & CarryIn)
    wire c1, c2;
    and (c1, A, Bmux);
    and (c2, AxorB, CarryIn);
    or  (CarryOut, c1, c2);

    // Operation selection
    assign Result = (Operation == 3'b000) ? AndResult :
                    (Operation == 3'b001) ? OrResult  :
                    Sum; // for 010 or 110
endmodule
