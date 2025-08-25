class cv32e40p_monitor extends uvm_monitor;

    `uvm_component_utils(cv32e40p_monitor)

    virtual cv32e40p_if vif;
    uvm_analysis_port #(cv32e40p_seq_item) item_collected_port;

    function new(string name = "cv32e40p_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual cv32e40p_if)::get(this, "", "vif", vif))
            `uvm_fatal("MONITOR", "Could not get vif")
        item_collected_port = new("item_collected_port", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        cv32e40p_seq_item trans;
        forever begin
            @(posedge vif.clk_i);
            trans = cv32e40p_seq_item::type_id::create("trans");
            collect_transaction(trans);
            item_collected_port.write(trans);
        end
    endtask

    virtual task collect_transaction(cv32e40p_seq_item trans);
        // Collect input signals
        trans.rst_ni = vif.rst_ni;
        trans.pulp_clock_en_i = vif.pulp_clock_en_i;
        trans.scan_cg_en_i = vif.scan_cg_en_i;
        trans.boot_addr_i = vif.boot_addr_i;
        trans.mtvec_addr_i = vif.mtvec_addr_i;
        trans.dm_halt_addr_i = vif.dm_halt_addr_i;
        trans.hart_id_i = vif.hart_id_i;
        trans.dm_exception_addr_i = vif.dm_exception_addr_i;
        trans.instr_gnt_i = vif.instr_gnt_i;
        trans.instr_rvalid_i = vif.instr_rvalid_i;
        trans.instr_rdata_i = vif.instr_rdata_i;
        trans.data_gnt_i = vif.data_gnt_i;
        trans.data_rvalid_i = vif.data_rvalid_i;
        trans.data_rdata_i = vif.data_rdata_i;
        trans.irq_i = vif.irq_i;
        trans.debug_req_i = vif.debug_req_i;
        trans.fetch_enable_i = vif.fetch_enable_i;

        // Collect output signals
        trans.instr_req_o = vif.instr_req_o;
        trans.instr_addr_o = vif.instr_addr_o;
        trans.data_req_o = vif.data_req_o;
        trans.data_we_o = vif.data_we_o;
        trans.data_be_o = vif.data_be_o;
        trans.data_addr_o = vif.data_addr_o;
        trans.data_wdata_o = vif.data_wdata_o;
        trans.irq_ack_o = vif.irq_ack_o;
        trans.irq_id_o = vif.irq_id_o;
        trans.debug_havereset_o = vif.debug_havereset_o;
        trans.debug_running_o = vif.debug_running_o;
        trans.debug_halted_o = vif.debug_halted_o;
        trans.core_sleep_o = vif.core_sleep_o;
    endtask

endclass