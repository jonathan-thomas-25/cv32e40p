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

// Immediate Shift Operations
class cv32e40p_slli_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_slli_sequence)
    
    function new(string name = "cv32e40p_slli_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == 7'b0010011; // I-type opcode
            instr_rdata_i[14:12] == 3'b001;   // funct3 for SLLI
            instr_rdata_i[31:25] == 7'b0000000; // funct7 for SLLI
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_srli_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_srli_sequence)
    
    function new(string name = "cv32e40p_srli_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == 7'b0010011; // I-type opcode
            instr_rdata_i[14:12] == 3'b101;   // funct3 for SRLI
            instr_rdata_i[31:25] == 7'b0000000; // funct7 for SRLI
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_srai_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_srai_sequence)
    
    function new(string name = "cv32e40p_srai_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == 7'b0010011; // I-type opcode
            instr_rdata_i[14:12] == 3'b101;   // funct3 for SRAI
            instr_rdata_i[31:25] == 7'b0100000; // funct7 for SRAI
        });
        finish_item(req);
    endtask
endclass

// Grouped Shift Sequence
class cv32e40p_shift_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_shift_sequence)
    
    function new(string name = "cv32e40p_shift_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        cv32e40p_alu_sll_sequence sll_seq;
        cv32e40p_alu_srl_sequence srl_seq;
        cv32e40p_alu_sra_sequence sra_seq;
        cv32e40p_slli_sequence slli_seq;
        cv32e40p_srli_sequence srli_seq;
        cv32e40p_srai_sequence srai_seq;
        
        repeat(10) begin
            case($urandom_range(0, 5))
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
                3: begin
                    slli_seq = cv32e40p_slli_sequence::type_id::create("slli_seq");
                    slli_seq.start(m_sequencer);
                end
                4: begin
                    srli_seq = cv32e40p_srli_sequence::type_id::create("srli_seq");
                    srli_seq.start(m_sequencer);
                end
                5: begin
                    srai_seq = cv32e40p_srai_sequence::type_id::create("srai_seq");
                    srai_seq.start(m_sequencer);
                end
            endcase
        end
    endtask
endclass