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
        int transaction_count = 0;
        
        `uvm_info("DRIVER", "Starting driver run_phase", UVM_MEDIUM)
        
        forever begin
            seq_item_port.get_next_item(req);
            transaction_count++;
            
            `uvm_info("DRIVER", $sformatf("=== DRIVING TRANSACTION #%0d ===", transaction_count), UVM_MEDIUM)
            `uvm_info("DRIVER", $sformatf("Instruction: %s", req.instruction_decode()), UVM_MEDIUM)
            
            // Log key control signals
            if (req.rst_ni == 0)
                `uvm_info("DRIVER", "*** RESET ASSERTED ***", UVM_HIGH)
            if (req.debug_req_i == 1)
                `uvm_info("DRIVER", "*** DEBUG REQUEST ASSERTED ***", UVM_HIGH)
            if (req.irq_i != 0)
                `uvm_info("DRIVER", $sformatf("*** INTERRUPT PENDING: 0x%08h ***", req.irq_i), UVM_HIGH)
            
            drive(req);
            seq_item_port.item_done();
            
            `uvm_info("DRIVER", "Transaction driven to DUT", UVM_MEDIUM)
        end
    endtask

    virtual task drive(cv32e40p_seq_item req);
        // Log before driving
        `uvm_info("DRIVER", "Driving signals to DUT interface:", UVM_HIGH)
        `uvm_info("DRIVER", $sformatf("  rst_ni=%b, fetch_enable=%b", req.rst_ni, req.fetch_enable_i), UVM_HIGH)
        `uvm_info("DRIVER", $sformatf("  instr_gnt=%b, instr_rvalid=%b", req.instr_gnt_i, req.instr_rvalid_i), UVM_HIGH)
        `uvm_info("DRIVER", $sformatf("  instr_rdata=0x%08h", req.instr_rdata_i), UVM_HIGH)
        `uvm_info("DRIVER", $sformatf("  data_gnt=%b, data_rvalid=%b, data_rdata=0x%08h", 
                  req.data_gnt_i, req.data_rvalid_i, req.data_rdata_i), UVM_HIGH)
        
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
        
        // Log after driving
        `uvm_info("DRIVER", "All signals successfully driven to interface", UVM_HIGH)
    endtask

endclass