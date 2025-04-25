# 4-bit ALU Verilog Implementation

This repository contains a 4-bit ALU (Arithmetic Logic Unit) implementation in Verilog. The ALU supports the following operations:

- AND (000)
- OR (001)
- ADD (010)
- NAND (011)
- NOR (100)
- SUB (110)
- SLT (Set Less Than) (111)

## Files

- `alu_main.v` - Top-level module connecting all ALU components
- `alu_1bit.v` - Single-bit ALU slice for bits 0-2
- `alu_1bitO.v` - Single-bit ALU slice for most significant bit with overflow detection
- `e2e_tests.v` - Test bench with various test cases

## Running Tests

To run the test bench:

```
iverilog -o e2e_test_out e2e_tests.v alu_1bit.v alu_1bitO.v alu_main.v
vvp e2e_test_out
```

## Implementation Details

The ALU is implemented as a 4-bit ripple-carry architecture with special handling for operations like SLT. The implementation includes:

- Zero flag detection
- Overflow detection for arithmetic operations
- Proper signed number handling for SLT operation
- Multiple logic operations: AND, OR, NAND, NOR 