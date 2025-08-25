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
        int monitor_count = 0;
        
        `uvm_info("MONITOR", "Starting monitor run_phase", UVM_MEDIUM)
        
        forever begin
            @(posedge vif.clk_i);
            trans = cv32e40p_seq_item::type_id::create("trans");
            collect_transaction(trans);
            monitor_count++;
            
            `uvm_info("MONITOR", $sformatf("=== MONITORING TRANSACTION #%0d ===", monitor_count), UVM_MEDIUM)
            analyze_and_report(trans);
            
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

    virtual function void analyze_and_report(cv32e40p_seq_item trans);
        // Report instruction being processed
        if (trans.instr_rvalid_i && trans.instr_gnt_i) begin
            `uvm_info("MONITOR", $sformatf("INSTRUCTION RECEIVED: %s", trans.instruction_decode()), UVM_MEDIUM)
        end
        
        // Report instruction fetch requests
        if (trans.instr_req_o) begin
            `uvm_info("MONITOR", $sformatf("INSTRUCTION FETCH REQUEST: addr=0x%08h", trans.instr_addr_o), UVM_MEDIUM)
        end
        
        // Report data memory transactions
        if (trans.data_req_o) begin
            if (trans.data_we_o) begin
                `uvm_info("MONITOR", $sformatf("DATA WRITE: addr=0x%08h, data=0x%08h, be=0x%01h", 
                          trans.data_addr_o, trans.data_wdata_o, trans.data_be_o), UVM_MEDIUM)
            end else begin
                `uvm_info("MONITOR", $sformatf("DATA READ REQUEST: addr=0x%08h", trans.data_addr_o), UVM_MEDIUM)
            end
        end
        
        // Report interrupt handling
        if (trans.irq_ack_o) begin
            `uvm_info("MONITOR", $sformatf("INTERRUPT ACKNOWLEDGED: irq_id=%0d", trans.irq_id_o), UVM_HIGH)
        end
        
        // Report debug state changes
        if (trans.debug_halted_o) begin
            `uvm_info("MONITOR", "*** CORE ENTERED DEBUG HALT STATE ***", UVM_HIGH)
        end
        if (trans.debug_running_o) begin
            `uvm_info("MONITOR", "*** CORE RUNNING IN DEBUG MODE ***", UVM_HIGH)
        end
        if (trans.debug_havereset_o) begin
            `uvm_info("MONITOR", "*** DEBUG RESET DETECTED ***", UVM_HIGH)
        end
        
        // Report core sleep state
        if (trans.core_sleep_o) begin
            `uvm_info("MONITOR", "*** CORE ENTERED SLEEP STATE ***", UVM_HIGH)
        end
        
        // Report reset state
        if (!trans.rst_ni) begin
            `uvm_info("MONITOR", "*** CORE IN RESET STATE ***", UVM_HIGH)
        end
        
        // Log detailed signal states at HIGH verbosity
        `uvm_info("MONITOR", $sformatf("INPUT SIGNALS: rst=%b, fetch_en=%b, debug_req=%b", 
                  trans.rst_ni, trans.fetch_enable_i, trans.debug_req_i), UVM_HIGH)
        `uvm_info("MONITOR", $sformatf("MEMORY INTERFACE: instr_req=%b, data_req=%b, data_we=%b", 
                  trans.instr_req_o, trans.data_req_o, trans.data_we_o), UVM_HIGH)
        `uvm_info("MONITOR", $sformatf("INTERRUPT STATUS: irq_pending=0x%08h, irq_ack=%b", 
                  trans.irq_i, trans.irq_ack_o), UVM_HIGH)
    endfunction

endclass