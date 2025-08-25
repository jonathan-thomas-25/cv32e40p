# CV32E40P Assembly Generator

A Python script that generates RISC-V assembly files with configurable instruction distributions for the CV32E40P processor core.

## Overview

This script creates assembly programs with targeted instruction distributions based on realistic embedded workload patterns. It supports both standard RV32I instructions and CV32E40P custom extensions, making it ideal for verification coverage and performance analysis.

## Distribution Strategy

The generator uses a **weighted random selection** approach with the following design principles:

1. **Realistic Embedded Patterns**: Default weights reflect typical embedded workload characteristics
2. **Proper Dependencies**: Ensures valid register usage and data flow
3. **Custom Extensions**: Includes CV32E40P-specific ALU and bit manipulation instructions
4. **Configurable Mix**: Supports custom distributions via JSON files or presets

### Default Distribution (Embedded Preset)

- **Arithmetic Operations (30%)**: ADD, SUB, ADDI - Core computational instructions
- **Load/Store Operations (25%)**: LW, SW, LH, SH, LB, SB - Memory access patterns
- **Logical Operations (15%)**: AND, OR, XOR, ANDI, ORI, XORI - Bit manipulation
- **Branch Operations (12%)**: BEQ, BNE, BLT, BGE, BLTU, BGEU - Control flow
- **Comparison Operations (10%)**: SLT, SLTU, SLTI, SLTIU - Conditional logic
- **Shift Operations (8%)**: SLL, SRL, SRA, SLLI, SRLI - Bit shifting
- **Custom ALU Operations (5%)**: CV.MIN, CV.MAX, CV.ABS, CV.CLIP - CV32E40P extensions
- **Jump Operations (3%)**: JAL, JALR - Function calls and returns
- **Custom Bit Operations (2%)**: CV.EXTRACTR, CV.INSERTR, CV.CNT - Specialized bit ops

## Usage

### Basic Usage

```bash
# Generate 1000 instructions with default embedded distribution
./generate_asm.py

# Generate 500 instructions with statistics
./generate_asm.py -n 500 --stats

# Use a specific preset distribution
./generate_asm.py --preset dsp -n 2000 -o dsp_test.s
```

### Advanced Usage

```bash
# Use custom distribution from JSON file
./generate_asm.py -d custom_dist.json -n 1500 -o custom_test.s

# Generate reproducible output with seed
./generate_asm.py -s 12345 -n 800 --stats

# Generate control-heavy workload
./generate_asm.py --preset control -n 1000 -o control_test.s --stats
```

## Command Line Options

| Option | Description | Default |
|--------|-------------|---------|
| `-n, --num-instructions` | Number of instructions to generate | 1000 |
| `-o, --output` | Output assembly file | test_program.s |
| `-d, --distribution` | JSON file with custom distribution weights | None |
| `-s, --seed` | Random seed for reproducible generation | Random |
| `--stats` | Generate statistics file | False |
| `--preset` | Use preset distribution (embedded/dsp/control/mixed) | embedded |

## Preset Distributions

### Embedded (Default)
Optimized for typical embedded applications with balanced arithmetic, memory access, and control flow.

### DSP
Emphasizes arithmetic operations, shifts, and custom ALU instructions for signal processing workloads.

### Control
Heavy on branches, comparisons, and logical operations for control-intensive applications.

### Mixed
Equal weighting across all instruction types for comprehensive coverage testing.

## Custom Distribution Format

Create a JSON file with instruction type weights:

```json
{
  "arithmetic": 2.5,
  "logical": 1.8,
  "shift": 1.2,
  "comparison": 1.5,
  "branch": 2.0,
  "load_store": 3.0,
  "jump": 0.8,
  "custom_alu": 1.0,
  "custom_bit": 0.5
}
```

Higher values increase the probability of selecting that instruction type.

## Supported Instructions

### Standard RV32I Instructions
- **Arithmetic**: ADD, SUB, ADDI, SUBI
- **Logical**: AND, OR, XOR, ANDI, ORI, XORI
- **Shift**: SLL, SRL, SRA, SLLI, SRLI
- **Comparison**: SLT, SLTU, SLTI, SLTIU
- **Branch**: BEQ, BNE, BLT, BGE, BLTU, BGEU
- **Load/Store**: LW, LH, LB, SW, SH, SB
- **Jump**: JAL, JALR

### CV32E40P Custom Extensions
- **ALU Operations**: CV.ABS, CV.SLE, CV.SLEU, CV.MIN, CV.MAX, CV.MINU, CV.MAXU, CV.CLIP
- **Bit Manipulation**: CV.EXTRACTR, CV.EXTRACTUR, CV.INSERTR, CV.BCLRR, CV.BSETR, CV.ROR, CV.FF1, CV.CNT

## Output Format

Generated assembly files include:

1. **Program Header**: Section declarations and entry point
2. **Initialization Code**: Stack pointer and memory base setup
3. **Main Instruction Sequence**: Generated instructions with proper formatting
4. **Label Management**: Automatic label generation for branches and jumps
5. **Program Termination**: Infinite loop to end execution
6. **Data Section**: Test data for memory operations

## Statistics Output

When `--stats` is used, the generator creates a JSON file with:

- Total instruction count
- Instruction type distribution (counts and percentages)
- Individual instruction breakdown
- Actual vs. target distribution analysis

## Implementation Details

### Register Management
- Uses all 32 RISC-V registers (x0-x31)
- Excludes x0 (zero register) from destination operands
- Includes ABI register names for reference

### Memory Layout
- Base address: 0x10000000
- Memory size: 4KB (0x1000 bytes)
- Word-aligned offsets for load/store operations

### Label Generation
- Automatic forward/backward reference handling
- Unique label naming (label_0, label_1, etc.)
- Proper label placement to avoid unreachable code

## Example Output

```assembly
# CV32E40P Assembly Test Program
# Generated with target instruction distribution

.section .text
.global _start

_start:
    # Initialize stack pointer
    lui sp, 65537
    addi sp, sp, 0
    
    # Initialize base register for memory operations
    lui t0, 65536
    addi t0, t0, 0

main_loop:
    add x24, x9, x8
    sw x4, 2768, x24
    sub x19, x14, x2
    addi x8, x17, -1831
    cv.max x2, x24, x15
    bne x24, x8, label_0
    ...
```

## Integration with CV32E40P Verification

This generator is designed to work with the CV32E40P verification environment:

1. **Coverage Analysis**: Generate targeted instruction mixes to hit specific coverage goals
2. **Performance Testing**: Create workloads that stress different processor units
3. **Custom Extension Verification**: Exercise CV32E40P-specific instructions
4. **Regression Testing**: Use seeds for reproducible test generation

## Future Enhancements

- Support for floating-point instructions (when FPU is enabled)
- Data dependency analysis and optimization
- Instruction sequence patterns (loops, function calls)
- Memory access pattern control
- Integration with existing UVM testbench infrastructure