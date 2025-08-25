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

    `uvm_object_utils_begin(cv32e40p_seq_item)
        `uvm_field_int(rst_ni, UVM_ALL_ON)
        `uvm_field_int(pulp_clock_en_i, UVM_ALL_ON)
        `uvm_field_int(scan_cg_en_i, UVM_ALL_ON)
        `uvm_field_int(boot_addr_i, UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(mtvec_addr_i, UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(dm_halt_addr_i, UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(hart_id_i, UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(dm_exception_addr_i, UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(instr_gnt_i, UVM_ALL_ON)
        `uvm_field_int(instr_rvalid_i, UVM_ALL_ON)
        `uvm_field_int(instr_rdata_i, UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(data_gnt_i, UVM_ALL_ON)
        `uvm_field_int(data_rvalid_i, UVM_ALL_ON)
        `uvm_field_int(data_rdata_i, UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(irq_i, UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(debug_req_i, UVM_ALL_ON)
        `uvm_field_int(fetch_enable_i, UVM_ALL_ON)
        `uvm_field_int(instr_req_o, UVM_ALL_ON)
        `uvm_field_int(instr_addr_o, UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(data_req_o, UVM_ALL_ON)
        `uvm_field_int(data_we_o, UVM_ALL_ON)
        `uvm_field_int(data_be_o, UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(data_addr_o, UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(data_wdata_o, UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(irq_ack_o, UVM_ALL_ON)
        `uvm_field_int(irq_id_o, UVM_ALL_ON)
        `uvm_field_int(debug_havereset_o, UVM_ALL_ON)
        `uvm_field_int(debug_running_o, UVM_ALL_ON)
        `uvm_field_int(debug_halted_o, UVM_ALL_ON)
        `uvm_field_int(core_sleep_o, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "cv32e40p_seq_item");
        super.new(name);
    endfunction

    // Constraints for proper packet generation
    constraint reset_constraint {
        rst_ni dist {1 := 95, 0 := 5}; // Reset mostly inactive
    }

    constraint clock_enable_constraint {
        pulp_clock_en_i == 1'b1; // Clock always enabled
        scan_cg_en_i == 1'b0;    // Scan mode disabled
    }

    constraint address_constraint {
        boot_addr_i inside {[32'h00000000:32'h0000FFFF]}; // Valid boot address range
        mtvec_addr_i inside {[32'h00000000:32'h0000FFFF]}; // Valid mtvec address range
        dm_halt_addr_i inside {[32'h00000000:32'h0000FFFF]}; // Valid debug halt address
        dm_exception_addr_i inside {[32'h00000000:32'h0000FFFF]}; // Valid debug exception address
        hart_id_i inside {[0:15]}; // Reasonable hart ID range
    }

    constraint memory_interface_constraint {
        // Instruction memory interface
        instr_gnt_i dist {1 := 80, 0 := 20}; // Grant mostly high
        instr_rvalid_i dist {1 := 70, 0 := 30}; // Valid mostly high
        
        // Data memory interface  
        data_gnt_i dist {1 := 80, 0 := 20}; // Grant mostly high
        data_rvalid_i dist {1 := 70, 0 := 30}; // Valid mostly high
    }

    constraint interrupt_constraint {
        irq_i dist {0 := 90, [1:32'hFFFFFFFF] := 10}; // Interrupts mostly disabled
    }

    constraint debug_constraint {
        debug_req_i dist {0 := 95, 1 := 5}; // Debug requests rare
    }

    constraint fetch_constraint {
        fetch_enable_i dist {1 := 90, 0 := 10}; // Fetch mostly enabled
    }

    constraint instruction_data_constraint {
        // Valid RISC-V instruction patterns
        instr_rdata_i[1:0] == 2'b11; // 32-bit instruction encoding
        
        // Bias towards common instruction types
        instr_rdata_i[6:0] dist {
            7'b0110011 := 25, // R-type (ADD, SUB, etc.)
            7'b0010011 := 25, // I-type (ADDI, etc.)
            7'b0000011 := 15, // Load
            7'b0100011 := 15, // Store
            7'b1100011 := 10, // Branch
            7'b1110011 := 5,  // System/CSR
            7'b0101011 := 3,  // CV32E40P Custom ALU
            7'b1011011 := 2   // CV32E40P Custom IMM
        };
    }

    // Custom print function for detailed instruction analysis
    function string instruction_decode();
        string opcode_str, funct3_str, funct7_str, decode_str;
        logic [6:0] opcode = instr_rdata_i[6:0];
        logic [2:0] funct3 = instr_rdata_i[14:12];
        logic [6:0] funct7 = instr_rdata_i[31:25];
        
        case (opcode)
            7'b0110011: begin // R-type
                opcode_str = "R-TYPE";
                case ({funct7, funct3})
                    {7'b0000000, 3'b000}: decode_str = "ADD";
                    {7'b0100000, 3'b000}: decode_str = "SUB";
                    {7'b0000000, 3'b001}: decode_str = "SLL";
                    {7'b0000000, 3'b010}: decode_str = "SLT";
                    {7'b0000000, 3'b011}: decode_str = "SLTU";
                    {7'b0000000, 3'b100}: decode_str = "XOR";
                    {7'b0000000, 3'b101}: decode_str = "SRL";
                    {7'b0100000, 3'b101}: decode_str = "SRA";
                    {7'b0000000, 3'b110}: decode_str = "OR";
                    {7'b0000000, 3'b111}: decode_str = "AND";
                    default: decode_str = "UNKNOWN_R";
                endcase
            end
            7'b0010011: begin // I-type
                opcode_str = "I-TYPE";
                case (funct3)
                    3'b000: decode_str = "ADDI";
                    3'b010: decode_str = "SLTI";
                    3'b011: decode_str = "SLTIU";
                    3'b100: decode_str = "XORI";
                    3'b110: decode_str = "ORI";
                    3'b111: decode_str = "ANDI";
                    3'b001: decode_str = "SLLI";
                    3'b101: decode_str = (funct7[5]) ? "SRAI" : "SRLI";
                    default: decode_str = "UNKNOWN_I";
                endcase
            end
            7'b0101011: begin // CV32E40P Custom ALU
                opcode_str = "CV_ALU";
                case ({funct7, funct3})
                    {7'b0101000, 3'b011}: decode_str = "CV.ABS";
                    {7'b0101011, 3'b011}: decode_str = "CV.MIN";
                    {7'b0101101, 3'b011}: decode_str = "CV.MAX";
                    {7'b0100001, 3'b011}: decode_str = "CV.FF1";
                    {7'b0100100, 3'b011}: decode_str = "CV.CNT";
                    default: decode_str = "UNKNOWN_CV_ALU";
                endcase
            end
            7'b1011011: begin // CV32E40P Custom IMM
                opcode_str = "CV_IMM";
                case (instr_rdata_i[31:30])
                    2'b00: decode_str = "CV.EXTRACT";
                    2'b10: decode_str = "CV.INSERT";
                    default: decode_str = "UNKNOWN_CV_IMM";
                endcase
            end
            7'b1110011: begin // System
                opcode_str = "SYSTEM";
                case (funct3)
                    3'b000: decode_str = "ECALL/EBREAK";
                    3'b001: decode_str = "CSRRW";
                    3'b010: decode_str = "CSRRS";
                    3'b011: decode_str = "CSRRC";
                    3'b101: decode_str = "CSRRWI";
                    3'b110: decode_str = "CSRRSI";
                    3'b111: decode_str = "CSRRCI";
                    default: decode_str = "UNKNOWN_SYS";
                endcase
            end
            7'b0000011: begin
                opcode_str = "LOAD";
                case (funct3)
                    3'b000: decode_str = "LB";
                    3'b001: decode_str = "LH";
                    3'b010: decode_str = "LW";
                    3'b100: decode_str = "LBU";
                    3'b101: decode_str = "LHU";
                    default: decode_str = "UNKNOWN_LOAD";
                endcase
            end
            7'b0100011: begin
                opcode_str = "STORE";
                case (funct3)
                    3'b000: decode_str = "SB";
                    3'b001: decode_str = "SH";
                    3'b010: decode_str = "SW";
                    default: decode_str = "UNKNOWN_STORE";
                endcase
            end
            7'b1100011: begin
                opcode_str = "BRANCH";
                case (funct3)
                    3'b000: decode_str = "BEQ";
                    3'b001: decode_str = "BNE";
                    3'b100: decode_str = "BLT";
                    3'b101: decode_str = "BGE";
                    3'b110: decode_str = "BLTU";
                    3'b111: decode_str = "BGEU";
                    default: decode_str = "UNKNOWN_BRANCH";
                endcase
            end
            default: begin
                opcode_str = "UNKNOWN";
                decode_str = "UNKNOWN_INSTR";
            end
        endcase
        
        return $sformatf("%s (%s) - Raw: 0x%08h", decode_str, opcode_str, instr_rdata_i);
    endfunction

endclass