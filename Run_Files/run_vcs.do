# VCS Compilation and Simulation Script for CV32E40P
# Usage: vcs -do run_vcs.do

# Compile using existing file list
echo "Starting VCS compilation..."
vcs -f cv32e40p_vcs.f

# Check compilation status
if ($status != 0) then
    echo "Compilation failed!"
    exit 1
endif

echo "Compilation successful!"

# Run simulation
echo "Starting simulation..."
./simv

echo "Simulation completed!"
