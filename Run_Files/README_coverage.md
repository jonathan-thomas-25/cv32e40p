# Coverage Collection and Merging Guide

This document describes how to use the coverage collection and merging features in the CV32E40P simulation environment.

## Coverage Configuration

Coverage settings are controlled through the `sim_config.yaml` file:

```yaml
build:
  coverage:
    enabled: false                    # Enable/disable coverage
    types:                           # Coverage types to collect
      - line                         # Line coverage
      - cond                         # Condition coverage  
      - fsm                          # FSM coverage
      - branch                       # Branch coverage
      - tgl                          # Toggle coverage
    output_dir: "coverage_db"        # Base directory for coverage databases
    merge_dir: "merged_coverage_db"  # Directory for merged coverage
    compile_options:                 # Additional VCS compile options
      - "-cm_hier coverage_hier.cfg"
      - "-cm_name simv"
      - "-cm_log coverage_compile.log"
    sim_options:                     # Additional simulation options
      - "-cm_name"
      - "-cm_log coverage_sim.log"

coverage_merge:
  auto_merge: true                   # Automatically merge after multiple tests
  databases: []                      # Coverage databases to merge
  merged_name: "merged_coverage"     # Name for merged database
  report:
    enabled: true                    # Generate coverage reports
    format: "html"                   # Report format: html, text, both
    output_dir: "coverage_reports"   # Report output directory
    exclude_files: []                # Files to exclude from reports
```

## Command Line Usage

### Single Test with Coverage

```bash
# Enable coverage for a single test
python3 run_sim.py --coverage -t cv32e40p_random_test

# Disable coverage (override config file)
python3 run_sim.py --no-coverage -t cv32e40p_random_test
```

### Multiple Tests with Coverage

```bash
# Run all tests with coverage and auto-merge
python3 run_sim.py --coverage --all-tests

# Run specific tests with coverage
python3 run_sim.py --coverage --multiple-tests cv32e40p_random_test cv32e40p_arithmetic_test

# Compile once for all tests (default)
python3 run_sim.py --coverage --all-tests

# Compile for each test separately
python3 run_sim.py --coverage --all-tests --compile-each
```

### Coverage Management

```bash
# Merge existing coverage databases
python3 run_sim.py --merge-coverage

# Generate report from specific coverage database
python3 run_sim.py --coverage-report merged_coverage

# List available tests
python3 run_sim.py --list-tests
```

## Coverage Database Structure

When coverage is enabled, each test creates its own coverage database:

```
coverage_db_cv32e40p_random_test/     # Test-specific coverage
coverage_db_cv32e40p_arithmetic_test/
coverage_db_cv32e40p_comparison_test/
...
merged_coverage/                      # Merged coverage database
coverage_reports/                     # Generated reports
├── coverage_report.html
└── coverage_report.txt
```

## Coverage Workflow Examples

### Example 1: Run All Tests with Coverage

```bash
# This will:
# 1. Compile once with coverage enabled
# 2. Run all available tests
# 3. Collect coverage for each test
# 4. Automatically merge all coverage databases
# 5. Generate HTML coverage report

python3 run_sim.py --coverage --all-tests
```

### Example 2: Incremental Coverage Collection

```bash
# Run individual tests
python3 run_sim.py --coverage -t cv32e40p_random_test
python3 run_sim.py --coverage --sim-only -t cv32e40p_arithmetic_test
python3 run_sim.py --coverage --sim-only -t cv32e40p_comparison_test

# Manually merge coverage
python3 run_sim.py --merge-coverage

# Generate additional reports
python3 run_sim.py --coverage-report merged_coverage
```

### Example 3: Regression with Coverage

```bash
# Run specific subset of tests for regression
python3 run_sim.py --coverage --multiple-tests \
    cv32e40p_random_test \
    cv32e40p_arithmetic_test \
    cv32e40p_comparison_test \
    cv32e40p_shift_test
```

## Coverage Types Explained

- **Line Coverage**: Tracks which lines of code were executed
- **Condition Coverage**: Tracks evaluation of boolean conditions
- **FSM Coverage**: Tracks state machine state and transition coverage
- **Branch Coverage**: Tracks which branches were taken
- **Toggle Coverage**: Tracks signal transitions (0->1, 1->0)

## Coverage Hierarchy Configuration

The `coverage_hier.cfg` file defines which modules to include/exclude from coverage:

```
# Include core modules
+tree tb_top.cv32e40p_tb_wrapper_i.cv32e40p_core_i

# Exclude testbench components
-tree tb_top.*_monitor
-tree tb_top.*_driver
```

## Troubleshooting

### Common Issues

1. **Coverage merge fails**: Ensure all coverage databases exist and are valid
2. **No coverage collected**: Check that coverage is enabled in config and VCS supports coverage
3. **Report generation fails**: Verify URG tool is available and coverage database is valid

### Debug Commands

```bash
# Check coverage database contents
ls -la coverage_db_*/

# Verify merged database
ls -la merged_coverage/

# Check coverage logs
cat coverage_compile.log
cat coverage_sim.log
```

## Tool Requirements

- **VCS**: Must support coverage collection (`-cm` options)
- **URG**: Required for coverage merging and report generation
- **Python 3**: For running the simulation script

## Performance Considerations

- Coverage collection adds simulation overhead (~10-30%)
- Large coverage databases require significant disk space
- Merging many databases can be time-consuming
- Consider using `--compile-each` for better coverage granularity but longer runtime