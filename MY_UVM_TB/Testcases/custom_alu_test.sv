class cv32e40p_custom_alu_test extends cv32e40p_test;

    `uvm_component_utils(cv32e40p_custom_alu_test)

    function new(string name = "cv32e40p_custom_alu_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual task run_phase(uvm_phase phase);
        cv32e40p_custom_alu_sequence seq;
        
        phase.raise_objection(this);
        
        `uvm_info("CUSTOM_ALU_TEST", "Starting Custom ALU Instructions Test", UVM_MEDIUM)
        
        seq = cv32e40p_custom_alu_sequence::type_id::create("seq");
        seq.start(env.agent.sequencer);
        
        `uvm_info("CUSTOM_ALU_TEST", "Custom ALU Instructions Test Completed", UVM_MEDIUM)
        
        phase.drop_objection(this);
    endtask

endclass