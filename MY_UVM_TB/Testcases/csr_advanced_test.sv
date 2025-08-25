class cv32e40p_csr_advanced_test extends cv32e40p_test;

    `uvm_component_utils(cv32e40p_csr_advanced_test)

    function new(string name = "cv32e40p_csr_advanced_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual task run_phase(uvm_phase phase);
        cv32e40p_mstatus_controlled_sequence mstatus_ctrl_seq;
        cv32e40p_debug_step_sequence debug_step_seq;
        cv32e40p_interrupt_mask_sequence int_mask_seq;
        cv32e40p_perf_counter_sequence perf_counter_seq;
        cv32e40p_csr_read_sequence csr_read_seq;
        cv32e40p_csr_write_sequence csr_write_seq;
        
        phase.raise_objection(this);
        
        `uvm_info("CSR_ADV_TEST", "Starting Advanced CSR Control Test", UVM_MEDIUM)
        
        // Test Phase 1: Interrupt-driven execution patterns
        `uvm_info("CSR_ADV_TEST", "=== Phase 1: Interrupt-Driven Execution ===", UVM_MEDIUM)
        
        // Test with interrupts enabled - should generate interruptible sequences
        mstatus_ctrl_seq = cv32e40p_mstatus_controlled_sequence::type_id::create("mstatus_int_enabled");
        assert(mstatus_ctrl_seq.randomize() with { enable_interrupts == 1'b1; });
        mstatus_ctrl_seq.start(env.agent.sequencer);
        
        // Read MSTATUS to verify interrupt enable state
        csr_read_seq = cv32e40p_csr_read_sequence::type_id::create("read_mstatus_1");
        assert(csr_read_seq.randomize() with { csr_addr == CSR_MSTATUS; });
        csr_read_seq.start(env.agent.sequencer);
        
        // Test with interrupts disabled - should generate atomic sequences
        mstatus_ctrl_seq = cv32e40p_mstatus_controlled_sequence::type_id::create("mstatus_int_disabled");
        assert(mstatus_ctrl_seq.randomize() with { enable_interrupts == 1'b0; });
        mstatus_ctrl_seq.start(env.agent.sequencer);
        
        // Test Phase 2: Debug stepping behavior
        `uvm_info("CSR_ADV_TEST", "=== Phase 2: Debug Stepping Control ===", UVM_MEDIUM)
        
        // Enable single-step debug mode
        debug_step_seq = cv32e40p_debug_step_sequence::type_id::create("debug_single_step");
        assert(debug_step_seq.randomize() with { single_step_mode == 1'b1; });
        debug_step_seq.start(env.agent.sequencer);
        
        // Read DCSR to verify debug configuration
        csr_read_seq = cv32e40p_csr_read_sequence::type_id::create("read_dcsr_1");
        assert(csr_read_seq.randomize() with { csr_addr == CSR_DCSR; });
        csr_read_seq.start(env.agent.sequencer);
        
        // Disable single-step mode for normal execution
        debug_step_seq = cv32e40p_debug_step_sequence::type_id::create("debug_normal");
        assert(debug_step_seq.randomize() with { single_step_mode == 1'b0; });
        debug_step_seq.start(env.agent.sequencer);
        
        // Test Phase 3: Selective interrupt handling
        `uvm_info("CSR_ADV_TEST", "=== Phase 3: Selective Interrupt Handling ===", UVM_MEDIUM)
        
        // Enable only timer interrupts
        int_mask_seq = cv32e40p_interrupt_mask_sequence::type_id::create("timer_only");
        assert(int_mask_seq.randomize() with { 
            interrupt_mask[7] == 1'b1;   // Timer interrupt enabled
            interrupt_mask[11] == 1'b0;  // External interrupt disabled
            interrupt_mask[3] == 1'b0;   // Software interrupt disabled
        });
        int_mask_seq.start(env.agent.sequencer);
        
        // Read MIE to verify interrupt mask
        csr_read_seq = cv32e40p_csr_read_sequence::type_id::create("read_mie_1");
        assert(csr_read_seq.randomize() with { csr_addr == CSR_MIE; });
        csr_read_seq.start(env.agent.sequencer);
        
        // Enable only external interrupts
        int_mask_seq = cv32e40p_interrupt_mask_sequence::type_id::create("external_only");
        assert(int_mask_seq.randomize() with { 
            interrupt_mask[7] == 1'b0;   // Timer interrupt disabled
            interrupt_mask[11] == 1'b1;  // External interrupt enabled
            interrupt_mask[3] == 1'b0;   // Software interrupt disabled
        });
        int_mask_seq.start(env.agent.sequencer);
        
        // Enable all interrupt types
        int_mask_seq = cv32e40p_interrupt_mask_sequence::type_id::create("all_interrupts");
        assert(int_mask_seq.randomize() with { 
            interrupt_mask[7] == 1'b1;   // Timer interrupt enabled
            interrupt_mask[11] == 1'b1;  // External interrupt enabled
            interrupt_mask[3] == 1'b1;   // Software interrupt enabled
        });
        int_mask_seq.start(env.agent.sequencer);
        
        // Test Phase 4: Performance monitoring scenarios
        `uvm_info("CSR_ADV_TEST", "=== Phase 4: Performance Monitoring ===", UVM_MEDIUM)
        
        // Monitor branch-heavy workloads
        perf_counter_seq = cv32e40p_perf_counter_sequence::type_id::create("branch_heavy");
        assert(perf_counter_seq.randomize() with { 
            enable_branch_counting == 1'b1;
            enable_cache_counting == 1'b0;
        });
        perf_counter_seq.start(env.agent.sequencer);
        
        // Monitor memory-intensive workloads
        perf_counter_seq = cv32e40p_perf_counter_sequence::type_id::create("memory_heavy");
        assert(perf_counter_seq.randomize() with { 
            enable_branch_counting == 1'b0;
            enable_cache_counting == 1'b1;
        });
        perf_counter_seq.start(env.agent.sequencer);
        
        // Monitor mixed workloads
        perf_counter_seq = cv32e40p_perf_counter_sequence::type_id::create("mixed_workload");
        assert(perf_counter_seq.randomize() with { 
            enable_branch_counting == 1'b1;
            enable_cache_counting == 1'b1;
        });
        perf_counter_seq.start(env.agent.sequencer);
        
        // Read performance counter values
        csr_read_seq = cv32e40p_csr_read_sequence::type_id::create("read_mcycle");
        assert(csr_read_seq.randomize() with { csr_addr == CSR_MCYCLE; });
        csr_read_seq.start(env.agent.sequencer);
        
        csr_read_seq = cv32e40p_csr_read_sequence::type_id::create("read_minstret");
        assert(csr_read_seq.randomize() with { csr_addr == CSR_MINSTRET; });
        csr_read_seq.start(env.agent.sequencer);
        
        // Test Phase 5: Complex scenario - Context switching simulation
        `uvm_info("CSR_ADV_TEST", "=== Phase 5: Context Switching Simulation ===", UVM_MEDIUM)
        
        // Save current context (read all important CSRs)
        csr_read_seq = cv32e40p_csr_read_sequence::type_id::create("save_mstatus");
        assert(csr_read_seq.randomize() with { csr_addr == CSR_MSTATUS; });
        csr_read_seq.start(env.agent.sequencer);
        
        csr_read_seq = cv32e40p_csr_read_sequence::type_id::create("save_mepc");
        assert(csr_read_seq.randomize() with { csr_addr == CSR_MEPC; });
        csr_read_seq.start(env.agent.sequencer);
        
        csr_read_seq = cv32e40p_csr_read_sequence::type_id::create("save_mcause");
        assert(csr_read_seq.randomize() with { csr_addr == CSR_MCAUSE; });
        csr_read_seq.start(env.agent.sequencer);
        
        // Switch to different execution mode
        mstatus_ctrl_seq = cv32e40p_mstatus_controlled_sequence::type_id::create("context_switch");
        assert(mstatus_ctrl_seq.randomize() with { enable_interrupts == 1'b0; }); // Disable interrupts during switch
        mstatus_ctrl_seq.start(env.agent.sequencer);
        
        // Configure new context
        csr_write_seq = cv32e40p_csr_write_sequence::type_id::create("new_mtvec");
        assert(csr_write_seq.randomize() with { csr_addr == CSR_MTVEC; });
        csr_write_seq.start(env.agent.sequencer);
        
        // Run workload in new context
        perf_counter_seq = cv32e40p_perf_counter_sequence::type_id::create("new_context_work");
        assert(perf_counter_seq.randomize() with { 
            enable_branch_counting == 1'b1;
            enable_cache_counting == 1'b0;
        });
        perf_counter_seq.start(env.agent.sequencer);
        
        // Restore original context
        mstatus_ctrl_seq = cv32e40p_mstatus_controlled_sequence::type_id::create("context_restore");
        assert(mstatus_ctrl_seq.randomize() with { enable_interrupts == 1'b1; }); // Re-enable interrupts
        mstatus_ctrl_seq.start(env.agent.sequencer);
        
        `uvm_info("CSR_ADV_TEST", "Advanced CSR Control Test Completed Successfully", UVM_MEDIUM)
        
        phase.drop_objection(this);
    endtask

endclass