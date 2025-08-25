package risc_pkg;


  // CV32E40P Custom ALU Instructions Opcodes from instruction_set_extensions.rst
  typedef enum logic [6:0] {
    // Custom ALU instructions use opcode 010 1011 (0x2B) and 101 1011 (0x5B)
    CV_ALU_OPCODE_1 = 7'b0101011,  // 0x2B - Used for register-based bit manipulation and general ALU ops
    CV_ALU_OPCODE_2 = 7'b1011011,  // 0x5B - Used for immediate-based operations
    CV_BRANCH_OPCODE = 7'b0001011  // 0x0B - Used for immediate branching operations
  } cv_alu_opcode_e;

  // CV32E40P Custom ALU Instructions funct7/funct3 combinations
  typedef enum logic [9:0] {  // [funct7:funct3]
    // Bit Manipulation operations (opcode 010 1011)
    CV_EXTRACTR   = 10'b0011000_011,  // funct7=001 1000, funct3=011
    CV_EXTRACTUR  = 10'b0011001_011,  // funct7=001 1001, funct3=011
    CV_INSERTR    = 10'b0011010_011,  // funct7=001 1010, funct3=011
    CV_BCLRR      = 10'b0011100_011,  // funct7=001 1100, funct3=011
    CV_BSETR      = 10'b0011101_011,  // funct7=001 1101, funct3=011
    CV_ROR        = 10'b0100000_011,  // funct7=010 0000, funct3=011
    CV_FF1        = 10'b0100001_011,  // funct7=010 0001, funct3=011
    CV_FL1        = 10'b0100010_011,  // funct7=010 0010, funct3=011
    CV_CLB        = 10'b0100011_011,  // funct7=010 0011, funct3=011
    CV_CNT        = 10'b0100100_011,  // funct7=010 0100, funct3=011

    // General ALU operations (opcode 010 1011)
    CV_ABS        = 10'b0101000_011,  // funct7=010 1000, funct3=011
    CV_SLE        = 10'b0101001_011,  // funct7=010 1001, funct3=011
    CV_SLEU       = 10'b0101010_011,  // funct7=010 1010, funct3=011
    CV_MIN        = 10'b0101011_011,  // funct7=010 1011, funct3=011
    CV_MINU       = 10'b0101100_011,  // funct7=010 1100, funct3=011
    CV_MAX        = 10'b0101101_011,  // funct7=010 1101, funct3=011
    CV_MAXU       = 10'b0101110_011,  // funct7=010 1110, funct3=011
    CV_EXTHS      = 10'b0110000_011,  // funct7=011 0000, funct3=011
    CV_EXTHZ      = 10'b0110001_011,  // funct7=011 0001, funct3=011
    CV_EXTBS      = 10'b0110010_011,  // funct7=011 0010, funct3=011
    CV_EXTBZ      = 10'b0110011_011,  // funct7=011 0011, funct3=011
    CV_CLIP       = 10'b0111000_011,  // funct7=011 1000, funct3=011
    CV_CLIPU      = 10'b0111001_011,  // funct7=011 1001, funct3=011
    CV_CLIPR      = 10'b0111010_011,  // funct7=011 1010, funct3=011
    CV_CLIPUR     = 10'b0111011_011,  // funct7=011 1011, funct3=011
    CV_ADDNR      = 10'b1000000_011,  // funct7=100 0000, funct3=011
    CV_ADDUNR     = 10'b1000001_011,  // funct7=100 0001, funct3=011
    CV_ADDRNR     = 10'b1000010_011,  // funct7=100 0010, funct3=011
    CV_ADDURNR    = 10'b1000011_011,  // funct7=100 0011, funct3=011
    CV_SUBNR      = 10'b1000100_011,  // funct7=100 0100, funct3=011
    CV_SUBUNR     = 10'b1000101_011,  // funct7=100 0101, funct3=011
    CV_SUBRNR     = 10'b1000110_011,  // funct7=100 0110, funct3=011
    CV_SUBURNR    = 10'b1000111_011   // funct7=100 0111, funct3=011
  } cv_alu_funct_e;

  // Immediate-based operations use different encoding with f2 field (opcode 101 1011)
  typedef enum logic [4:0] {  // [f2:funct3] for immediate operations
    CV_EXTRACT_IMM  = 5'b00_000,  // f2=00, funct3=000
    CV_EXTRACTU_IMM = 5'b01_000,  // f2=01, funct3=000
    CV_INSERT_IMM   = 5'b10_000,  // f2=10, funct3=000
    CV_BCLR_IMM     = 5'b00_001,  // f2=00, funct3=001
    CV_BSET_IMM     = 5'b01_001,  // f2=01, funct3=001
    CV_BITREV_IMM   = 5'b11_001,  // f2=11, funct3=001
    CV_ADDN_IMM     = 5'b00_010,  // f2=00, funct3=010
    CV_ADDUN_IMM    = 5'b01_010,  // f2=01, funct3=010
    CV_ADDRN_IMM    = 5'b10_010,  // f2=10, funct3=010
    CV_ADDURN_IMM   = 5'b11_010,  // f2=11, funct3=010
    CV_SUBN_IMM     = 5'b00_011,  // f2=00, funct3=011
    CV_SUBUN_IMM    = 5'b01_011,  // f2=01, funct3=011
    CV_SUBRN_IMM    = 5'b10_011,  // f2=10, funct3=011
    CV_SUBURN_IMM   = 5'b11_011   // f2=11, funct3=011
  } cv_alu_imm_funct_e;

  // Immediate branching operations (opcode 000 1011)
  typedef enum logic [2:0] {
    CV_BEQIMM = 3'b110,  // funct3=110
    CV_BNEIMM = 3'b111   // funct3=111
  } cv_branch_funct_e;

endpackage
