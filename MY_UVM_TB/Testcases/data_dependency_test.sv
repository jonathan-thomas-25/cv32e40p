class cv32e40p_data_dependency_test extends cv32e40p_test;

    `uvm_component_utils(cv32e40p_data_dependency_test)

    function new(string name = "cv32e40p_data_dependency_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual task run_phase(uvm_phase phase);
        cv32e40p_data_dependency_sequence seq;
        
        phase.raise_objection(this);
        
        `uvm_info("DATA_DEP_TEST", "Starting Data Dependency Test", UVM_MEDIUM)
        
        repeat(10) begin
            seq = cv32e40p_data_dependency_sequence::type_id::create("seq");
            seq.start(env.agent.sequencer);
        end
        
        `uvm_info("DATA_DEP_TEST", "Data Dependency Test Completed", UVM_MEDIUM)
        
        phase.drop_objection(this);
    endtask

endclass