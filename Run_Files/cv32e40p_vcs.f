///////////////////////////////////////////////////////////////////////////////
//
// Copyright 2020 OpenHW Group
//
// Licensed under the Solderpad Hardware Licence, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://solderpad.org/licenses/
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
///////////////////////////////////////////////////////////////////////////////
//
// VCS .f file for CV32E40P RTL compilation
// Usage: vcs -f cv32e40p_vcs.f
//
///////////////////////////////////////////////////////////////////////////////

// VCS specific options
-sverilog
-timescale=1ns/1ps
+v2k
-debug_access+all
-kdb
-top tb_top


// Include directories
+incdir+../rtl/include
+incdir+../rtl
+incdir+../bhv
+incdir+../bhv/include
+incdir+../sva
+incdir+../MY_UVM_TB
+incdir+$VCS_HOME/etc/uvm-1.2/src

// Package files (compile first)
$VCS_HOME/etc/uvm-1.2/src/uvm_pkg.sv
../rtl/include/cv32e40p_apu_core_pkg.sv
../rtl/include/cv32e40p_fpu_pkg.sv
../rtl/include/cv32e40p_pkg.sv
../MY_UVM_TB/risc_instr_pkg.sv

// Core RTL files
../rtl/cv32e40p_if_stage.sv
../rtl/cv32e40p_cs_registers.sv
../rtl/cv32e40p_register_file_ff.sv
../rtl/cv32e40p_load_store_unit.sv
../rtl/cv32e40p_id_stage.sv
../rtl/cv32e40p_aligner.sv
../rtl/cv32e40p_decoder.sv
../rtl/cv32e40p_compressed_decoder.sv
../rtl/cv32e40p_fifo.sv
../rtl/cv32e40p_prefetch_buffer.sv
../rtl/cv32e40p_hwloop_regs.sv
../rtl/cv32e40p_mult.sv
../rtl/cv32e40p_int_controller.sv
../rtl/cv32e40p_ex_stage.sv
../rtl/cv32e40p_alu_div.sv
../rtl/cv32e40p_alu.sv
../rtl/cv32e40p_ff_one.sv
../rtl/cv32e40p_popcnt.sv
../rtl/cv32e40p_apu_disp.sv
../rtl/cv32e40p_controller.sv
../rtl/cv32e40p_obi_interface.sv
../rtl/cv32e40p_prefetch_controller.sv
../rtl/cv32e40p_sleep_unit.sv
../rtl/cv32e40p_core.sv

// Top level
../rtl/cv32e40p_top.sv

// Behavioral models
../bhv/cv32e40p_sim_clock_gate.sv
../bhv/include/cv32e40p_tracer_pkg.sv
../bhv/cv32e40p_tb_wrapper.sv

// Testbench files
../MY_UVM_TB/risc_tb_package.sv
../MY_UVM_TB/interface.sv
../MY_UVM_TB/tb_top.sv
