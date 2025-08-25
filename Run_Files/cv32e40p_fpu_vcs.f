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
// VCS .f file for CV32E40P RTL compilation with FPU support
// Usage: vcs -f cv32e40p_fpu_vcs.f
//
///////////////////////////////////////////////////////////////////////////////

// VCS specific options
-sverilog
-timescale=1ns/1ps
+v2k
-debug_access+all
-kdb

// Include directories
+incdir+../rtl/include
+incdir+../bhv
+incdir+../bhv/include
+incdir+../sva
+incdir+../rtl/vendor/pulp_platform_common_cells/include

// Package files (compile first)
../rtl/include/cv32e40p_apu_core_pkg.sv
../rtl/include/cv32e40p_fpu_pkg.sv
../rtl/include/cv32e40p_pkg.sv

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

// FPU related files
../rtl/vendor/pulp_platform_common_cells/src/cf_math_pkg.sv
../rtl/vendor/pulp_platform_common_cells/src/rr_arb_tree.sv
../rtl/vendor/pulp_platform_common_cells/src/lzc.sv
../rtl/vendor/pulp_platform_fpnew/src/fpnew_pkg.sv
../rtl/vendor/pulp_platform_fpnew/vendor/opene906/E906_RTL_FACTORY/gen_rtl/clk/rtl/gated_clk_cell.v
../rtl/vendor/pulp_platform_fpnew/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fdsu/rtl/pa_fdsu_ctrl.v
../rtl/vendor/pulp_platform_fpnew/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fdsu/rtl/pa_fdsu_ff1.v
../rtl/vendor/pulp_platform_fpnew/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fdsu/rtl/pa_fdsu_pack_single.v
../rtl/vendor/pulp_platform_fpnew/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fdsu/rtl/pa_fdsu_prepare.v
../rtl/vendor/pulp_platform_fpnew/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fdsu/rtl/pa_fdsu_round_single.v
../rtl/vendor/pulp_platform_fpnew/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fdsu/rtl/pa_fdsu_special.v
../rtl/vendor/pulp_platform_fpnew/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fdsu/rtl/pa_fdsu_srt_single.v
../rtl/vendor/pulp_platform_fpnew/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fdsu/rtl/pa_fdsu_top.v
../rtl/vendor/pulp_platform_fpnew/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fpu/rtl/pa_fpu_dp.v
../rtl/vendor/pulp_platform_fpnew/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fpu/rtl/pa_fpu_frbus.v
../rtl/vendor/pulp_platform_fpnew/vendor/opene906/E906_RTL_FACTORY/gen_rtl/fpu/rtl/pa_fpu_src_type.v
../rtl/vendor/pulp_platform_fpnew/src/fpnew_divsqrt_th_32.sv
../rtl/vendor/pulp_platform_fpnew/src/fpnew_classifier.sv
../rtl/vendor/pulp_platform_fpnew/src/fpnew_rounding.sv
../rtl/vendor/pulp_platform_fpnew/src/fpnew_cast_multi.sv
../rtl/vendor/pulp_platform_fpnew/src/fpnew_fma_multi.sv
../rtl/vendor/pulp_platform_fpnew/src/fpnew_noncomp.sv
../rtl/vendor/pulp_platform_fpnew/src/fpnew_opgroup_fmt_slice.sv
../rtl/vendor/pulp_platform_fpnew/src/fpnew_opgroup_multifmt_slice.sv
../rtl/vendor/pulp_platform_fpnew/src/fpnew_opgroup_block.sv
../rtl/vendor/pulp_platform_fpnew/src/fpnew_top.sv
../rtl/cv32e40p_fp_wrapper.sv

// Top level
../rtl/cv32e40p_top.sv

// Behavioral models
../bhv/cv32e40p_sim_clock_gate.sv
../bhv/include/cv32e40p_tracer_pkg.sv
../bhv/cv32e40p_tb_wrapper.sv