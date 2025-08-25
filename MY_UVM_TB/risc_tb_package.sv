package risc_tb_package;
    import uvm_pkg::*;
    import risc_pkg::*;
    `include "uvm_macros.svh"

    // Forward declarations
    typedef class cv32e40p_seq_item;
    typedef class cv32e40p_base_sequence;
    typedef class cv32e40p_sequencer;
    typedef class cv32e40p_driver;
    typedef class cv32e40p_monitor;
    typedef class cv32e40p_agent;
    typedef class cv32e40p_environment;
    typedef class cv32e40p_test;

    // Include class definitions
    `include "seq_item.sv"
    `include "sequence.sv"
    `include "sequencer.sv"
    `include "driver.sv"
    `include "monitor.sv"
    `include "agent.sv"
    `include "environment.sv"
    `include "test.sv"
    
    // Include separate test files
    `include "Testcases/arithmetic_test.sv"
    `include "Testcases/comparison_test.sv"
    `include "Testcases/shift_test.sv"
    `include "Testcases/custom_alu_test.sv"
    `include "Testcases/custom_imm_test.sv"
    `include "Testcases/data_dependency_test.sv"
    `include "Testcases/random_test.sv"

endpackage : risc_tb_package