class cv32e40p_agent extends uvm_agent;

    `uvm_component_utils(cv32e40p_agent)

    cv32e40p_driver driver;
    cv32e40p_monitor monitor;
    cv32e40p_sequencer sequencer;

    function new(string name = "cv32e40p_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        `uvm_info("AGENT", "Building CV32E40P agent components", UVM_MEDIUM)
        
        driver = cv32e40p_driver::type_id::create("driver", this);
        monitor = cv32e40p_monitor::type_id::create("monitor", this);
        sequencer = cv32e40p_sequencer::type_id::create("sequencer", this);
        
        `uvm_info("AGENT", "Agent components created: driver, monitor, sequencer", UVM_MEDIUM)
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        `uvm_info("AGENT", "Connecting agent components", UVM_MEDIUM)
        
        driver.seq_item_port.connect(sequencer.seq_item_export);
        
        `uvm_info("AGENT", "Driver connected to sequencer", UVM_MEDIUM)
    endfunction

    virtual function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);
        `uvm_info("AGENT", "Agent ready for simulation", UVM_MEDIUM)
    endfunction

endclass