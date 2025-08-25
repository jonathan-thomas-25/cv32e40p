class cv32e40p_environment extends uvm_env;

    `uvm_component_utils(cv32e40p_environment)

    cv32e40p_agent agent;

    function new(string name = "cv32e40p_environment", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        agent = cv32e40p_agent::type_id::create("agent", this);
    endfunction

endclass