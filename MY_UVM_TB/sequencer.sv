class cv32e40p_sequencer extends uvm_sequencer #(cv32e40p_seq_item);

    `uvm_component_utils(cv32e40p_sequencer)

    function new(string name = "cv32e40p_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction

endclass