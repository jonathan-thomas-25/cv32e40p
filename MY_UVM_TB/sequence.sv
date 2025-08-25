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

class cv32e40p_reset_sequence extends cv32e40p_base_sequence;

    `uvm_object_utils(cv32e40p_reset_sequence)

    function new(string name = "cv32e40p_reset_sequence");
        super.new(name);
    endfunction

    virtual task body();
        cv32e40p_seq_item req;
        
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { rst_ni == 1'b0; });
        finish_item(req);
    endtask

endclass

// ALU Arithmetic Operations Sequences
class cv32e40p_alu_add_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_alu_add_sequence)
    
    function new(string name = "cv32e40p_alu_add_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == 7'b0110011; // R-type opcode
            instr_rdata_i[14:12] == 3'b000;   // funct3 for ADD
            instr_rdata_i[31:25] == 7'b0000000; // funct7 for ADD
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_alu_sub_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_alu_sub_sequence)
    
    function new(string name = "cv32e40p_alu_sub_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == 7'b0110011; // R-type opcode
            instr_rdata_i[14:12] == 3'b000;   // funct3 for SUB
            instr_rdata_i[31:25] == 7'b0100000; // funct7 for SUB
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_alu_xor_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_alu_xor_sequence)
    
    function new(string name = "cv32e40p_alu_xor_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == 7'b0110011; // R-type opcode
            instr_rdata_i[14:12] == 3'b100;   // funct3 for XOR
            instr_rdata_i[31:25] == 7'b0000000; // funct7 for XOR
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_alu_or_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_alu_or_sequence)
    
    function new(string name = "cv32e40p_alu_or_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == 7'b0110011; // R-type opcode
            instr_rdata_i[14:12] == 3'b110;   // funct3 for OR
            instr_rdata_i[31:25] == 7'b0000000; // funct7 for OR
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_alu_and_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_alu_and_sequence)
    
    function new(string name = "cv32e40p_alu_and_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == 7'b0110011; // R-type opcode
            instr_rdata_i[14:12] == 3'b111;   // funct3 for AND
            instr_rdata_i[31:25] == 7'b0000000; // funct7 for AND
        });
        finish_item(req);
    endtask
endclass

// ALU Shift Operations Sequences
class cv32e40p_alu_sll_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_alu_sll_sequence)
    
    function new(string name = "cv32e40p_alu_sll_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == 7'b0110011; // R-type opcode
            instr_rdata_i[14:12] == 3'b001;   // funct3 for SLL
            instr_rdata_i[31:25] == 7'b0000000; // funct7 for SLL
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_alu_srl_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_alu_srl_sequence)
    
    function new(string name = "cv32e40p_alu_srl_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == 7'b0110011; // R-type opcode
            instr_rdata_i[14:12] == 3'b101;   // funct3 for SRL
            instr_rdata_i[31:25] == 7'b0000000; // funct7 for SRL
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_alu_sra_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_alu_sra_sequence)
    
    function new(string name = "cv32e40p_alu_sra_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == 7'b0110011; // R-type opcode
            instr_rdata_i[14:12] == 3'b101;   // funct3 for SRA
            instr_rdata_i[31:25] == 7'b0100000; // funct7 for SRA
        });
        finish_item(req);
    endtask
endclass

// ALU Comparison Operations Sequences
class cv32e40p_alu_slt_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_alu_slt_sequence)
    
    function new(string name = "cv32e40p_alu_slt_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == 7'b0110011; // R-type opcode
            instr_rdata_i[14:12] == 3'b010;   // funct3 for SLT
            instr_rdata_i[31:25] == 7'b0000000; // funct7 for SLT
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_alu_sltu_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_alu_sltu_sequence)
    
    function new(string name = "cv32e40p_alu_sltu_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == 7'b0110011; // R-type opcode
            instr_rdata_i[14:12] == 3'b011;   // funct3 for SLTU
            instr_rdata_i[31:25] == 7'b0000000; // funct7 for SLTU
        });
        finish_item(req);
    endtask
endclass

// CV32E40P Custom ALU Operations Sequences
class cv32e40p_cv_abs_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_cv_abs_sequence)
    
    function new(string name = "cv32e40p_cv_abs_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == 7'b0101011; // CV_ALU_OPCODE_1
            instr_rdata_i[14:12] == 3'b011;   // funct3
            instr_rdata_i[31:25] == 7'b0101000; // funct7 for CV_ABS
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_cv_min_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_cv_min_sequence)
    
    function new(string name = "cv32e40p_cv_min_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == 7'b0101011; // CV_ALU_OPCODE_1
            instr_rdata_i[14:12] == 3'b011;   // funct3
            instr_rdata_i[31:25] == 7'b0101011; // funct7 for CV_MIN
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_cv_max_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_cv_max_sequence)
    
    function new(string name = "cv32e40p_cv_max_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == 7'b0101011; // CV_ALU_OPCODE_1
            instr_rdata_i[14:12] == 3'b011;   // funct3
            instr_rdata_i[31:25] == 7'b0101101; // funct7 for CV_MAX
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_cv_ff1_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_cv_ff1_sequence)
    
    function new(string name = "cv32e40p_cv_ff1_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == 7'b0101011; // CV_ALU_OPCODE_1
            instr_rdata_i[14:12] == 3'b011;   // funct3
            instr_rdata_i[31:25] == 7'b0100001; // funct7 for CV_FF1
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_cv_cnt_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_cv_cnt_sequence)
    
    function new(string name = "cv32e40p_cv_cnt_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == 7'b0101011; // CV_ALU_OPCODE_1
            instr_rdata_i[14:12] == 3'b011;   // funct3
            instr_rdata_i[31:25] == 7'b0100100; // funct7 for CV_CNT
        });
        finish_item(req);
    endtask
endclass

// Immediate-based CV32E40P Custom Operations
class cv32e40p_cv_extract_imm_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_cv_extract_imm_sequence)
    
    function new(string name = "cv32e40p_cv_extract_imm_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == 7'b1011011; // CV_ALU_OPCODE_2
            instr_rdata_i[14:12] == 3'b000;   // funct3 for extract
            instr_rdata_i[31:30] == 2'b00;    // f2 for CV_EXTRACT_IMM
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_cv_insert_imm_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_cv_insert_imm_sequence)
    
    function new(string name = "cv32e40p_cv_insert_imm_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == 7'b1011011; // CV_ALU_OPCODE_2
            instr_rdata_i[14:12] == 3'b000;   // funct3 for insert
            instr_rdata_i[31:30] == 2'b10;    // f2 for CV_INSERT_IMM
        });
        finish_item(req);
    endtask
endclass

// Grouped Instruction Type Sequences
class cv32e40p_arithmetic_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_arithmetic_sequence)
    
    function new(string name = "cv32e40p_arithmetic_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_alu_add_sequence add_seq;
        cv32e40p_alu_sub_sequence sub_seq;
        cv32e40p_alu_xor_sequence xor_seq;
        cv32e40p_alu_or_sequence or_seq;
        cv32e40p_alu_and_sequence and_seq;
        
        repeat(5) begin
            case($urandom_range(0, 4))
                0: begin
                    add_seq = cv32e40p_alu_add_sequence::type_id::create("add_seq");
                    add_seq.start(m_sequencer);
                end
                1: begin
                    sub_seq = cv32e40p_alu_sub_sequence::type_id::create("sub_seq");
                    sub_seq.start(m_sequencer);
                end
                2: begin
                    xor_seq = cv32e40p_alu_xor_sequence::type_id::create("xor_seq");
                    xor_seq.start(m_sequencer);
                end
                3: begin
                    or_seq = cv32e40p_alu_or_sequence::type_id::create("or_seq");
                    or_seq.start(m_sequencer);
                end
                4: begin
                    and_seq = cv32e40p_alu_and_sequence::type_id::create("and_seq");
                    and_seq.start(m_sequencer);
                end
            endcase
        end
    endtask
endclass

class cv32e40p_shift_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_shift_sequence)
    
    function new(string name = "cv32e40p_shift_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_alu_sll_sequence sll_seq;
        cv32e40p_alu_srl_sequence srl_seq;
        cv32e40p_alu_sra_sequence sra_seq;
        
        repeat(5) begin
            case($urandom_range(0, 2))
                0: begin
                    sll_seq = cv32e40p_alu_sll_sequence::type_id::create("sll_seq");
                    sll_seq.start(m_sequencer);
                end
                1: begin
                    srl_seq = cv32e40p_alu_srl_sequence::type_id::create("srl_seq");
                    srl_seq.start(m_sequencer);
                end
                2: begin
                    sra_seq = cv32e40p_alu_sra_sequence::type_id::create("sra_seq");
                    sra_seq.start(m_sequencer);
                end
            endcase
        end
    endtask
endclass

class cv32e40p_comparison_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_comparison_sequence)
    
    function new(string name = "cv32e40p_comparison_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_alu_slt_sequence slt_seq;
        cv32e40p_alu_sltu_sequence sltu_seq;
        
        repeat(5) begin
            case($urandom_range(0, 1))
                0: begin
                    slt_seq = cv32e40p_alu_slt_sequence::type_id::create("slt_seq");
                    slt_seq.start(m_sequencer);
                end
                1: begin
                    sltu_seq = cv32e40p_alu_sltu_sequence::type_id::create("sltu_seq");
                    sltu_seq.start(m_sequencer);
                end
            endcase
        end
    endtask
endclass

class cv32e40p_custom_alu_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_custom_alu_sequence)
    
    function new(string name = "cv32e40p_custom_alu_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_cv_abs_sequence abs_seq;
        cv32e40p_cv_min_sequence min_seq;
        cv32e40p_cv_max_sequence max_seq;
        cv32e40p_cv_ff1_sequence ff1_seq;
        cv32e40p_cv_cnt_sequence cnt_seq;
        
        repeat(5) begin
            case($urandom_range(0, 4))
                0: begin
                    abs_seq = cv32e40p_cv_abs_sequence::type_id::create("abs_seq");
                    abs_seq.start(m_sequencer);
                end
                1: begin
                    min_seq = cv32e40p_cv_min_sequence::type_id::create("min_seq");
                    min_seq.start(m_sequencer);
                end
                2: begin
                    max_seq = cv32e40p_cv_max_sequence::type_id::create("max_seq");
                    max_seq.start(m_sequencer);
                end
                3: begin
                    ff1_seq = cv32e40p_cv_ff1_sequence::type_id::create("ff1_seq");
                    ff1_seq.start(m_sequencer);
                end
                4: begin
                    cnt_seq = cv32e40p_cv_cnt_sequence::type_id::create("cnt_seq");
                    cnt_seq.start(m_sequencer);
                end
            endcase
        end
    endtask
endclass

class cv32e40p_custom_imm_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_custom_imm_sequence)
    
    function new(string name = "cv32e40p_custom_imm_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_cv_extract_imm_sequence extract_seq;
        cv32e40p_cv_insert_imm_sequence insert_seq;
        
        repeat(5) begin
            case($urandom_range(0, 1))
                0: begin
                    extract_seq = cv32e40p_cv_extract_imm_sequence::type_id::create("extract_seq");
                    extract_seq.start(m_sequencer);
                end
                1: begin
                    insert_seq = cv32e40p_cv_insert_imm_sequence::type_id::create("insert_seq");
                    insert_seq.start(m_sequencer);
                end
            endcase
        end
    endtask
endclass

// Data Dependency Sequence - Creates RAW (Read After Write) hazard
class cv32e40p_data_dependency_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_data_dependency_sequence)
    
    function new(string name = "cv32e40p_data_dependency_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_seq_item req1, req2;
        logic [4:0] shared_reg;
        logic [4:0] rs1_reg, rs2_reg;
        
        // Generate first instruction (producer)
        req1 = cv32e40p_seq_item::type_id::create("req1");
        start_item(req1);
        assert(req1.randomize() with { 
            instr_rdata_i[6:0] == 7'b0110011; // R-type opcode
            instr_rdata_i[14:12] == 3'b000;   // funct3 for ADD
            instr_rdata_i[31:25] == 7'b0000000; // funct7 for ADD
            instr_rdata_i[11:7] != 5'b00000;  // rd != x0 (not zero register)
        });
        shared_reg = req1.instr_rdata_i[11:7]; // Extract destination register
        finish_item(req1);
        
        // Generate second instruction (consumer) with data dependency
        req2 = cv32e40p_seq_item::type_id::create("req2");
        start_item(req2);
        assert(req2.randomize() with { 
            instr_rdata_i[6:0] == 7'b0110011; // R-type opcode
            instr_rdata_i[14:12] == 3'b000;   // funct3 for ADD
            instr_rdata_i[31:25] == 7'b0000000; // funct7 for ADD
            // Create data dependency: rs1 or rs2 matches rd of first instruction
            (instr_rdata_i[19:15] == shared_reg) || (instr_rdata_i[24:20] == shared_reg);
            instr_rdata_i[11:7] != 5'b00000;  // rd != x0
        });
        finish_item(req2);
        
        `uvm_info("DATA_DEP_SEQ", $sformatf("Generated data dependency: Instr1 rd=x%0d, Instr2 rs1=x%0d rs2=x%0d", 
                  shared_reg, req2.instr_rdata_i[19:15], req2.instr_rdata_i[24:20]), UVM_MEDIUM)
    endtask
endclass

// WAW (Write-After-Write) Hazard Sequence - Creates output dependency
class cv32e40p_waw_hazard_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_waw_hazard_sequence)
    
    function new(string name = "cv32e40p_waw_hazard_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_seq_item req1, req2;
        logic [4:0] shared_dest_reg;
        
        // Generate first instruction (first writer)
        req1 = cv32e40p_seq_item::type_id::create("req1");
        start_item(req1);
        assert(req1.randomize() with { 
            instr_rdata_i[6:0] == 7'b0110011; // R-type opcode
            instr_rdata_i[14:12] == 3'b000;   // funct3 for ADD
            instr_rdata_i[31:25] == 7'b0000000; // funct7 for ADD
            instr_rdata_i[11:7] != 5'b00000;  // rd != x0 (not zero register)
        });
        shared_dest_reg = req1.instr_rdata_i[11:7]; // Extract destination register
        finish_item(req1);
        
        // Generate second instruction (second writer) with WAW hazard
        req2 = cv32e40p_seq_item::type_id::create("req2");
        start_item(req2);
        assert(req2.randomize() with { 
            instr_rdata_i[6:0] == 7'b0110011; // R-type opcode
            instr_rdata_i[14:12] == 3'b001;   // funct3 for SLL (different operation)
            instr_rdata_i[31:25] == 7'b0000000; // funct7 for SLL
            // Create WAW hazard: rd of second instruction matches rd of first instruction
            instr_rdata_i[11:7] == shared_dest_reg;
            // Ensure source registers are different from destination to avoid RAW
            instr_rdata_i[19:15] != shared_dest_reg;
            instr_rdata_i[24:20] != shared_dest_reg;
        });
        finish_item(req2);
        
        `uvm_info("WAW_HAZARD_SEQ", $sformatf("Generated WAW hazard: Both instructions write to x%0d", 
                  shared_dest_reg), UVM_MEDIUM)
    endtask
endclass

// WAR (Write-After-Read) Hazard Sequence - Creates anti-dependency
class cv32e40p_war_hazard_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_war_hazard_sequence)
    
    function new(string name = "cv32e40p_war_hazard_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_seq_item req1, req2;
        logic [4:0] shared_reg;
        
        // Generate first instruction (reader)
        req1 = cv32e40p_seq_item::type_id::create("req1");
        start_item(req1);
        assert(req1.randomize() with { 
            instr_rdata_i[6:0] == 7'b0110011; // R-type opcode
            instr_rdata_i[14:12] == 3'b000;   // funct3 for ADD
            instr_rdata_i[31:25] == 7'b0000000; // funct7 for ADD
            instr_rdata_i[11:7] != 5'b00000;  // rd != x0
            instr_rdata_i[19:15] != 5'b00000; // rs1 != x0
        });
        shared_reg = req1.instr_rdata_i[19:15]; // Extract source register (rs1)
        finish_item(req1);
        
        // Generate second instruction (writer) with WAR hazard
        req2 = cv32e40p_seq_item::type_id::create("req2");
        start_item(req2);
        assert(req2.randomize() with { 
            instr_rdata_i[6:0] == 7'b0110011; // R-type opcode
            instr_rdata_i[14:12] == 3'b010;   // funct3 for SLT (different operation)
            instr_rdata_i[31:25] == 7'b0000000; // funct7 for SLT
            // Create WAR hazard: rd of second instruction matches rs1 of first instruction
            instr_rdata_i[11:7] == shared_reg;
            // Ensure source registers don't create additional dependencies
            instr_rdata_i[19:15] != shared_reg;
            instr_rdata_i[24:20] != shared_reg;
        });
        finish_item(req2);
        
        `uvm_info("WAR_HAZARD_SEQ", $sformatf("Generated WAR hazard: Instr1 reads x%0d, Instr2 writes x%0d", 
                  shared_reg, shared_reg), UVM_MEDIUM)
    endtask
endclass

// Random Instruction Sequence - Generates completely random instructions
class cv32e40p_random_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_random_sequence)
    
    function new(string name = "cv32e40p_random_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_seq_item req;
        
        repeat(20) begin
            req = cv32e40p_seq_item::type_id::create("req");
            start_item(req);
            assert(req.randomize()); // Completely unconstrained randomization
            finish_item(req);
            `uvm_info("RANDOM_SEQ", $sformatf("Generated random instruction: 0x%08h", req.instr_rdata_i), UVM_MEDIUM)
        end
    endtask
endclass

// CSR Read/Write Sequences
class cv32e40p_csr_read_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_csr_read_sequence)
    
    rand cv32e40p_pkg::csr_num_e csr_addr;
    
    function new(string name = "cv32e40p_csr_read_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == 7'b1110011; // SYSTEM opcode
            instr_rdata_i[14:12] == 3'b010;   // funct3 for CSRRS (read)
            instr_rdata_i[31:20] == csr_addr; // CSR address
            instr_rdata_i[19:15] == 5'b00000; // rs1 = x0 for read-only
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_csr_write_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_csr_write_sequence)
    
    rand cv32e40p_pkg::csr_num_e csr_addr;
    
    function new(string name = "cv32e40p_csr_write_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == 7'b1110011; // SYSTEM opcode
            instr_rdata_i[14:12] == 3'b001;   // funct3 for CSRRW (write)
            instr_rdata_i[31:20] == csr_addr; // CSR address
            instr_rdata_i[19:15] != 5'b00000; // rs1 != x0 for write
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_csr_set_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_csr_set_sequence)
    
    rand cv32e40p_pkg::csr_num_e csr_addr;
    
    function new(string name = "cv32e40p_csr_set_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == 7'b1110011; // SYSTEM opcode
            instr_rdata_i[14:12] == 3'b010;   // funct3 for CSRRS (set)
            instr_rdata_i[31:20] == csr_addr; // CSR address
            instr_rdata_i[19:15] != 5'b00000; // rs1 != x0 for set operation
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_csr_clear_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_csr_clear_sequence)
    
    rand cv32e40p_pkg::csr_num_e csr_addr;
    
    function new(string name = "cv32e40p_csr_clear_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == 7'b1110011; // SYSTEM opcode
            instr_rdata_i[14:12] == 3'b011;   // funct3 for CSRRC (clear)
            instr_rdata_i[31:20] == csr_addr; // CSR address
            instr_rdata_i[19:15] != 5'b00000; // rs1 != x0 for clear operation
        });
        finish_item(req);
    endtask
endclass

// CSR Immediate variants
class cv32e40p_csr_write_imm_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_csr_write_imm_sequence)
    
    rand cv32e40p_pkg::csr_num_e csr_addr;
    
    function new(string name = "cv32e40p_csr_write_imm_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == 7'b1110011; // SYSTEM opcode
            instr_rdata_i[14:12] == 3'b101;   // funct3 for CSRRWI
            instr_rdata_i[31:20] == csr_addr; // CSR address
            instr_rdata_i[19:15] inside {[1:31]}; // 5-bit immediate value
        });
        finish_item(req);
    endtask
endclass

// Combined CSR test sequence
class cv32e40p_csr_test_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_csr_test_sequence)
    
    function new(string name = "cv32e40p_csr_test_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_csr_read_sequence read_seq;
        cv32e40p_csr_write_sequence write_seq;
        cv32e40p_csr_set_sequence set_seq;
        cv32e40p_csr_clear_sequence clear_seq;
        cv32e40p_csr_write_imm_sequence write_imm_seq;
        
        repeat(10) begin
            case($urandom_range(0, 4))
                0: begin
                    read_seq = cv32e40p_csr_read_sequence::type_id::create("read_seq");
                    assert(read_seq.randomize() with { 
                        csr_addr inside {cv32e40p_pkg::CSR_MSTATUS, cv32e40p_pkg::CSR_MIE, cv32e40p_pkg::CSR_MTVEC, cv32e40p_pkg::CSR_MEPC, cv32e40p_pkg::CSR_MCAUSE};
                    });
                    read_seq.start(m_sequencer);
                end
                1: begin
                    write_seq = cv32e40p_csr_write_sequence::type_id::create("write_seq");
                    assert(write_seq.randomize() with { 
                        csr_addr inside {cv32e40p_pkg::CSR_MSTATUS, cv32e40p_pkg::CSR_MIE, cv32e40p_pkg::CSR_MTVEC, cv32e40p_pkg::CSR_MEPC};
                    });
                    write_seq.start(m_sequencer);
                end
                2: begin
                    set_seq = cv32e40p_csr_set_sequence::type_id::create("set_seq");
                    assert(set_seq.randomize() with { 
                        csr_addr inside {cv32e40p_pkg::CSR_MIE, cv32e40p_pkg::CSR_MSTATUS};
                    });
                    set_seq.start(m_sequencer);
                end
                3: begin
                    clear_seq = cv32e40p_csr_clear_sequence::type_id::create("clear_seq");
                    assert(clear_seq.randomize() with { 
                        csr_addr inside {cv32e40p_pkg::CSR_MIE, cv32e40p_pkg::CSR_MSTATUS};
                    });
                    clear_seq.start(m_sequencer);
                end
                4: begin
                    write_imm_seq = cv32e40p_csr_write_imm_sequence::type_id::create("write_imm_seq");
                    assert(write_imm_seq.randomize() with { 
                        csr_addr inside {cv32e40p_pkg::CSR_MIE, cv32e40p_pkg::CSR_MSTATUS};
                    });
                    write_imm_seq.start(m_sequencer);
                end
            endcase
        end
    endtask
endclass

// MSTATUS Controlled Sequence - Behavior changes based on interrupt enable
class cv32e40p_mstatus_controlled_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_mstatus_controlled_sequence)
    
    rand bit enable_interrupts;
    
    function new(string name = "cv32e40p_mstatus_controlled_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_seq_item req;
        
        // First set MSTATUS.MIE based on enable_interrupts
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        if (enable_interrupts) begin
            assert(req.randomize() with { 
                instr_rdata_i[6:0] == 7'b1110011; // SYSTEM opcode
                instr_rdata_i[14:12] == 3'b001;   // CSRRW
                instr_rdata_i[31:20] == CSR_MSTATUS;
                instr_rdata_i[19:15] != 5'b00000; // Write non-zero to enable
            });
        end else begin
            assert(req.randomize() with { 
                instr_rdata_i[6:0] == 7'b1110011; // SYSTEM opcode
                instr_rdata_i[14:12] == 3'b001;   // CSRRW
                instr_rdata_i[31:20] == CSR_MSTATUS;
                instr_rdata_i[19:15] == 5'b00000; // Write zero to disable
            });
        end
        finish_item(req);
        
        // Now generate different instruction patterns based on interrupt setting
        if (enable_interrupts) begin
            // Generate interrupt-sensitive instructions (5 iterations)
            req = cv32e40p_seq_item::type_id::create("req");
            start_item(req);
            assert(req.randomize() with { 
                instr_rdata_i[6:0] inside {7'b0110011, 7'b0010011}; // R-type or I-type
            });
            finish_item(req);
            
            req = cv32e40p_seq_item::type_id::create("req");
            start_item(req);
            assert(req.randomize() with { 
                instr_rdata_i[6:0] inside {7'b0110011, 7'b0010011}; // R-type or I-type
            });
            finish_item(req);
            
            req = cv32e40p_seq_item::type_id::create("req");
            start_item(req);
            assert(req.randomize() with { 
                instr_rdata_i[6:0] inside {7'b0110011, 7'b0010011}; // R-type or I-type
            });
            finish_item(req);
            
            req = cv32e40p_seq_item::type_id::create("req");
            start_item(req);
            assert(req.randomize() with { 
                instr_rdata_i[6:0] inside {7'b0110011, 7'b0010011}; // R-type or I-type
            });
            finish_item(req);
            
            req = cv32e40p_seq_item::type_id::create("req");
            start_item(req);
            assert(req.randomize() with { 
                instr_rdata_i[6:0] inside {7'b0110011, 7'b0010011}; // R-type or I-type
            });
            finish_item(req);
        end else begin
            // Generate atomic sequences that shouldn't be interrupted (5 iterations)
            req = cv32e40p_seq_item::type_id::create("req");
            start_item(req);
            assert(req.randomize() with { 
                instr_rdata_i[6:0] == 7'b0110011; // Only R-type for atomic ops
            });
            finish_item(req);
            
            req = cv32e40p_seq_item::type_id::create("req");
            start_item(req);
            assert(req.randomize() with { 
                instr_rdata_i[6:0] == 7'b0110011; // Only R-type for atomic ops
            });
            finish_item(req);
            
            req = cv32e40p_seq_item::type_id::create("req");
            start_item(req);
            assert(req.randomize() with { 
                instr_rdata_i[6:0] == 7'b0110011; // Only R-type for atomic ops
            });
            finish_item(req);
            
            req = cv32e40p_seq_item::type_id::create("req");
            start_item(req);
            assert(req.randomize() with { 
                instr_rdata_i[6:0] == 7'b0110011; // Only R-type for atomic ops
            });
            finish_item(req);
            
            req = cv32e40p_seq_item::type_id::create("req");
            start_item(req);
            assert(req.randomize() with { 
                instr_rdata_i[6:0] == 7'b0110011; // Only R-type for atomic ops
            });
            finish_item(req);
        end
    endtask
endclass

// Debug Step Sequence - Behavior changes based on single-step mode
class cv32e40p_debug_step_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_debug_step_sequence)
    
    rand bit single_step_mode;
    
    function new(string name = "cv32e40p_debug_step_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_seq_item req;
        
        // Set DCSR.STEP bit
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == 7'b1110011; // SYSTEM opcode
            instr_rdata_i[14:12] == 3'b001;   // CSRRW
            instr_rdata_i[31:20] == CSR_DCSR;
            // Set STEP bit (bit 2) based on single_step_mode
        });
        finish_item(req);
        
        if (single_step_mode) begin
            // In single-step mode, each instruction should trigger debug
            repeat(3) begin
                req = cv32e40p_seq_item::type_id::create("req");
                start_item(req);
                assert(req.randomize());
                finish_item(req);
                // Expect debug entry after each instruction
            end
        end else begin
            // Normal execution mode
            repeat(10) begin
                req = cv32e40p_seq_item::type_id::create("req");
                start_item(req);
                assert(req.randomize());
                finish_item(req);
            end
        end
    endtask
endclass

// Interrupt Mask Sequence - Behavior changes based on enabled interrupts
class cv32e40p_interrupt_mask_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_interrupt_mask_sequence)
    
    rand bit [31:0] interrupt_mask;
    
    function new(string name = "cv32e40p_interrupt_mask_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_seq_item req;
        
        // Set MIE register with specific interrupt enables
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == 7'b1110011; // SYSTEM opcode
            instr_rdata_i[14:12] == 3'b001;   // CSRRW
            instr_rdata_i[31:20] == CSR_MIE;
        });
        finish_item(req);
        
        // Generate sequences based on enabled interrupts
        if (interrupt_mask[7]) begin // Timer interrupt enabled
            // Generate time-sensitive operations
            repeat(5) begin
                req = cv32e40p_seq_item::type_id::create("req");
                start_item(req);
                assert(req.randomize() with { 
                    instr_rdata_i[6:0] == 7'b0110011; // Long-running operations
                });
                finish_item(req);
            end
        end
        
        if (interrupt_mask[11]) begin // External interrupt enabled
            // Generate I/O operations
            repeat(3) begin
                req = cv32e40p_seq_item::type_id::create("req");
                start_item(req);
                assert(req.randomize() with { 
                    instr_rdata_i[6:0] inside {7'b0000011, 7'b0100011}; // Load/Store
                });
                finish_item(req);
            end
        end
    endtask
endclass

// Performance Counter Sequence - Behavior changes based on counter configuration
class cv32e40p_perf_counter_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_perf_counter_sequence)
    
    rand bit enable_branch_counting;
    rand bit enable_cache_counting;
    
    function new(string name = "cv32e40p_perf_counter_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_seq_item req;
        
        // Configure performance counters
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == 7'b1110011; // SYSTEM opcode
            instr_rdata_i[14:12] == 3'b001;   // CSRRW
            instr_rdata_i[31:20] == CSR_MCOUNTEREN;
        });
        finish_item(req);
        
        if (enable_branch_counting) begin
            // Generate branch-heavy sequences
            repeat(10) begin
                req = cv32e40p_seq_item::type_id::create("req");
                start_item(req);
                assert(req.randomize() with { 
                    instr_rdata_i[6:0] == 7'b1100011; // Branch instructions
                });
                finish_item(req);
            end
        end
        
        if (enable_cache_counting) begin
            // Generate memory-intensive sequences
            repeat(8) begin
                req = cv32e40p_seq_item::type_id::create("req");
                start_item(req);
                assert(req.randomize() with { 
                    instr_rdata_i[6:0] inside {7'b0000011, 7'b0100011}; // Load/Store
                });
                finish_item(req);
            end
        end
    endtask
endclass

