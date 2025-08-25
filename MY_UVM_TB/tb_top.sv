module tb_top;

    import uvm_pkg::*;
    import risc_tb_package::*;
    `include "uvm_macros.svh"

    // Clock and reset generation
    logic clk;
    logic rst_n;

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end

    // Reset generation
    initial begin
        rst_n = 0;
        #100;
        rst_n = 1;
    end

    // Interface instantiation
    cv32e40p_if #(
        .COREV_PULP(0),
        .COREV_CLUSTER(0),
        .FPU(0),
        .FPU_ADDMUL_LAT(0),
        .FPU_OTHERS_LAT(0),
        .ZFINX(0),
        .NUM_MHPMCOUNTERS(1)
    ) cv32e40p_if_inst();

    // Connect clock and reset to interface
    assign cv32e40p_if_inst.clk_i = clk;
    assign cv32e40p_if_inst.rst_ni = rst_n;
    
    // Initialize interface signals
    initial begin
        cv32e40p_if_inst.pulp_clock_en_i = 1'b1;
        cv32e40p_if_inst.scan_cg_en_i = 1'b0;
        cv32e40p_if_inst.boot_addr_i = 32'h80;
        cv32e40p_if_inst.mtvec_addr_i = 32'h0;
        cv32e40p_if_inst.dm_halt_addr_i = 32'h800;
        cv32e40p_if_inst.hart_id_i = 32'h0;
        cv32e40p_if_inst.dm_exception_addr_i = 32'h0;
        cv32e40p_if_inst.fetch_enable_i = 1'b1;
        cv32e40p_if_inst.debug_req_i = 1'b0;
        cv32e40p_if_inst.irq_i = 32'h0;
        
        // Memory interface responses
        cv32e40p_if_inst.instr_gnt_i = 1'b1;
        cv32e40p_if_inst.instr_rvalid_i = 1'b0;
        cv32e40p_if_inst.instr_rdata_i = 32'h0;
        cv32e40p_if_inst.data_gnt_i = 1'b1;
        cv32e40p_if_inst.data_rvalid_i = 1'b0;
        cv32e40p_if_inst.data_rdata_i = 32'h0;
    end

    // Simple instruction memory model
    always @(posedge clk) begin
        if (rst_n) begin
            // Respond to instruction fetch requests
            if (cv32e40p_if_inst.instr_req_o && cv32e40p_if_inst.instr_gnt_i) begin
                cv32e40p_if_inst.instr_rvalid_i <= #1 1'b1;
                // Provide a simple NOP instruction (ADDI x0, x0, 0)
                cv32e40p_if_inst.instr_rdata_i <= #1 32'h00000013;
            end else begin
                cv32e40p_if_inst.instr_rvalid_i <= #1 1'b0;
            end
            
            // Respond to data memory requests
            if (cv32e40p_if_inst.data_req_o && cv32e40p_if_inst.data_gnt_i) begin
                cv32e40p_if_inst.data_rvalid_i <= #1 1'b1;
                cv32e40p_if_inst.data_rdata_i <= #1 32'h0;
            end else begin
                cv32e40p_if_inst.data_rvalid_i <= #1 1'b0;
            end
        end else begin
            cv32e40p_if_inst.instr_rvalid_i <= 1'b0;
            cv32e40p_if_inst.data_rvalid_i <= 1'b0;
        end
    end

    // DUT instantiation
    cv32e40p_top #(
        .COREV_PULP(0),
        .COREV_CLUSTER(0),
        .FPU(0),
        .FPU_ADDMUL_LAT(0),
        .FPU_OTHERS_LAT(0),
        .ZFINX(0),
        .NUM_MHPMCOUNTERS(1)
    ) dut (
        // Clock and Reset
        .clk_i(cv32e40p_if_inst.clk_i),
        .rst_ni(cv32e40p_if_inst.rst_ni),
        
        // PULP and scan signals
        .pulp_clock_en_i(cv32e40p_if_inst.pulp_clock_en_i),
        .scan_cg_en_i(cv32e40p_if_inst.scan_cg_en_i),
        
        // Core configuration
        .boot_addr_i(cv32e40p_if_inst.boot_addr_i),
        .mtvec_addr_i(cv32e40p_if_inst.mtvec_addr_i),
        .dm_halt_addr_i(cv32e40p_if_inst.dm_halt_addr_i),
        .hart_id_i(cv32e40p_if_inst.hart_id_i),
        .dm_exception_addr_i(cv32e40p_if_inst.dm_exception_addr_i),
        
        // Instruction memory interface
        .instr_req_o(cv32e40p_if_inst.instr_req_o),
        .instr_gnt_i(cv32e40p_if_inst.instr_gnt_i),
        .instr_rvalid_i(cv32e40p_if_inst.instr_rvalid_i),
        .instr_addr_o(cv32e40p_if_inst.instr_addr_o),
        .instr_rdata_i(cv32e40p_if_inst.instr_rdata_i),
        
        // Data memory interface
        .data_req_o(cv32e40p_if_inst.data_req_o),
        .data_gnt_i(cv32e40p_if_inst.data_gnt_i),
        .data_rvalid_i(cv32e40p_if_inst.data_rvalid_i),
        .data_we_o(cv32e40p_if_inst.data_we_o),
        .data_be_o(cv32e40p_if_inst.data_be_o),
        .data_addr_o(cv32e40p_if_inst.data_addr_o),
        .data_wdata_o(cv32e40p_if_inst.data_wdata_o),
        .data_rdata_i(cv32e40p_if_inst.data_rdata_i),
        
        // Interrupt inputs
        .irq_i(cv32e40p_if_inst.irq_i),
        .irq_ack_o(cv32e40p_if_inst.irq_ack_o),
        .irq_id_o(cv32e40p_if_inst.irq_id_o),
        
        // Debug Interface
        .debug_req_i(cv32e40p_if_inst.debug_req_i),
        .debug_havereset_o(cv32e40p_if_inst.debug_havereset_o),
        .debug_running_o(cv32e40p_if_inst.debug_running_o),
        .debug_halted_o(cv32e40p_if_inst.debug_halted_o),
        
        // CPU Control Signals
        .fetch_enable_i(cv32e40p_if_inst.fetch_enable_i),
        .core_sleep_o(cv32e40p_if_inst.core_sleep_o)
    );

    // UVM testbench initialization
    initial begin
        // Set interface in config_db
        uvm_config_db#(virtual cv32e40p_if)::set(null, "*", "vif", cv32e40p_if_inst);
        
        // Run the test (test name will be taken from +UVM_TESTNAME)
        run_test();
    end

    // Optional: Waveform dumping
    initial begin
        $dumpfile("waves.vcd");
        $dumpvars(0, tb_top);
    end

endmodule
