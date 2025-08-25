# Verdi Coverage Viewer TCL Script for CV32E40P
# Usage: verdi -cov -f view_coverage.tcl
# For headless mode: verdi -cov -nologo -noBanner -noSplash -f view_coverage.tcl

# Set coverage database paths
set cov_db_list {
    "coverage_db_cv32e40p_random_test.vdb"
    "coverage_db_cv32e40p_custom_alu_test.vdb"
    "coverage_db_cv32e40p_comparison_test.vdb"
    "coverage_db_cv32e40p_data_dependency_test.vdb"
}

# Load coverage databases
puts "Loading coverage databases..."
foreach db $cov_db_list {
    if {[file exists $db]} {
        puts "Loading $db"
        coverage load $db
    } else {
        puts "Warning: $db not found"
    }
}

# Set coverage hierarchy configuration
if {[file exists "coverage_hier.cfg"]} {
    puts "Loading coverage hierarchy configuration..."
    coverage config -file coverage_hier.cfg
}

# Open coverage browser (skip in headless mode)
if {![info exists env(HEADLESS)] || $env(HEADLESS) != "1"} {
    puts "Opening coverage browser..."
    coverage browser
} else {
    puts "Skipping coverage browser in headless mode..."
}

# Set coverage metrics display options
coverage set -line on
coverage set -cond on
coverage set -fsm on
coverage set -branch on
coverage set -toggle on

# Generate coverage summary report
puts "Generating coverage summary..."
coverage report -summary -file coverage_summary.rpt

# Generate detailed line coverage report
coverage report -line -file line_coverage.rpt

# Generate branch coverage report
coverage report -branch -file branch_coverage.rpt

# Generate FSM coverage report (if applicable)
coverage report -fsm -file fsm_coverage.rpt

# Generate toggle coverage report
coverage report -toggle -file toggle_coverage.rpt

# Set up coverage exclusions (common testbench exclusions)
coverage exclude -line -scope "tb_top.*_monitor*"
coverage exclude -line -scope "tb_top.*_driver*"
coverage exclude -line -scope "tb_top.*_sequencer*"

# Focus on core coverage
coverage focus -scope "tb_top.cv32e40p_tb_wrapper_i.cv32e40p_core_i"

# Display coverage statistics
puts "=== Coverage Statistics ==="
coverage statistics

# Create coverage groups for better organization
coverage group create "Core_Pipeline" -scope "tb_top.cv32e40p_tb_wrapper_i.cv32e40p_core_i.if_stage_i"
coverage group add "Core_Pipeline" -scope "tb_top.cv32e40p_tb_wrapper_i.cv32e40p_core_i.id_stage_i"
coverage group add "Core_Pipeline" -scope "tb_top.cv32e40p_tb_wrapper_i.cv32e40p_core_i.ex_stage_i"

coverage group create "Memory_Interface" -scope "tb_top.cv32e40p_tb_wrapper_i.cv32e40p_core_i.load_store_unit_i"

# Set coverage thresholds
coverage threshold -line 90
coverage threshold -branch 85
coverage threshold -cond 80

# Highlight uncovered code (skip in headless mode)
if {![info exists env(HEADLESS)] || $env(HEADLESS) != "1"} {
    coverage highlight -uncovered
}

puts "Coverage analysis setup complete!"
if {![info exists env(HEADLESS)] || $env(HEADLESS) != "1"} {
    puts "Use the coverage browser GUI to explore detailed metrics"
}
puts "Reports generated:"
puts "  - coverage_summary.rpt"
puts "  - line_coverage.rpt"
puts "  - branch_coverage.rpt"
puts "  - fsm_coverage.rpt"
puts "  - toggle_coverage.rpt"

# Exit automatically in headless mode
if {[info exists env(HEADLESS)] && $env(HEADLESS) == "1"} {
    puts "Exiting headless mode..."
    exit
}