class cv32e40p_environment extends uvm_env;

    `uvm_component_utils(cv32e40p_environment)

    cv32e40p_agent agent;

    function new(string name = "cv32e40p_environment", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        `uvm_info("ENV", "Building CV32E40P environment", UVM_MEDIUM)
        
        agent = cv32e40p_agent::type_id::create("agent", this);
        
        `uvm_info("ENV", "Environment build phase completed", UVM_MEDIUM)
    endfunction

    virtual function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);
        `uvm_info("ENV", "=== CV32E40P TESTBENCH SIMULATION STARTING ===", UVM_LOW)
        this.print();
    endfunction

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        `uvm_info("ENV", "Environment elaboration completed", UVM_MEDIUM)
    endfunction

endclass