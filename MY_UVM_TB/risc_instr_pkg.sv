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

  // ALU Operations from cv32e40p_pkg.sv
  parameter ALU_OP_WIDTH = 7;

  typedef enum logic [ALU_OP_WIDTH-1:0] {
    ALU_ADD   = 7'b0011000,
    ALU_SUB   = 7'b0011001,
    ALU_ADDU  = 7'b0011010,
    ALU_SUBU  = 7'b0011011,
    ALU_ADDR  = 7'b0011100,
    ALU_SUBR  = 7'b0011101,
    ALU_ADDUR = 7'b0011110,
    ALU_SUBUR = 7'b0011111,

    ALU_XOR = 7'b0101111,
    ALU_OR  = 7'b0101110,
    ALU_AND = 7'b0010101,

    // Shifts
    ALU_SRA = 7'b0100100,
    ALU_SRL = 7'b0100101,
    ALU_ROR = 7'b0100110,
    ALU_SLL = 7'b0100111,

    // bit manipulation
    ALU_BEXT  = 7'b0101000,
    ALU_BEXTU = 7'b0101001,
    ALU_BINS  = 7'b0101010,
    ALU_BCLR  = 7'b0101011,
    ALU_BSET  = 7'b0101100,
    ALU_BREV  = 7'b1001001,

    // Bit counting
    ALU_FF1 = 7'b0110110,
    ALU_FL1 = 7'b0110111,
    ALU_CNT = 7'b0110100,
    ALU_CLB = 7'b0110101,

    // Sign-/zero-extensions
    ALU_EXTS = 7'b0111110,
    ALU_EXT  = 7'b0111111,

    // Comparisons
    ALU_LTS = 7'b0000000,
    ALU_LTU = 7'b0000001,
    ALU_LES = 7'b0000100,
    ALU_LEU = 7'b0000101,
    ALU_GTS = 7'b0001000,
    ALU_GTU = 7'b0001001,
    ALU_GES = 7'b0001010,
    ALU_GEU = 7'b0001011,
    ALU_EQ  = 7'b0001100,
    ALU_NE  = 7'b0001101,

    // Set Lower Than operations
    ALU_SLTS  = 7'b0000010,
    ALU_SLTU  = 7'b0000011,
    ALU_SLETS = 7'b0000110,
    ALU_SLETU = 7'b0000111,

    // Absolute value
    ALU_ABS   = 7'b0010100,
    ALU_CLIP  = 7'b0010110,
    ALU_CLIPU = 7'b0010111,

    // Insert/extract
    ALU_INS = 7'b0101101,

    // min/max
    ALU_MIN  = 7'b0010000,
    ALU_MINU = 7'b0010001,
    ALU_MAX  = 7'b0010010,
    ALU_MAXU = 7'b0010011,

    // div/rem
    ALU_DIVU = 7'b0110000,  // bit 0 is used for signed mode, bit 1 is used for remdiv
    ALU_DIV  = 7'b0110001,  // bit 0 is used for signed mode, bit 1 is used for remdiv
    ALU_REMU = 7'b0110010,  // bit 0 is used for signed mode, bit 1 is used for remdiv
    ALU_REM  = 7'b0110011,  // bit 0 is used for signed mode, bit 1 is used for remdiv

    ALU_SHUF  = 7'b0111010,
    ALU_SHUF2 = 7'b0111011,
    ALU_PCKLO = 7'b0111000,
    ALU_PCKHI = 7'b0111001
  } alu_opcode_e;

  // CSR Address Constants (RISC-V Standard)
  parameter logic [11:0] CSR_MSTATUS  = 12'h300;  // Machine Status Register
  parameter logic [11:0] CSR_MISA     = 12'h301;  // Machine ISA Register
  parameter logic [11:0] CSR_MIE      = 12'h304;  // Machine Interrupt Enable
  parameter logic [11:0] CSR_MTVEC    = 12'h305;  // Machine Trap Vector Base Address
  parameter logic [11:0] CSR_MSCRATCH = 12'h340;  // Machine Scratch Register
  parameter logic [11:0] CSR_MEPC     = 12'h341;  // Machine Exception Program Counter
  parameter logic [11:0] CSR_MCAUSE   = 12'h342;  // Machine Cause Register
  parameter logic [11:0] CSR_MTVAL    = 12'h343;  // Machine Trap Value Register
  parameter logic [11:0] CSR_MIP      = 12'h344;  // Machine Interrupt Pending
  parameter logic [11:0] CSR_MCYCLE     = 12'hB00;  // Machine Cycle Counter
  parameter logic [11:0] CSR_MINSTRET   = 12'hB02;  // Machine Instructions Retired Counter
  parameter logic [11:0] CSR_MCOUNTEREN = 12'h306;  // Machine Counter Enable Register
  
  // Debug CSRs
  parameter logic [11:0] CSR_DCSR     = 12'h7B0;  // Debug Control and Status Register
  parameter logic [11:0] CSR_DPC      = 12'h7B1;  // Debug Program Counter
  parameter logic [11:0] CSR_DSCRATCH = 12'h7B2;  // Debug Scratch Register

endpackage
