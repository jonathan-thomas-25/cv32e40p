#!/usr/bin/env python3
"""
CV32E40P Simulation Runner
Configurable build and simulation script using YAML configuration
"""

import yaml
import argparse
import subprocess
import sys
import os
import shutil
import glob
from pathlib import Path

class SimRunner:
    def __init__(self, config_file="sim_config.yaml"):
        self.config_file = config_file
        self.config = self.load_config()
        self.coverage_databases = []
        
    def load_config(self):
        """Load configuration from YAML file"""
        try:
            with open(self.config_file, 'r') as f:
                return yaml.safe_load(f)
        except FileNotFoundError:
            print(f"Error: Configuration file {self.config_file} not found")
            sys.exit(1)
        except yaml.YAMLError as e:
            print(f"Error parsing YAML config: {e}")
            sys.exit(1)
    
    def build_vcs_command(self, test_name=None):
        """Build VCS compilation command from configuration"""
        cmd = ["vcs"]
        
        # Add base VCS options
        cmd.extend(self.config['build']['vcs_options'])
        
        # Add coverage options if enabled
        if self.config['build']['coverage']['enabled']:
            coverage_types = "+".join(self.config['build']['coverage']['types'])
            cmd.extend(["-cm", coverage_types])
            
            # Add additional coverage compile options (only non-runtime options)
            if 'compile_options' in self.config['build']['coverage']:
                for opt in self.config['build']['coverage']['compile_options']:
                    # Skip runtime options that should go to simv
                    if not any(runtime_opt in opt for runtime_opt in ['-cm_dir', '-cm_name', '-cm_log']):
                        cmd.append(opt)
        
        # Add file list
        cmd.extend(["-f", "cv32e40p_vcs.f"])
        
        # Add test-specific defines if test is specified
        if test_name:
            cmd.extend([f"+define+TEST_NAME={test_name}"])
        
        # Add wave dump options
        if self.config['build']['wave_dump']:
            wave_format = self.config['simulation']['waves']['format']
            if wave_format == "vcd":
                cmd.extend(["+vcs+dumpvars"])
            elif wave_format == "fsdb":
                cmd.extend(["+fsdb+all"])
        
        return cmd
    
    def build_simv_command(self, test_name):
        """Build simulation command from configuration"""
        cmd = ["./simv"]
        
        # Add test name
        cmd.append(f"+UVM_TESTNAME={test_name}")
        
        # Add plusargs from config
        for plusarg in self.config['simulation']['plusargs']:
            if plusarg == "+UVM_TESTNAME":
                continue  # Already added above
            cmd.append(plusarg)
        
        # Add test-specific parameters
        if test_name in self.config['test']['test_params']:
            params = self.config['test']['test_params'][test_name]
            for key, value in params.items():
                cmd.append(f"+{key}={value}")
        
        # Add seed configuration
        seed_mode = self.config['simulation']['seed_mode']
        if seed_mode == "fixed":
            cmd.append(f"+ntb_random_seed={self.config['simulation']['fixed_seed']}")
        elif seed_mode == "random":
            import random
            cmd.append(f"+ntb_random_seed={random.randint(1, 2**31-1)}")
        
        # Add timeout
        if self.config['simulation']['timeout']:
            cmd.append(f"+UVM_TIMEOUT={self.config['simulation']['timeout']}")
        
        # Add wave dump file
        wave_file = self.config['simulation']['waves']['file']
        if wave_file:
            cmd.append(f"+vcdfile={wave_file}")
        
        # Add coverage options if enabled
        if self.config['build']['coverage']['enabled']:
            coverage_dir = f"{self.config['build']['coverage']['output_dir']}_{test_name}"
            cmd.extend(["-cm_dir", coverage_dir])
            
            # Add coverage simulation options
            if 'sim_options' in self.config['build']['coverage']:
                for opt in self.config['build']['coverage']['sim_options']:
                    if opt == "-cm_name":
                        cmd.extend([opt, test_name])
                    elif opt == "-cm_log":
                        cmd.extend([opt, f"coverage_{test_name}.log"])
                    else:
                        cmd.append(opt)
            
            # Add runtime coverage options from compile_options that were skipped
            if 'compile_options' in self.config['build']['coverage']:
                for opt in self.config['build']['coverage']['compile_options']:
                    # Add runtime options that were skipped during compile
                    if '-cm_name' in opt:
                        cmd.extend(["-cm_name", test_name])
                    elif '-cm_log' in opt:
                        # Extract log filename and use it
                        log_file = opt.split()[-1] if len(opt.split()) > 1 else f"coverage_{test_name}.log"
                        cmd.extend(["-cm_log", log_file])
        
        return cmd
    
    def compile(self, test_name=None):
        """Compile the design"""
        print("=" * 60)
        print("COMPILATION PHASE")
        print("=" * 60)
        
        cmd = self.build_vcs_command(test_name)
        print(f"Running: {' '.join(cmd)}")
        
        # Always run VCS directly without redirecting output
        # VCS will handle logging through its -l option if specified
        result = subprocess.run(cmd)
        
        if result.returncode != 0:
            # Check if -l option is in vcs_options to determine log file name
            has_log_option = any('-l' in opt for opt in self.config['build']['vcs_options'])
            log_file = "comp.log" if has_log_option else self.config['logging']['compile_log']
            print(f"❌ Compilation failed! Check {log_file} for details")
            return False
        else:
            print("✅ Compilation successful!")
            return True
    
    def simulate(self, test_name):
        """Run simulation"""
        print("=" * 60)
        print("SIMULATION PHASE")
        print("=" * 60)
        
        cmd = self.build_simv_command(test_name)
        print(f"Running test: {test_name}")
        print(f"Command: {' '.join(cmd)}")
        
        # Run simulation
        log_file = self.config['logging']['simulation_log']
        with open(log_file, 'w') as f:
            result = subprocess.run(cmd, stdout=f, stderr=subprocess.STDOUT)
        
        if result.returncode != 0:
            print(f"❌ Simulation failed! Check {log_file} for details")
            return False
        else:
            print("✅ Simulation completed successfully!")
            
            # Track coverage database if coverage is enabled
            if self.config['build']['coverage']['enabled']:
                coverage_dir = f"{self.config['build']['coverage']['output_dir']}_{test_name}.vdb"
                if os.path.exists(coverage_dir):
                    self.coverage_databases.append(coverage_dir)
                    print(f"📊 Coverage data saved to: {coverage_dir}")
            
            return True
    
    def merge_coverage(self):
        """Merge coverage databases from multiple test runs"""
        if not self.config['build']['coverage']['enabled']:
            print("⚠️  Coverage not enabled, skipping merge")
            return False
            
        if len(self.coverage_databases) < 2:
            print("⚠️  Need at least 2 coverage databases to merge")
            return False
            
        print("=" * 60)
        print("COVERAGE MERGE PHASE")
        print("=" * 60)
        
        merge_config = self.config.get('coverage_merge', {})
        merged_dir = merge_config.get('merged_name', 'merged_coverage')
        
        # Remove existing merged database
        if os.path.exists(merged_dir):
            shutil.rmtree(merged_dir)
            
        # Build urg merge command
        cmd = ["urg", "-dir"]
        cmd.extend(self.coverage_databases)
        cmd.extend(["-dbname", merged_dir])
        
        print(f"Merging coverage databases: {', '.join(self.coverage_databases)}")
        print(f"Running: {' '.join(cmd)}")
        
        result = subprocess.run(cmd, capture_output=True, text=True)
        
        if result.returncode != 0:
            print(f"❌ Coverage merge failed!")
            print(f"Error: {result.stderr}")
            return False
        else:
            print(f"✅ Coverage merged successfully to: {merged_dir}")
            
            # Generate coverage report if enabled
            if merge_config.get('report', {}).get('enabled', False):
                self.generate_coverage_report(merged_dir)
                
            return True
    
    def generate_coverage_report(self, coverage_db):
        """Generate coverage report"""
        print("=" * 60)
        print("COVERAGE REPORT GENERATION")
        print("=" * 60)
        
        merge_config = self.config.get('coverage_merge', {})
        report_config = merge_config.get('report', {})
        
        output_dir = report_config.get('output_dir', 'coverage_reports')
        report_format = report_config.get('format', 'html')
        
        # Create output directory
        os.makedirs(output_dir, exist_ok=True)
        
        # Build urg report command
        cmd = ["urg", "-dir", coverage_db]
        
        if report_format == 'html':
            # Default HTML report (no -format needed)
            cmd.extend(["-report", f"{output_dir}/coverage_report"])
        elif report_format == 'text':
            cmd.extend(["-format", "text", "-report", f"{output_dir}/coverage_report.txt"])
        elif report_format == 'both':
            cmd.extend(["-format", "both", "-report", f"{output_dir}/coverage_report"])
            
        # Add exclude files if specified
        exclude_files = report_config.get('exclude_files', [])
        for exclude_file in exclude_files:
            cmd.extend(["-elfile", exclude_file])
            
        print(f"Generating coverage report in {output_dir}")
        print(f"Running: {' '.join(cmd)}")
        
        result = subprocess.run(cmd, capture_output=True, text=True)
        
        if result.returncode != 0:
            print(f"❌ Coverage report generation failed!")
            print(f"Error: {result.stderr}")
            return False
        else:
            print(f"✅ Coverage report generated in: {output_dir}")
            return True
    
    def run_multiple_tests(self, test_names, compile_once=True):
        """Run multiple tests and optionally merge coverage"""
        print(f"Running multiple tests: {', '.join(test_names)}")
        
        success = True
        compiled = False
        
        for i, test_name in enumerate(test_names):
            print(f"\n{'='*60}")
            print(f"RUNNING TEST {i+1}/{len(test_names)}: {test_name}")
            print(f"{'='*60}")
            
            # Compile only for first test if compile_once is True
            need_compile = not compiled if compile_once else True
            need_sim = True
            
            if need_compile:
                success = self.compile(test_name)
                compiled = True
                if not success:
                    break
                    
            if success and need_sim:
                success = self.simulate(test_name)
                if not success:
                    break
        
        # Merge coverage if enabled and successful
        if success and self.config['build']['coverage']['enabled']:
            merge_config = self.config.get('coverage_merge', {})
            if merge_config.get('auto_merge', True):
                self.merge_coverage()
                
        return success
    
    def list_tests(self):
        """List available tests"""
        print("Available tests:")
        for test in self.config['test']['available_tests']:
            marker = " (default)" if test == self.config['test']['default_test'] else ""
            print(f"  - {test}{marker}")
    
    def run(self, test_name=None, compile_only=False, sim_only=False):
        """Run complete flow"""
        if test_name is None:
            test_name = self.config['test']['default_test']
        
        if test_name not in self.config['test']['available_tests']:
            print(f"Error: Test '{test_name}' not found in available tests")
            self.list_tests()
            return False
        
        print(f"Running simulation flow for test: {test_name}")
        print(f"Configuration file: {self.config_file}")
        
        success = True
        
        if not sim_only:
            success = self.compile(test_name)
        
        if success and not compile_only:
            success = self.simulate(test_name)
        
        return success

def main():
    parser = argparse.ArgumentParser(description="CV32E40P Simulation Runner")
    parser.add_argument("-t", "--test", help="Test name to run")
    parser.add_argument("-c", "--config", default="sim_config.yaml", 
                       help="Configuration file (default: sim_config.yaml)")
    parser.add_argument("--compile-only", action="store_true", 
                       help="Only compile, don't simulate")
    parser.add_argument("--sim-only", action="store_true", 
                       help="Only simulate (assumes already compiled)")
    parser.add_argument("--list-tests", action="store_true", 
                       help="List available tests")
    parser.add_argument("--coverage", action="store_true", 
                       help="Enable coverage collection")
    parser.add_argument("--no-coverage", action="store_true", 
                       help="Disable coverage collection")
    parser.add_argument("--all-tests", action="store_true", 
                       help="Run all available tests")
    parser.add_argument("--multiple-tests", nargs='+', 
                       help="Run multiple specific tests")
    parser.add_argument("--merge-coverage", action="store_true", 
                       help="Merge existing coverage databases")
    parser.add_argument("--coverage-report", 
                       help="Generate coverage report from database")
    parser.add_argument("--compile-each", action="store_true", 
                       help="Compile for each test (default: compile once)")
    
    args = parser.parse_args()
    
    # Create runner instance
    runner = SimRunner(args.config)
    
    # Override coverage settings if specified
    if args.coverage:
        runner.config['build']['coverage']['enabled'] = True
    elif args.no_coverage:
        runner.config['build']['coverage']['enabled'] = False
    
    if args.list_tests:
        runner.list_tests()
        return
    
    # Handle coverage report generation
    if args.coverage_report:
        if os.path.exists(args.coverage_report):
            runner.generate_coverage_report(args.coverage_report)
        else:
            print(f"❌ Coverage database not found: {args.coverage_report}")
            sys.exit(1)
        return
    
    # Handle coverage merge
    if args.merge_coverage:
        # Find existing coverage databases
        coverage_pattern = f"{runner.config['build']['coverage']['output_dir']}_*.vdb"
        existing_dbs = glob.glob(coverage_pattern)
        if existing_dbs:
            runner.coverage_databases = existing_dbs
            # Enable coverage for merge to work
            runner.config['build']['coverage']['enabled'] = True
            runner.merge_coverage()
        else:
            print(f"❌ No coverage databases found matching pattern: {coverage_pattern}")
            sys.exit(1)
        return
    
    # Handle multiple test runs
    if args.all_tests:
        test_names = runner.config['test']['available_tests']
        success = runner.run_multiple_tests(test_names, not args.compile_each)
    elif args.multiple_tests:
        # Validate test names
        invalid_tests = [t for t in args.multiple_tests if t not in runner.config['test']['available_tests']]
        if invalid_tests:
            print(f"❌ Invalid test names: {', '.join(invalid_tests)}")
            runner.list_tests()
            sys.exit(1)
        success = runner.run_multiple_tests(args.multiple_tests, not args.compile_each)
    else:
        # Run single test
        success = runner.run(
            test_name=args.test,
            compile_only=args.compile_only,
            sim_only=args.sim_only
        )
    
    sys.exit(0 if success else 1)

if __name__ == "__main__":
    main()