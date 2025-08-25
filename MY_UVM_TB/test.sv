class cv32e40p_test extends uvm_test;

    `uvm_component_utils(cv32e40p_test)

    cv32e40p_environment env;

    function new(string name = "cv32e40p_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        env = cv32e40p_environment::type_id::create("env", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        cv32e40p_base_sequence seq;
        
        phase.raise_objection(this);
        
        seq = cv32e40p_base_sequence::type_id::create("seq");
        seq.start(env.agent.sequencer);
        
        phase.drop_objection(this);
    endtask

endclass