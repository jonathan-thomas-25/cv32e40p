class cv32e40p_base_sequence extends uvm_sequence #(cv32e40p_seq_item);

    `uvm_object_utils(cv32e40p_base_sequence)

    function new(string name = "cv32e40p_sequence");
        super.new(name);
    endfunction

    virtual task body();
        cv32e40p_seq_item req;
        
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize());
        finish_item(req);
    endtask

endclass
