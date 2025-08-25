# CV32E40P Testcases

This directory contains separate test files and sequences for different instruction types of the CV32E40P processor.

## Test Structure

### Sequence Files
- `arithmetic_sequences.sv` - Contains sequences for arithmetic operations (ADD, SUB, XOR, OR, AND)
- `comparison_sequences.sv` - Contains sequences for comparison operations (SLT, SLTU, BEQ, BNE, BLT, BGE, BLTU, BGEU)
- `shift_sequences.sv` - Contains sequences for shift operations (SLL, SRL, SRA, SLLI, SRLI, SRAI)

### Test Files
- `arithmetic_test.sv` - Test class for arithmetic instruction randomization
- `comparison_test.sv` - Test class for comparison instruction randomization
- `shift_test.sv` - Test class for shift instruction randomization
- `custom_alu_test.sv` - Test class for CV32E40P custom ALU operations
- `custom_imm_test.sv` - Test class for CV32E40P custom immediate operations
- `data_dependency_test.sv` - Test class for data dependency scenarios
- `random_test.sv` - Test class for completely random instruction generation

## Usage

Each test extends the base `cv32e40p_test` class and can be run independently by specifying the test name:

```systemverilog
// Example: Run arithmetic test
+UVM_TESTNAME=cv32e40p_arithmetic_test

// Example: Run comparison test
+UVM_TESTNAME=cv32e40p_comparison_test

// Example: Run shift test
+UVM_TESTNAME=cv32e40p_shift_test
```

## Instruction Types Covered

### Arithmetic Instructions
- ADD (R-type)
- SUB (R-type)
- XOR (R-type)
- OR (R-type)
- AND (R-type)

### Comparison Instructions
- SLT (Set Less Than)
- SLTU (Set Less Than Unsigned)
- BEQ (Branch Equal)
- BNE (Branch Not Equal)
- BLT (Branch Less Than)
- BGE (Branch Greater Equal)
- BLTU (Branch Less Than Unsigned)
- BGEU (Branch Greater Equal Unsigned)

### Shift Instructions
- SLL (Shift Left Logical)
- SRL (Shift Right Logical)
- SRA (Shift Right Arithmetic)
- SLLI (Shift Left Logical Immediate)
- SRLI (Shift Right Logical Immediate)
- SRAI (Shift Right Arithmetic Immediate)

### Custom CV32E40P Instructions
- CV_ABS (Absolute value)
- CV_MIN (Minimum)
- CV_MAX (Maximum)
- CV_FF1 (Find First 1)
- CV_CNT (Count)
- CV_EXTRACT_IMM (Extract immediate)
- CV_INSERT_IMM (Insert immediate)

## Features

- **Randomization**: Each sequence uses constrained randomization to generate valid instructions
- **Modularity**: Tests are separated by instruction type for focused testing
- **Extensibility**: Easy to add new instruction types and sequences
- **Data Dependencies**: Special sequences to test pipeline hazards
- **Logging**: Comprehensive UVM logging for debugging and analysis