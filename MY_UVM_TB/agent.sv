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
        
        driver = cv32e40p_driver::type_id::create("driver", this);
        monitor = cv32e40p_monitor::type_id::create("monitor", this);
        sequencer = cv32e40p_sequencer::type_id::create("sequencer", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction

endclass