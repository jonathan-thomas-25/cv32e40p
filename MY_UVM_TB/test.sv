class cv32e40p_test extends uvm_test;

    `uvm_component_utils(cv32e40p_test)

    cv32e40p_environment env;

    function new(string name = "cv32e40p_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        `uvm_info("TEST", "Building CV32E40P test", UVM_LOW)
        
        env = cv32e40p_environment::type_id::create("env", this);
        
        `uvm_info("TEST", "Test build phase completed", UVM_MEDIUM)
    endfunction

    virtual function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);
        `uvm_info("TEST", "=== CV32E40P TEST STARTING ===", UVM_NONE)
        `uvm_info("TEST", "Test configuration:", UVM_LOW)
        `uvm_info("TEST", "  - UVM Reporting enabled", UVM_LOW)
        `uvm_info("TEST", "  - Instruction decode enabled", UVM_LOW)
        `uvm_info("TEST", "  - Transaction monitoring enabled", UVM_LOW)
    endfunction

    virtual task run_phase(uvm_phase phase);
        cv32e40p_base_sequence seq;
        
        phase.raise_objection(this);
        
        `uvm_info("TEST", "Starting test sequence execution", UVM_LOW)
        
        seq = cv32e40p_base_sequence::type_id::create("seq");
        seq.start(env.agent.sequencer);
        
        `uvm_info("TEST", "Test sequence execution completed", UVM_LOW)
        
        phase.drop_objection(this);
    endtask

    virtual function void final_phase(uvm_phase phase);
        super.final_phase(phase);
        `uvm_info("TEST", "=== CV32E40P TEST COMPLETED ===", UVM_NONE)
    endfunction

endclass