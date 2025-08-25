class cv32e40p_driver extends uvm_driver #(cv32e40p_seq_item);

    `uvm_component_utils(cv32e40p_driver)

    virtual cv32e40p_if vif;

    function new(string name = "cv32e40p_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual cv32e40p_if)::get(this, "", "vif", vif))
            `uvm_fatal("DRIVER", "Could not get vif")
    endfunction

    virtual task run_phase(uvm_phase phase);
        cv32e40p_seq_item req;
        forever begin
            seq_item_port.get_next_item(req);
            drive(req);
            seq_item_port.item_done();
        end
    endtask

    virtual task drive(cv32e40p_seq_item req);
        @(posedge vif.clk_i);
        vif.rst_ni <= req.rst_ni;
        vif.pulp_clock_en_i <= req.pulp_clock_en_i;
        vif.scan_cg_en_i <= req.scan_cg_en_i;
        vif.boot_addr_i <= req.boot_addr_i;
        vif.mtvec_addr_i <= req.mtvec_addr_i;
        vif.dm_halt_addr_i <= req.dm_halt_addr_i;
        vif.hart_id_i <= req.hart_id_i;
        vif.dm_exception_addr_i <= req.dm_exception_addr_i;
        vif.instr_gnt_i <= req.instr_gnt_i;
        vif.instr_rvalid_i <= req.instr_rvalid_i;
        vif.instr_rdata_i <= req.instr_rdata_i;
        vif.data_gnt_i <= req.data_gnt_i;
        vif.data_rvalid_i <= req.data_rvalid_i;
        vif.data_rdata_i <= req.data_rdata_i;
        vif.irq_i <= req.irq_i;
        vif.debug_req_i <= req.debug_req_i;
        vif.fetch_enable_i <= req.fetch_enable_i;
    endtask

endclass