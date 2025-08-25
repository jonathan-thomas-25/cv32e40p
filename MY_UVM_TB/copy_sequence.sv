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

// CV32E40P Custom ALU Instruction Sequences

// Bit Manipulation Instructions (opcode 0x2B)
class cv32e40p_extractr_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_extractr_sequence)
    function new(string name = "cv32e40p_extractr_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_1;
            instr_rdata_i[14:12] == 3'b011;  // funct3
            instr_rdata_i[31:25] == 7'b0011000;  // funct7
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_extractur_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_extractur_sequence)
    function new(string name = "cv32e40p_extractur_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_1;
            instr_rdata_i[14:12] == 3'b011;  // funct3
            instr_rdata_i[31:25] == 7'b0011001;  // funct7
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_insertr_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_insertr_sequence)
    function new(string name = "cv32e40p_insertr_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_1;
            instr_rdata_i[14:12] == 3'b011;  // funct3
            instr_rdata_i[31:25] == 7'b0011010;  // funct7
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_bclrr_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_bclrr_sequence)
    function new(string name = "cv32e40p_bclrr_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_1;
            instr_rdata_i[14:12] == 3'b011;  // funct3
            instr_rdata_i[31:25] == 7'b0011100;  // funct7
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_bsetr_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_bsetr_sequence)
    function new(string name = "cv32e40p_bsetr_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_1;
            instr_rdata_i[14:12] == 3'b011;  // funct3
            instr_rdata_i[31:25] == 7'b0011101;  // funct7
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_ror_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_ror_sequence)
    function new(string name = "cv32e40p_ror_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_1;
            instr_rdata_i[14:12] == 3'b011;  // funct3
            instr_rdata_i[31:25] == 7'b0100000;  // funct7
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_ff1_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_ff1_sequence)
    function new(string name = "cv32e40p_ff1_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_1;
            instr_rdata_i[14:12] == 3'b011;  // funct3
            instr_rdata_i[31:25] == 7'b0100001;  // funct7
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_fl1_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_fl1_sequence)
    function new(string name = "cv32e40p_fl1_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_1;
            instr_rdata_i[14:12] == 3'b011;  // funct3
            instr_rdata_i[31:25] == 7'b0100010;  // funct7
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_clb_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_clb_sequence)
    function new(string name = "cv32e40p_clb_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_1;
            instr_rdata_i[14:12] == 3'b011;  // funct3
            instr_rdata_i[31:25] == 7'b0100011;  // funct7
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_cnt_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_cnt_sequence)
    function new(string name = "cv32e40p_cnt_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_1;
            instr_rdata_i[14:12] == 3'b011;  // funct3
            instr_rdata_i[31:25] == 7'b0100100;  // funct7
        });
        finish_item(req);
    endtask
endclass

// General ALU Operations (opcode 0x2B)
class cv32e40p_abs_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_abs_sequence)
    function new(string name = "cv32e40p_abs_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_1;
            instr_rdata_i[14:12] == 3'b011;  // funct3
            instr_rdata_i[31:25] == 7'b0101000;  // funct7
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_sle_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_sle_sequence)
    function new(string name = "cv32e40p_sle_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_1;
            instr_rdata_i[14:12] == 3'b011;  // funct3
            instr_rdata_i[31:25] == 7'b0101001;  // funct7
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_sleu_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_sleu_sequence)
    function new(string name = "cv32e40p_sleu_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_1;
            instr_rdata_i[14:12] == 3'b011;  // funct3
            instr_rdata_i[31:25] == 7'b0101010;  // funct7
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_min_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_min_sequence)
    function new(string name = "cv32e40p_min_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_1;
            instr_rdata_i[14:12] == 3'b011;  // funct3
            instr_rdata_i[31:25] == 7'b0101011;  // funct7
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_minu_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_minu_sequence)
    function new(string name = "cv32e40p_minu_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_1;
            instr_rdata_i[14:12] == 3'b011;  // funct3
            instr_rdata_i[31:25] == 7'b0101100;  // funct7
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_max_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_max_sequence)
    function new(string name = "cv32e40p_max_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_1;
            instr_rdata_i[14:12] == 3'b011;  // funct3
            instr_rdata_i[31:25] == 7'b0101101;  // funct7
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_maxu_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_maxu_sequence)
    function new(string name = "cv32e40p_maxu_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_1;
            instr_rdata_i[14:12] == 3'b011;  // funct3
            instr_rdata_i[31:25] == 7'b0101110;  // funct7
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_exths_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_exths_sequence)
    function new(string name = "cv32e40p_exths_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_1;
            instr_rdata_i[14:12] == 3'b011;  // funct3
            instr_rdata_i[31:25] == 7'b0110000;  // funct7
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_exthz_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_exthz_sequence)
    function new(string name = "cv32e40p_exthz_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_1;
            instr_rdata_i[14:12] == 3'b011;  // funct3
            instr_rdata_i[31:25] == 7'b0110001;  // funct7
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_extbs_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_extbs_sequence)
    function new(string name = "cv32e40p_extbs_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_1;
            instr_rdata_i[14:12] == 3'b011;  // funct3
            instr_rdata_i[31:25] == 7'b0110010;  // funct7
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_extbz_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_extbz_sequence)
    function new(string name = "cv32e40p_extbz_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_1;
            instr_rdata_i[14:12] == 3'b011;  // funct3
            instr_rdata_i[31:25] == 7'b0110011;  // funct7
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_clip_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_clip_sequence)
    function new(string name = "cv32e40p_clip_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_1;
            instr_rdata_i[14:12] == 3'b011;  // funct3
            instr_rdata_i[31:25] == 7'b0111000;  // funct7
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_clipu_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_clipu_sequence)
    function new(string name = "cv32e40p_clipu_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_1;
            instr_rdata_i[14:12] == 3'b011;  // funct3
            instr_rdata_i[31:25] == 7'b0111001;  // funct7
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_clipr_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_clipr_sequence)
    function new(string name = "cv32e40p_clipr_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_1;
            instr_rdata_i[14:12] == 3'b011;  // funct3
            instr_rdata_i[31:25] == 7'b0111010;  // funct7
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_clipur_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_clipur_sequence)
    function new(string name = "cv32e40p_clipur_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_1;
            instr_rdata_i[14:12] == 3'b011;  // funct3
            instr_rdata_i[31:25] == 7'b0111011;  // funct7
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_addnr_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_addnr_sequence)
    function new(string name = "cv32e40p_addnr_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_1;
            instr_rdata_i[14:12] == 3'b011;  // funct3
            instr_rdata_i[31:25] == 7'b1000000;  // funct7
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_addunr_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_addunr_sequence)
    function new(string name = "cv32e40p_addunr_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_1;
            instr_rdata_i[14:12] == 3'b011;  // funct3
            instr_rdata_i[31:25] == 7'b1000001;  // funct7
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_addrnr_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_addrnr_sequence)
    function new(string name = "cv32e40p_addrnr_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_1;
            instr_rdata_i[14:12] == 3'b011;  // funct3
            instr_rdata_i[31:25] == 7'b1000010;  // funct7
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_addurnr_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_addurnr_sequence)
    function new(string name = "cv32e40p_addurnr_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_1;
            instr_rdata_i[14:12] == 3'b011;  // funct3
            instr_rdata_i[31:25] == 7'b1000011;  // funct7
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_subnr_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_subnr_sequence)
    function new(string name = "cv32e40p_subnr_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_1;
            instr_rdata_i[14:12] == 3'b011;  // funct3
            instr_rdata_i[31:25] == 7'b1000100;  // funct7
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_subunr_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_subunr_sequence)
    function new(string name = "cv32e40p_subunr_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_1;
            instr_rdata_i[14:12] == 3'b011;  // funct3
            instr_rdata_i[31:25] == 7'b1000101;  // funct7
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_subrnr_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_subrnr_sequence)
    function new(string name = "cv32e40p_subrnr_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_1;
            instr_rdata_i[14:12] == 3'b011;  // funct3
            instr_rdata_i[31:25] == 7'b1000110;  // funct7
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_suburnr_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_suburnr_sequence)
    function new(string name = "cv32e40p_suburnr_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_1;
            instr_rdata_i[14:12] == 3'b011;  // funct3
            instr_rdata_i[31:25] == 7'b1000111;  // funct7
        });
        finish_item(req);
    endtask
endclass

// Immediate-based Operations (opcode 0x5B)
class cv32e40p_extract_imm_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_extract_imm_sequence)
    function new(string name = "cv32e40p_extract_imm_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_2;
            instr_rdata_i[14:12] == 3'b000;  // funct3
            instr_rdata_i[31:30] == 2'b00;   // f2
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_extractu_imm_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_extractu_imm_sequence)
    function new(string name = "cv32e40p_extractu_imm_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_2;
            instr_rdata_i[14:12] == 3'b000;  // funct3
            instr_rdata_i[31:30] == 2'b01;   // f2
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_insert_imm_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_insert_imm_sequence)
    function new(string name = "cv32e40p_insert_imm_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_2;
            instr_rdata_i[14:12] == 3'b000;  // funct3
            instr_rdata_i[31:30] == 2'b10;   // f2
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_bclr_imm_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_bclr_imm_sequence)
    function new(string name = "cv32e40p_bclr_imm_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_2;
            instr_rdata_i[14:12] == 3'b001;  // funct3
            instr_rdata_i[31:30] == 2'b00;   // f2
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_bset_imm_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_bset_imm_sequence)
    function new(string name = "cv32e40p_bset_imm_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_2;
            instr_rdata_i[14:12] == 3'b001;  // funct3
            instr_rdata_i[31:30] == 2'b01;   // f2
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_bitrev_imm_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_bitrev_imm_sequence)
    function new(string name = "cv32e40p_bitrev_imm_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_2;
            instr_rdata_i[14:12] == 3'b001;  // funct3
            instr_rdata_i[31:30] == 2'b11;   // f2
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_addn_imm_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_addn_imm_sequence)
    function new(string name = "cv32e40p_addn_imm_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_2;
            instr_rdata_i[14:12] == 3'b010;  // funct3
            instr_rdata_i[31:30] == 2'b00;   // f2
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_addun_imm_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_addun_imm_sequence)
    function new(string name = "cv32e40p_addun_imm_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_2;
            instr_rdata_i[14:12] == 3'b010;  // funct3
            instr_rdata_i[31:30] == 2'b01;   // f2
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_addrn_imm_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_addrn_imm_sequence)
    function new(string name = "cv32e40p_addrn_imm_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_2;
            instr_rdata_i[14:12] == 3'b010;  // funct3
            instr_rdata_i[31:30] == 2'b10;   // f2
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_addurn_imm_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_addurn_imm_sequence)
    function new(string name = "cv32e40p_addurn_imm_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_2;
            instr_rdata_i[14:12] == 3'b010;  // funct3
            instr_rdata_i[31:30] == 2'b11;   // f2
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_subn_imm_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_subn_imm_sequence)
    function new(string name = "cv32e40p_subn_imm_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_2;
            instr_rdata_i[14:12] == 3'b011;  // funct3
            instr_rdata_i[31:30] == 2'b00;   // f2
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_subun_imm_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_subun_imm_sequence)
    function new(string name = "cv32e40p_subun_imm_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_2;
            instr_rdata_i[14:12] == 3'b011;  // funct3
            instr_rdata_i[31:30] == 2'b01;   // f2
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_subrn_imm_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_subrn_imm_sequence)
    function new(string name = "cv32e40p_subrn_imm_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_2;
            instr_rdata_i[14:12] == 3'b011;  // funct3
            instr_rdata_i[31:30] == 2'b10;   // f2
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_suburn_imm_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_suburn_imm_sequence)
    function new(string name = "cv32e40p_suburn_imm_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_ALU_OPCODE_2;
            instr_rdata_i[14:12] == 3'b011;  // funct3
            instr_rdata_i[31:30] == 2'b11;   // f2
        });
        finish_item(req);
    endtask
endclass

// Immediate Branching Operations (opcode 0x0B)
class cv32e40p_beqimm_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_beqimm_sequence)
    function new(string name = "cv32e40p_beqimm_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_BRANCH_OPCODE;
            instr_rdata_i[14:12] == 3'b110;  // funct3
        });
        finish_item(req);
    endtask
endclass

class cv32e40p_bneimm_sequence extends cv32e40p_base_sequence;
    `uvm_object_utils(cv32e40p_bneimm_sequence)
    function new(string name = "cv32e40p_bneimm_sequence");
        super.new(name);
    endfunction
    virtual task body();
        cv32e40p_seq_item req;
        req = cv32e40p_seq_item::type_id::create("req");
        start_item(req);
        assert(req.randomize() with { 
            instr_rdata_i[6:0] == risc_pkg::CV_BRANCH_OPCODE;
            instr_rdata_i[14:12] == 3'b111;  // funct3
        });
        finish_item(req);
    endtask
endclass
