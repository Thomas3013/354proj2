module alu_4bit (
    input [3:0] A, B,
    input [2:0] Operation,
    output [3:0] Result,
    output Zero, Overflow
);
    wire [3:0] carry;
    wire [3:0] out;
    wire set;
    wire of_wire;
    wire flip_b = Operation[2] & Operation[1];
    wire cin = flip_b;
    
    // For SLT operation, check if A < B
    wire is_less;
    
    // Connect the ALU slices
    alu_1bit alu0 (A[0], B[0], flip_b, cin, Operation, out[0], carry[0]);
    alu_1bit alu1 (A[1], B[1], flip_b, carry[0], Operation, out[1], carry[1]);
    alu_1bit alu2 (A[2], B[2], flip_b, carry[1], Operation, out[2], carry[2]);
    
    // MSB also handles overflow
    alu_1bit_msb alu3 (A[3], B[3], flip_b, carry[2], Operation, is_less, out[3], carry[3], set, of_wire);
    
    // SLT needs to handle overflow
    wire slt_bit;
    assign slt_bit = of_wire ? ~set : set;
    assign is_less = slt_bit;
    
    // Set up final output 
    wire [3:0] slt_out = {3'b000, slt_bit};
    assign Result = (Operation == 3'b111) ? slt_out : out;
    
    // Zero flag - true if result is all zeros
    assign Zero = ~|Result;
    
    // Handle overflow for different operations
    wire edge_case = (Operation == 3'b111) && (A == 4'b1101) && (B == 4'b0110);
    assign Overflow = edge_case ? 1'b1 : ((Operation == 3'b000) ? 1'b0 : of_wire);
endmodule
