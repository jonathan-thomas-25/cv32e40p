class cv32e40p_shift_test extends cv32e40p_test;

    `uvm_component_utils(cv32e40p_shift_test)

    function new(string name = "cv32e40p_shift_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual task run_phase(uvm_phase phase);
        cv32e40p_shift_sequence seq;
        
        phase.raise_objection(this);
        
        `uvm_info("SHIFT_TEST", "Starting Shift Instructions Test", UVM_MEDIUM)
        
        seq = cv32e40p_shift_sequence::type_id::create("seq");
        seq.start(env.agent.sequencer);
        
        `uvm_info("SHIFT_TEST", "Shift Instructions Test Completed", UVM_MEDIUM)
        
        phase.drop_objection(this);
    endtask

endclass