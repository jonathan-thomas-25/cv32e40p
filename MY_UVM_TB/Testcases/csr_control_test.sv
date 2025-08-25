class cv32e40p_csr_control_test extends cv32e40p_test;

    `uvm_component_utils(cv32e40p_csr_control_test)

    function new(string name = "cv32e40p_csr_control_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual task run_phase(uvm_phase phase);
        cv32e40p_mstatus_controlled_sequence mstatus_seq;
        cv32e40p_debug_step_sequence debug_seq;
        cv32e40p_interrupt_mask_sequence interrupt_seq;
        cv32e40p_perf_counter_sequence perf_seq;
        cv32e40p_csr_test_sequence csr_basic_seq;
        
        phase.raise_objection(this);
        
        `uvm_info("CSR_CTRL_TEST", "Starting CSR Control Test", UVM_MEDIUM)
        
        // Test 1: Basic CSR operations
        `uvm_info("CSR_CTRL_TEST", "Phase 1: Basic CSR Read/Write Operations", UVM_MEDIUM)
        csr_basic_seq = cv32e40p_csr_test_sequence::type_id::create("csr_basic_seq");
        csr_basic_seq.start(env.agent.sequencer);
        
        // Test 2: MSTATUS controlled behavior - Interrupts Enabled
        `uvm_info("CSR_CTRL_TEST", "Phase 2: MSTATUS Control - Interrupts Enabled", UVM_MEDIUM)
        mstatus_seq = cv32e40p_mstatus_controlled_sequence::type_id::create("mstatus_seq");
        assert(mstatus_seq.randomize() with { enable_interrupts == 1'b1; });
        mstatus_seq.start(env.agent.sequencer);
        
        // Test 3: MSTATUS controlled behavior - Interrupts Disabled
        `uvm_info("CSR_CTRL_TEST", "Phase 3: MSTATUS Control - Interrupts Disabled", UVM_MEDIUM)
        mstatus_seq = cv32e40p_mstatus_controlled_sequence::type_id::create("mstatus_seq2");
        assert(mstatus_seq.randomize() with { enable_interrupts == 1'b0; });
        mstatus_seq.start(env.agent.sequencer);
        
        // Test 4: Debug single-step mode
        `uvm_info("CSR_CTRL_TEST", "Phase 4: Debug Single-Step Mode", UVM_MEDIUM)
        debug_seq = cv32e40p_debug_step_sequence::type_id::create("debug_seq");
        assert(debug_seq.randomize() with { single_step_mode == 1'b1; });
        debug_seq.start(env.agent.sequencer);
        
        // Test 5: Normal debug mode
        `uvm_info("CSR_CTRL_TEST", "Phase 5: Normal Debug Mode", UVM_MEDIUM)
        debug_seq = cv32e40p_debug_step_sequence::type_id::create("debug_seq2");
        assert(debug_seq.randomize() with { single_step_mode == 1'b0; });
        debug_seq.start(env.agent.sequencer);
        
        // Test 6: Interrupt mask with timer enabled
        `uvm_info("CSR_CTRL_TEST", "Phase 6: Interrupt Mask - Timer Enabled", UVM_MEDIUM)
        interrupt_seq = cv32e40p_interrupt_mask_sequence::type_id::create("interrupt_seq");
        assert(interrupt_seq.randomize() with { 
            interrupt_mask[7] == 1'b1;  // Timer interrupt
            interrupt_mask[11] == 1'b0; // External interrupt disabled
        });
        interrupt_seq.start(env.agent.sequencer);
        
        // Test 7: Interrupt mask with external interrupt enabled
        `uvm_info("CSR_CTRL_TEST", "Phase 7: Interrupt Mask - External Interrupt Enabled", UVM_MEDIUM)
        interrupt_seq = cv32e40p_interrupt_mask_sequence::type_id::create("interrupt_seq2");
        assert(interrupt_seq.randomize() with { 
            interrupt_mask[7] == 1'b0;  // Timer interrupt disabled
            interrupt_mask[11] == 1'b1; // External interrupt enabled
        });
        interrupt_seq.start(env.agent.sequencer);
        
        // Test 8: Performance counter - Branch counting enabled
        `uvm_info("CSR_CTRL_TEST", "Phase 8: Performance Counter - Branch Counting", UVM_MEDIUM)
        perf_seq = cv32e40p_perf_counter_sequence::type_id::create("perf_seq");
        assert(perf_seq.randomize() with { 
            enable_branch_counting == 1'b1;
            enable_cache_counting == 1'b0;
        });
        perf_seq.start(env.agent.sequencer);
        
        // Test 9: Performance counter - Cache counting enabled
        `uvm_info("CSR_CTRL_TEST", "Phase 9: Performance Counter - Cache Counting", UVM_MEDIUM)
        perf_seq = cv32e40p_perf_counter_sequence::type_id::create("perf_seq2");
        assert(perf_seq.randomize() with { 
            enable_branch_counting == 1'b0;
            enable_cache_counting == 1'b1;
        });
        perf_seq.start(env.agent.sequencer);
        
        // Test 10: Combined scenario - All features enabled
        `uvm_info("CSR_CTRL_TEST", "Phase 10: Combined Scenario - All Features", UVM_MEDIUM)
        perf_seq = cv32e40p_perf_counter_sequence::type_id::create("perf_seq3");
        assert(perf_seq.randomize() with { 
            enable_branch_counting == 1'b1;
            enable_cache_counting == 1'b1;
        });
        perf_seq.start(env.agent.sequencer);
        
        `uvm_info("CSR_CTRL_TEST", "CSR Control Test Completed Successfully", UVM_MEDIUM)
        
        phase.drop_objection(this);
    endtask

endclass