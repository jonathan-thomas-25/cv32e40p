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

// Branch Comparison Instructions
class cv32e40p_beq_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_beq_sequence)
    
    function new(string name = "cv32e40p_beq_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == 7'b1100011; // B-type opcode
            instr_rdata_i[14:12] == 3'b000;   // funct3 for BEQ
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_bne_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_bne_sequence)
    
    function new(string name = "cv32e40p_bne_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == 7'b1100011; // B-type opcode
            instr_rdata_i[14:12] == 3'b001;   // funct3 for BNE
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_blt_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_blt_sequence)
    
    function new(string name = "cv32e40p_blt_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == 7'b1100011; // B-type opcode
            instr_rdata_i[14:12] == 3'b100;   // funct3 for BLT
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_bge_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_bge_sequence)
    
    function new(string name = "cv32e40p_bge_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == 7'b1100011; // B-type opcode
            instr_rdata_i[14:12] == 3'b101;   // funct3 for BGE
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_bltu_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_bltu_sequence)
    
    function new(string name = "cv32e40p_bltu_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == 7'b1100011; // B-type opcode
            instr_rdata_i[14:12] == 3'b110;   // funct3 for BLTU
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_bgeu_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_bgeu_sequence)
    
    function new(string name = "cv32e40p_bgeu_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == 7'b1100011; // B-type opcode
            instr_rdata_i[14:12] == 3'b111;   // funct3 for BGEU
        });
        finish_item(req);
    endtask
endclass

// Grouped Comparison Sequence
class cv32e40p_comparison_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_comparison_sequence)
    
    function new(string name = "cv32e40p_comparison_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_alu_slt_sequence slt_seq;
        cv32e40p_alu_sltu_sequence sltu_seq;
        cv32e40p_beq_sequence beq_seq;
        cv32e40p_bne_sequence bne_seq;
        cv32e40p_blt_sequence blt_seq;
        cv32e40p_bge_sequence bge_seq;
        cv32e40p_bltu_sequence bltu_seq;
        cv32e40p_bgeu_sequence bgeu_seq;
        
        repeat(10) begin
            case($urandom_range(0, 7))
                0: begin
                    slt_seq = cv32e40p_alu_slt_sequence::type_id::create("slt_seq");
                    slt_seq.start(m_sequencer);
                end
                1: begin
                    sltu_seq = cv32e40p_alu_sltu_sequence::type_id::create("sltu_seq");
                    sltu_seq.start(m_sequencer);
                end
                2: begin
                    beq_seq = cv32e40p_beq_sequence::type_id::create("beq_seq");
                    beq_seq.start(m_sequencer);
                end
                3: begin
                    bne_seq = cv32e40p_bne_sequence::type_id::create("bne_seq");
                    bne_seq.start(m_sequencer);
                end
                4: begin
                    blt_seq = cv32e40p_blt_sequence::type_id::create("blt_seq");
                    blt_seq.start(m_sequencer);
                end
                5: begin
                    bge_seq = cv32e40p_bge_sequence::type_id::create("bge_seq");
                    bge_seq.start(m_sequencer);
                end
                6: begin
                    bltu_seq = cv32e40p_bltu_sequence::type_id::create("bltu_seq");
                    bltu_seq.start(m_sequencer);
                end
                7: begin
                    bgeu_seq = cv32e40p_bgeu_sequence::type_id::create("bgeu_seq");
                    bgeu_seq.start(m_sequencer);
                end
            endcase
        end
    endtask
endclass