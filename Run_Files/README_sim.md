# CV32E40P Simulation Configuration System

This directory contains a configurable build and simulation system for the CV32E40P processor.

## Files

- `sim_config.yaml` - Main configuration file defining tests, build options, and simulation settings
- `run_sim.py` - Python script that reads the configuration and executes build/simulation
- `cv32e40p_vcs.f` - VCS file list (existing)
- `run_vcs.do` - Legacy VCS script (existing)

## Quick Start

```bash
# List available tests
./run_sim.py --list-tests

# Run default test (random_test)
./run_sim.py

# Run specific test
./run_sim.py -t arithmetic_test

# Run with coverage enabled
./run_sim.py -t comparison_test --coverage

# Compile only
./run_sim.py --compile-only

# Simulate only (assumes already compiled)
./run_sim.py --sim-only -t shift_test
```

## Configuration File Structure

### Test Configuration
- `available_tests`: List of available test cases from MY_UVM_TB/Testcases/
- `default_test`: Default test to run when none specified
- `test_params`: Test-specific parameters (num_transactions, seed, etc.)

### Build Configuration
- `vcs_options`: VCS compiler options
- `debug_mode`: Enable debug features
- `wave_dump`: Enable waveform dumping
- `coverage`: Coverage collection settings

### Simulation Configuration
- `plusargs`: UVM plusargs for simulation
- `waves`: Waveform format and file settings
- `timeout`: Simulation timeout
- `seed_mode`: Random seed control (auto/fixed/random)

### Environment Configuration
- `vcs_home`: VCS installation path
- `include_dirs`: Include directories for compilation

### Logging Configuration
- `compile_log`: Compilation log file
- `simulation_log`: Simulation log file
- `verbosity`: Logging verbosity level

## Available Tests

The system automatically detects tests from `../MY_UVM_TB/Testcases/`:
- `random_test` (default)
- `arithmetic_test`
- `comparison_test`
- `shift_test`
- `custom_alu_test`
- `custom_imm_test`
- `data_dependency_test`

## Coverage Collection

Enable coverage with `--coverage` flag or by setting `build.coverage.enabled: true` in config:
- Line coverage
- Condition coverage
- FSM coverage
- Branch coverage

Coverage database stored in `coverage_db/` directory.

## Customization

Edit `sim_config.yaml` to:
- Add new tests to `available_tests` list
- Modify compilation options in `vcs_options`
- Change simulation parameters
- Configure coverage collection
- Set environment paths

## Examples

```bash
# Run arithmetic test with custom config file
./run_sim.py -c my_config.yaml -t arithmetic_test

# Enable coverage for all tests
./run_sim.py --coverage

# Debug compilation issues
./run_sim.py --compile-only
cat comp.log

# Run simulation with existing binary
./run_sim.py --sim-only -t custom_alu_test
```