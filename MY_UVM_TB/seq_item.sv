class cv32e40p_seq_item extends uvm_sequence_item;

    // Clock and Reset
    rand logic rst_ni;
    
    // Core configuration
    rand logic pulp_clock_en_i;
    rand logic scan_cg_en_i;
    
    // Core ID, Cluster ID, debug mode halt address and boot address
    rand logic [31:0] boot_addr_i;
    rand logic [31:0] mtvec_addr_i;
    rand logic [31:0] dm_halt_addr_i;
    rand logic [31:0] hart_id_i;
    rand logic [31:0] dm_exception_addr_i;
    
    // Instruction memory interface inputs
    rand logic        instr_gnt_i;
    rand logic        instr_rvalid_i;
    rand logic [31:0] instr_rdata_i;
    
    // Data memory interface inputs
    rand logic        data_gnt_i;
    rand logic        data_rvalid_i;
    rand logic [31:0] data_rdata_i;
    
    // Interrupt inputs
    rand logic [31:0] irq_i;
    
    // Debug Interface inputs
    rand logic debug_req_i;
    
    // CPU Control Signals inputs
    rand logic fetch_enable_i;
    
    // Outputs (for monitoring/checking)
    logic        instr_req_o;
    logic [31:0] instr_addr_o;
    logic        data_req_o;
    logic        data_we_o;
    logic [ 3:0] data_be_o;
    logic [31:0] data_addr_o;
    logic [31:0] data_wdata_o;
    logic        irq_ack_o;
    logic [ 4:0] irq_id_o;
    logic        debug_havereset_o;
    logic        debug_running_o;
    logic        debug_halted_o;
    logic        core_sleep_o;

    `uvm_object_utils(cv32e40p_seq_item)

    function new(string name = "cv32e40p_seq_item");
        super.new(name);
    endfunction

endclass