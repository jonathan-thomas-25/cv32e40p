class cv32e40p_csr_behavioral_test extends cv32e40p_test;

    `uvm_component_utils(cv32e40p_csr_behavioral_test)

    function new(string name = "cv32e40p_csr_behavioral_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual task run_phase(uvm_phase phase);
        cv32e40p_csr_write_sequence csr_write_seq;
        cv32e40p_arithmetic_sequence arith_seq;
        cv32e40p_random_sequence rand_seq;
        cv32e40p_data_dependency_sequence dep_seq;
        
        phase.raise_objection(this);
        
        `uvm_info("CSR_BEHAV_TEST", "Starting CSR Behavioral Test", UVM_MEDIUM)
        
        // Scenario 1: Configure processor for high-performance mode
        `uvm_info("CSR_BEHAV_TEST", "Scenario 1: High-Performance Configuration", UVM_MEDIUM)
        
        // Enable all interrupts in MIE
        csr_write_seq = cv32e40p_csr_write_sequence::type_id::create("mie_enable_seq");
        assert(csr_write_seq.randomize() with { csr_addr == CSR_MIE; });
        csr_write_seq.start(env.agent.sequencer);
        
        // Enable machine interrupts in MSTATUS
        csr_write_seq = cv32e40p_csr_write_sequence::type_id::create("mstatus_enable_seq");
        assert(csr_write_seq.randomize() with { csr_addr == CSR_MSTATUS; });
        csr_write_seq.start(env.agent.sequencer);
        
        // Run intensive arithmetic operations (should be interruptible)
        arith_seq = cv32e40p_arithmetic_sequence::type_id::create("arith_seq1");
        arith_seq.start(env.agent.sequencer);
        
        // Scenario 2: Configure processor for debug mode
        `uvm_info("CSR_BEHAV_TEST", "Scenario 2: Debug Mode Configuration", UVM_MEDIUM)
        
        // Set debug control register for single-step
        csr_write_seq = cv32e40p_csr_write_sequence::type_id::create("dcsr_debug_seq");
        assert(csr_write_seq.randomize() with { csr_addr == CSR_DCSR; });
        csr_write_seq.start(env.agent.sequencer);
        
        // Run random instructions (each should trigger debug)
        rand_seq = cv32e40p_random_sequence::type_id::create("rand_seq1");
        rand_seq.start(env.agent.sequencer);
        
        // Scenario 3: Configure processor for secure mode
        `uvm_info("CSR_BEHAV_TEST", "Scenario 3: Secure Mode Configuration", UVM_MEDIUM)
        
        // Disable interrupts for critical section
        csr_write_seq = cv32e40p_csr_write_sequence::type_id::create("mstatus_disable_seq");
        assert(csr_write_seq.randomize() with { csr_addr == CSR_MSTATUS; });
        csr_write_seq.start(env.agent.sequencer);
        
        // Run data dependency operations (should be atomic)
        dep_seq = cv32e40p_data_dependency_sequence::type_id::create("dep_seq1");
        dep_seq.start(env.agent.sequencer);
        
        // Scenario 4: Performance monitoring configuration
        `uvm_info("CSR_BEHAV_TEST", "Scenario 4: Performance Monitoring", UVM_MEDIUM)
        
        // Enable performance counters
        csr_write_seq = cv32e40p_csr_write_sequence::type_id::create("mcounteren_seq");
        assert(csr_write_seq.randomize() with { csr_addr == CSR_MCOUNTEREN; });
        csr_write_seq.start(env.agent.sequencer);
        
        // Run mixed workload for performance analysis
        repeat(3) begin
            arith_seq = cv32e40p_arithmetic_sequence::type_id::create($sformatf("arith_perf_%0d", $urandom()));
            arith_seq.start(env.agent.sequencer);
            
            dep_seq = cv32e40p_data_dependency_sequence::type_id::create($sformatf("dep_perf_%0d", $urandom()));
            dep_seq.start(env.agent.sequencer);
        end
        
        // Scenario 5: Exception handling configuration
        `uvm_info("CSR_BEHAV_TEST", "Scenario 5: Exception Handling Setup", UVM_MEDIUM)
        
        // Set trap vector base address
        csr_write_seq = cv32e40p_csr_write_sequence::type_id::create("mtvec_seq");
        assert(csr_write_seq.randomize() with { csr_addr == CSR_MTVEC; });
        csr_write_seq.start(env.agent.sequencer);
        
        // Set exception program counter
        csr_write_seq = cv32e40p_csr_write_sequence::type_id::create("mepc_seq");
        assert(csr_write_seq.randomize() with { csr_addr == CSR_MEPC; });
        csr_write_seq.start(env.agent.sequencer);
        
        // Run operations that might cause exceptions
        rand_seq = cv32e40p_random_sequence::type_id::create("rand_exception_seq");
        rand_seq.start(env.agent.sequencer);
        
        `uvm_info("CSR_BEHAV_TEST", "CSR Behavioral Test Completed Successfully", UVM_MEDIUM)
        
        phase.drop_objection(this);
    endtask

endclass