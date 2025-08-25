# Quick Coverage Viewer for CV32E40P
# Usage: verdi -cov -f quick_coverage.tcl

# Load all available coverage databases
puts "Loading coverage databases..."
set db_files [glob -nocomplain "coverage_db_*.vdb"]
foreach db $db_files {
    puts "Loading $db"
    coverage load $db
}

# Coverage browser disabled for headless mode
# coverage browser

# Quick summary
coverage statistics -summary

# Show top-level coverage metrics
puts "\n=== Top Level Coverage ==="
coverage report -summary -scope "tb_top"

puts "\n=== Core Coverage ==="
coverage report -summary -scope "tb_top.cv32e40p_tb_wrapper_i.cv32e40p_core_i"

puts "\nCoverage browser opened. Use GUI for detailed analysis."