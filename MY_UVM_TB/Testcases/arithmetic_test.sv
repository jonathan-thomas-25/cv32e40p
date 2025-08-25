class cv32e40p_arithmetic_test extends cv32e40p_test;

    `uvm_component_utils(cv32e40p_arithmetic_test)

    function new(string name = "cv32e40p_arithmetic_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual task run_phase(uvm_phase phase);
        cv32e40p_arithmetic_sequence seq;
        
        phase.raise_objection(this);
        
        `uvm_info("ARITH_TEST", "Starting Arithmetic Instructions Test", UVM_MEDIUM)
        
        seq = cv32e40p_arithmetic_sequence::type_id::create("seq");
        seq.start(env.agent.sequencer);
        
        `uvm_info("ARITH_TEST", "Arithmetic Instructions Test Completed", UVM_MEDIUM)
        
        phase.drop_objection(this);
    endtask

endclass