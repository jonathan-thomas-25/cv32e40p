# CV32E40P Assembly Generator - Usage Guide

This document provides comprehensive usage examples for the `generate_asm.py` script, which generates RISC-V assembly programs with configurable instruction distributions and hazard patterns for CV32E40P processor testing.

## Basic Usage

```bash
python3 generate_asm.py [options]
```

## Command Line Options

- `-n, --num-instructions`: Number of instructions to generate (default: 1000)
- `-o, --output`: Output assembly file (default: test_program.s)
- `-d, --distribution`: JSON file with instruction type distribution weights
- `-s, --seed`: Random seed for reproducible generation
- `--stats`: Generate statistics file
- `--preset`: Use preset distribution (embedded, dsp, control, mixed, multiply_heavy, branch_heavy, misaligned_heavy)
- `--cv-weight`: Weight multiplier for CV32E40P extension instructions (default: 1.0)
- `--branch-taken-rate`: Probability of branches being taken (0.0-1.0, default: 0.5)
- `--misaligned-rate`: Probability of memory accesses being misaligned (0.0-1.0, default: 0.3)

## Basic Examples

### 1. Simple Test Generation
```bash
# Generate basic 1000-instruction test
python3 generate_asm.py

# Generate 500 instructions with statistics
python3 generate_asm.py -n 500 --stats

# Generate with custom output filename
python3 generate_asm.py -n 1000 -o my_test.s --stats
```

### 2. Reproducible Tests
```bash
# Generate reproducible test with seed
python3 generate_asm.py -n 1000 -s 12345 -o reproducible_test.s --stats

# Generate multiple reproducible tests
python3 generate_asm.py -n 1000 -s 1001 -o test_1.s --stats
python3 generate_asm.py -n 1000 -s 1002 -o test_2.s --stats
python3 generate_asm.py -n 1000 -s 1003 -o test_3.s --stats
```

## Preset-Based Generation

### 3. Embedded Workload (Default)
```bash
# Standard embedded processor workload
python3 generate_asm.py --preset embedded -n 1000 -o embedded_test.s --stats

# Embedded with more CV32E40P extensions
python3 generate_asm.py --preset embedded --cv-weight 2.0 -n 1000 -o embedded_cv_test.s --stats
```

### 4. DSP-Heavy Workload
```bash
# DSP workload with multiply and custom instructions
python3 generate_asm.py --preset dsp -n 1500 -o dsp_test.s --stats

# DSP with high CV32E40P extension usage
python3 generate_asm.py --preset dsp --cv-weight 3.0 -n 1500 -o dsp_cv_heavy.s --stats
```

### 5. Control-Heavy Workload
```bash
# Control logic with many branches and comparisons
python3 generate_asm.py --preset control -n 1200 -o control_test.s --stats

# Control with high branch taken rate
python3 generate_asm.py --preset control --branch-taken-rate 0.8 -n 1200 -o control_taken.s --stats
```

### 6. Mixed Workload
```bash
# Balanced instruction mix
python3 generate_asm.py --preset mixed -n 1000 -o mixed_test.s --stats

# Mixed with custom parameters
python3 generate_asm.py --preset mixed --branch-taken-rate 0.6 --misaligned-rate 0.4 -n 1000 -o mixed_custom.s --stats
```

## Hazard-Specific Testing

### 7. Multiply-Heavy Tests (Data Hazards)
```bash
# Heavy multiply usage for multicycle hazards
python3 generate_asm.py --preset multiply_heavy -n 1000 -o multiply_hazards.s --stats

# Extreme multiply testing
python3 generate_asm.py --preset multiply_heavy -n 2000 -o multiply_stress.s --stats

# Multiply with other hazards
python3 generate_asm.py --preset multiply_heavy --branch-taken-rate 0.7 --misaligned-rate 0.3 -n 1500 -o multiply_mixed.s --stats
```

### 8. Branch-Heavy Tests (Control Hazards)
```bash
# Heavy branching for pipeline flushes
python3 generate_asm.py --preset branch_heavy -n 1000 -o branch_hazards.s --stats

# High branch taken rate (90% taken)
python3 generate_asm.py --preset branch_heavy --branch-taken-rate 0.9 -n 1000 -o branch_taken_heavy.s --stats

# Low branch taken rate (10% taken)
python3 generate_asm.py --preset branch_heavy --branch-taken-rate 0.1 -n 1000 -o branch_not_taken.s --stats

# Branch prediction stress test
python3 generate_asm.py --preset branch_heavy --branch-taken-rate 0.5 -n 2000 -o branch_prediction_test.s --stats
```

### 9. Misaligned Memory Tests (Structural Hazards)
```bash
# Heavy misaligned memory access
python3 generate_asm.py --preset misaligned_heavy -n 1000 -o misaligned_hazards.s --stats

# High misalignment rate (80% misaligned)
python3 generate_asm.py --preset misaligned_heavy --misaligned-rate 0.8 -n 1000 -o misaligned_extreme.s --stats

# Misaligned with other hazards
python3 generate_asm.py --preset misaligned_heavy --branch-taken-rate 0.6 -n 1500 -o misaligned_mixed.s --stats
```

## Combined Hazard Testing

### 10. Multi-Hazard Stress Tests
```bash
# All hazards combined - moderate stress
python3 generate_asm.py --preset mixed --branch-taken-rate 0.7 --misaligned-rate 0.4 -n 1500 -o multi_hazard_moderate.s --stats

# All hazards combined - high stress
python3 generate_asm.py --preset mixed --branch-taken-rate 0.8 --misaligned-rate 0.6 -n 2000 -o multi_hazard_high.s --stats

# Ultimate stress test
python3 generate_asm.py --preset mixed --branch-taken-rate 0.9 --misaligned-rate 0.7 --cv-weight 2.0 -n 2500 -o ultimate_stress.s --stats

# Performance regression test suite
python3 generate_asm.py --preset multiply_heavy --branch-taken-rate 0.8 --misaligned-rate 0.5 -n 3000 -o regression_test.s --stats
```

### 11. Specific Performance Tests
```bash
# Pipeline flush intensive
python3 generate_asm.py --preset branch_heavy --branch-taken-rate 0.95 -n 1000 -o flush_intensive.s --stats

# Structural hazard intensive  
python3 generate_asm.py --preset misaligned_heavy --misaligned-rate 0.9 -n 1000 -o structural_intensive.s --stats

# Data dependency intensive
python3 generate_asm.py --preset multiply_heavy --cv-weight 3.0 -n 1000 -o data_dependency_intensive.s --stats

# Memory subsystem stress
python3 generate_asm.py --preset dsp --misaligned-rate 0.8 -n 2000 -o memory_stress.s --stats
```

## Test Suite Generation

### 12. Comprehensive Test Suite
```bash
# Generate complete test suite
python3 generate_asm.py --preset embedded -n 1000 -o suite_embedded.s --stats -s 1001
python3 generate_asm.py --preset dsp -n 1000 -o suite_dsp.s --stats -s 1002  
python3 generate_asm.py --preset control -n 1000 -o suite_control.s --stats -s 1003
python3 generate_asm.py --preset multiply_heavy -n 1000 -o suite_multiply.s --stats -s 1004
python3 generate_asm.py --preset branch_heavy -n 1000 -o suite_branch.s --stats -s 1005
python3 generate_asm.py --preset misaligned_heavy -n 1000 -o suite_misaligned.s --stats -s 1006
python3 generate_asm.py --preset mixed -n 1000 -o suite_mixed.s --stats -s 1007

# Performance characterization suite
python3 generate_asm.py --preset mixed --branch-taken-rate 0.1 -n 1000 -o perf_branch_10.s --stats -s 2001
python3 generate_asm.py --preset mixed --branch-taken-rate 0.3 -n 1000 -o perf_branch_30.s --stats -s 2002
python3 generate_asm.py --preset mixed --branch-taken-rate 0.5 -n 1000 -o perf_branch_50.s --stats -s 2003
python3 generate_asm.py --preset mixed --branch-taken-rate 0.7 -n 1000 -o perf_branch_70.s --stats -s 2004
python3 generate_asm.py --preset mixed --branch-taken-rate 0.9 -n 1000 -o perf_branch_90.s --stats -s 2005
```

### 13. Corner Case Testing
```bash
# Minimal instructions
python3 generate_asm.py -n 10 -o minimal_test.s --stats

# Large test
python3 generate_asm.py -n 10000 -o large_test.s --stats

# No branches (branch-taken-rate doesn't matter)
python3 generate_asm.py --preset dsp --branch-taken-rate 0.0 -n 1000 -o no_branches.s --stats

# No misaligned accesses
python3 generate_asm.py --preset mixed --misaligned-rate 0.0 -n 1000 -o aligned_only.s --stats

# Only CV32E40P extensions
python3 generate_asm.py --preset mixed --cv-weight 10.0 -n 1000 -o cv_extensions_only.s --stats
```

## Batch Generation Scripts

### 14. Batch Test Generation
```bash
#!/bin/bash
# Generate multiple test variants

PRESETS=("embedded" "dsp" "control" "mixed" "multiply_heavy" "branch_heavy" "misaligned_heavy")
SIZES=(500 1000 1500 2000)
SEEDS=(1001 1002 1003 1004 1005)

for preset in "${PRESETS[@]}"; do
    for size in "${SIZES[@]}"; do
        for seed in "${SEEDS[@]}"; do
            python3 generate_asm.py --preset $preset -n $size -s $seed -o "test_${preset}_${size}_${seed}.s" --stats
        done
    done
done
```

### 15. Performance Sweep
```bash
#!/bin/bash
# Performance characterization sweep

for branch_rate in 0.1 0.3 0.5 0.7 0.9; do
    for misalign_rate in 0.1 0.3 0.5 0.7 0.9; do
        python3 generate_asm.py --preset mixed \
            --branch-taken-rate $branch_rate \
            --misaligned-rate $misalign_rate \
            -n 1000 \
            -o "perf_br${branch_rate}_mis${misalign_rate}.s" \
            --stats \
            -s 3000
    done
done
```

## Output Files

Each run generates:
- **Assembly file** (`.s`): The generated RISC-V assembly program
- **Statistics file** (`.json`, if `--stats` used): Detailed instruction breakdown and statistics

## Tips for Effective Testing

1. **Use seeds** for reproducible tests during debugging
2. **Generate statistics** to verify instruction distributions
3. **Start with smaller tests** (100-500 instructions) for initial validation
4. **Use preset combinations** to target specific performance scenarios
5. **Batch generate** multiple variants for comprehensive coverage
6. **Monitor file sizes** - large tests (>5000 instructions) may be slow to simulate

## Example Statistics Output

When using `--stats`, you'll get detailed breakdowns like:
```json
{
  "total_instructions": 1000,
  "instruction_types": {
    "arithmetic": 245,
    "branch": 180,
    "multiply": 95,
    "misaligned_mem": 35
  }
}
```

This helps verify that your generated tests match the intended instruction distribution for your performance analysis.