class cv32e40p_comparison_test extends cv32e40p_test;

    `uvm_component_utils(cv32e40p_comparison_test)

    function new(string name = "cv32e40p_comparison_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual task run_phase(uvm_phase phase);
        cv32e40p_comparison_sequence seq;
        
        phase.raise_objection(this);
        
        `uvm_info("COMP_TEST", "Starting Comparison Instructions Test", UVM_MEDIUM)
        
        seq = cv32e40p_comparison_sequence::type_id::create("seq");
        seq.start(env.agent.sequencer);
        
        `uvm_info("COMP_TEST", "Comparison Instructions Test Completed", UVM_MEDIUM)
        
        phase.drop_objection(this);
    endtask

endclass