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

// Grouped Arithmetic Sequence
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
        
        repeat(10) begin
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