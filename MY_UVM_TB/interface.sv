interface cv32e40p_if #(
    parameter COREV_PULP = 0,
    parameter COREV_CLUSTER = 0,
    parameter FPU = 0,
    parameter FPU_ADDMUL_LAT = 0,
    parameter FPU_OTHERS_LAT = 0,
    parameter ZFINX = 0,
    parameter NUM_MHPMCOUNTERS = 1
);

    // Clock and Reset
    logic clk_i;
    logic rst_ni;

    logic pulp_clock_en_i;
    logic scan_cg_en_i;

    // Core ID, Cluster ID, debug mode halt address and boot address
    logic [31:0] boot_addr_i;
    logic [31:0] mtvec_addr_i;
    logic [31:0] dm_halt_addr_i;
    logic [31:0] hart_id_i;
    logic [31:0] dm_exception_addr_i;

    // Instruction memory interface
    logic        instr_req_o;
    logic        instr_gnt_i;
    logic        instr_rvalid_i;
    logic [31:0] instr_addr_o;
    logic [31:0] instr_rdata_i;

    // Data memory interface
    logic        data_req_o;
    logic        data_gnt_i;
    logic        data_rvalid_i;
    logic        data_we_o;
    logic [ 3:0] data_be_o;
    logic [31:0] data_addr_o;
    logic [31:0] data_wdata_o;
    logic [31:0] data_rdata_i;

    // Interrupt inputs
    logic [31:0] irq_i;
    logic        irq_ack_o;
    logic [ 4:0] irq_id_o;

    // Debug Interface
    logic debug_req_i;
    logic debug_havereset_o;
    logic debug_running_o;
    logic debug_halted_o;

    // CPU Control Signals
    logic fetch_enable_i;
    logic core_sleep_o;

endinterface