#!/usr/bin/env python3
"""
CV32E40P Assembly Generator with Target Instruction Distribution

This script generates RISC-V assembly files with configurable instruction distributions
for the CV32E40P processor, including standard RV32I instructions and CV32E40P custom
extensions.

Distribution Strategy:
- Weighted random selection based on typical embedded workload patterns
- Ensures proper register dependencies and data flow
- Includes CV32E40P custom ALU and bit manipulation instructions
- Maintains realistic instruction mix for verification coverage
"""

import random
import argparse
import json
from typing import Dict, List, Tuple
from dataclasses import dataclass
from enum import Enum

class InstrType(Enum):
    ARITHMETIC = "arithmetic"
    LOGICAL = "logical"
    SHIFT = "shift"
    COMPARISON = "comparison"
    BRANCH = "branch"
    LOAD_STORE = "load_store"
    JUMP = "jump"
    CUSTOM_ALU = "custom_alu"
    CUSTOM_BIT = "custom_bit"
    IMMEDIATE = "immediate"
    MULTIPLY = "multiply"
    MISALIGNED_MEM = "misaligned_mem"

@dataclass
class InstructionTemplate:
    mnemonic: str
    format: str
    instr_type: InstrType
    weight: float
    operands: List[str]

class CV32E40PAssemblyGenerator:
    def __init__(self):
        # Register definitions
        self.registers = [f"x{i}" for i in range(32)]
        self.abi_names = {
            'x0': 'zero', 'x1': 'ra', 'x2': 'sp', 'x3': 'gp',
            'x4': 'tp', 'x5': 't0', 'x6': 't1', 'x7': 't2',
            'x8': 's0', 'x9': 's1', 'x10': 'a0', 'x11': 'a1',
            'x12': 'a2', 'x13': 'a3', 'x14': 'a4', 'x15': 'a5',
            'x16': 'a6', 'x17': 'a7', 'x18': 's2', 'x19': 's3',
            'x20': 's4', 'x21': 's5', 'x22': 's6', 'x23': 's7',
            'x24': 's8', 'x25': 's9', 'x26': 's10', 'x27': 's11',
            'x28': 't3', 'x29': 't4', 'x30': 't5', 'x31': 't6'
        }
        
        # Branch prediction state for generating taken branches
        self.branch_taken_probability = 0.5  # Default 50% taken rate
        self.register_values = {}  # Track register values for branch condition setup
        
        # Misaligned memory access configuration
        self.misaligned_probability = 0.3  # 30% of memory accesses are misaligned
        self.misaligned_offsets = [1, 2, 3, 5, 6, 7]  # Non-word-aligned offsets
        
        # Instruction templates with realistic embedded workload weights
        self.instruction_templates = {
            # Standard RV32I Arithmetic (30% total)
            "add": InstructionTemplate("add", "R", InstrType.ARITHMETIC, 8.0, ["rd", "rs1", "rs2"]),
            "sub": InstructionTemplate("sub", "R", InstrType.ARITHMETIC, 6.0, ["rd", "rs1", "rs2"]),
            "addi": InstructionTemplate("addi", "I", InstrType.ARITHMETIC, 12.0, ["rd", "rs1", "imm12"]),
            "subi": InstructionTemplate("subi", "I", InstrType.ARITHMETIC, 4.0, ["rd", "rs1", "imm12"]),
            
            # Logical Operations (15% total)
            "and": InstructionTemplate("and", "R", InstrType.LOGICAL, 3.0, ["rd", "rs1", "rs2"]),
            "or": InstructionTemplate("or", "R", InstrType.LOGICAL, 3.0, ["rd", "rs1", "rs2"]),
            "xor": InstructionTemplate("xor", "R", InstrType.LOGICAL, 2.0, ["rd", "rs1", "rs2"]),
            "andi": InstructionTemplate("andi", "I", InstrType.LOGICAL, 4.0, ["rd", "rs1", "imm12"]),
            "ori": InstructionTemplate("ori", "I", InstrType.LOGICAL, 2.0, ["rd", "rs1", "imm12"]),
            "xori": InstructionTemplate("xori", "I", InstrType.LOGICAL, 1.0, ["rd", "rs1", "imm12"]),
            
            # Shift Operations (8% total)
            "sll": InstructionTemplate("sll", "R", InstrType.SHIFT, 2.0, ["rd", "rs1", "rs2"]),
            "srl": InstructionTemplate("srl", "R", InstrType.SHIFT, 2.0, ["rd", "rs1", "rs2"]),
            "sra": InstructionTemplate("sra", "R", InstrType.SHIFT, 1.5, ["rd", "rs1", "rs2"]),
            "slli": InstructionTemplate("slli", "I", InstrType.SHIFT, 1.5, ["rd", "rs1", "shamt"]),
            "srli": InstructionTemplate("srli", "I", InstrType.SHIFT, 1.0, ["rd", "rs1", "shamt"]),
            
            # Comparison Operations (10% total)
            "slt": InstructionTemplate("slt", "R", InstrType.COMPARISON, 2.0, ["rd", "rs1", "rs2"]),
            "sltu": InstructionTemplate("sltu", "R", InstrType.COMPARISON, 2.0, ["rd", "rs1", "rs2"]),
            "slti": InstructionTemplate("slti", "I", InstrType.COMPARISON, 3.0, ["rd", "rs1", "imm12"]),
            "sltiu": InstructionTemplate("sltiu", "I", InstrType.COMPARISON, 3.0, ["rd", "rs1", "imm12"]),
            
            # Branch Operations (12% total)
            "beq": InstructionTemplate("beq", "B", InstrType.BRANCH, 3.0, ["rs1", "rs2", "label"]),
            "bne": InstructionTemplate("bne", "B", InstrType.BRANCH, 3.0, ["rs1", "rs2", "label"]),
            "blt": InstructionTemplate("blt", "B", InstrType.BRANCH, 2.0, ["rs1", "rs2", "label"]),
            "bge": InstructionTemplate("bge", "B", InstrType.BRANCH, 2.0, ["rs1", "rs2", "label"]),
            "bltu": InstructionTemplate("bltu", "B", InstrType.BRANCH, 1.0, ["rs1", "rs2", "label"]),
            "bgeu": InstructionTemplate("bgeu", "B", InstrType.BRANCH, 1.0, ["rs1", "rs2", "label"]),
            
            # Load/Store Operations (15% total)
            "lw": InstructionTemplate("lw", "I", InstrType.LOAD_STORE, 6.0, ["rd", "offset", "rs1"]),
            "lh": InstructionTemplate("lh", "I", InstrType.LOAD_STORE, 2.0, ["rd", "offset", "rs1"]),
            "lb": InstructionTemplate("lb", "I", InstrType.LOAD_STORE, 1.0, ["rd", "offset", "rs1"]),
            "sw": InstructionTemplate("sw", "S", InstrType.LOAD_STORE, 4.0, ["rs2", "offset", "rs1"]),
            "sh": InstructionTemplate("sh", "S", InstrType.LOAD_STORE, 1.5, ["rs2", "offset", "rs1"]),
            "sb": InstructionTemplate("sb", "S", InstrType.LOAD_STORE, 0.5, ["rs2", "offset", "rs1"]),
            
            # Jump Operations (3% total)
            "jal": InstructionTemplate("jal", "J", InstrType.JUMP, 1.5, ["rd", "label"]),
            "jalr": InstructionTemplate("jalr", "I", InstrType.JUMP, 1.5, ["rd", "rs1", "imm12"]),
            
            # CV32E40P Custom ALU Operations (5% total)
            "cv.abs": InstructionTemplate("cv.abs", "R", InstrType.CUSTOM_ALU, 0.5, ["rd", "rs1"]),
            "cv.sle": InstructionTemplate("cv.sle", "R", InstrType.CUSTOM_ALU, 0.5, ["rd", "rs1", "rs2"]),
            "cv.sleu": InstructionTemplate("cv.sleu", "R", InstrType.CUSTOM_ALU, 0.5, ["rd", "rs1", "rs2"]),
            "cv.min": InstructionTemplate("cv.min", "R", InstrType.CUSTOM_ALU, 1.0, ["rd", "rs1", "rs2"]),
            "cv.max": InstructionTemplate("cv.max", "R", InstrType.CUSTOM_ALU, 1.0, ["rd", "rs1", "rs2"]),
            "cv.minu": InstructionTemplate("cv.minu", "R", InstrType.CUSTOM_ALU, 0.5, ["rd", "rs1", "rs2"]),
            "cv.maxu": InstructionTemplate("cv.maxu", "R", InstrType.CUSTOM_ALU, 0.5, ["rd", "rs1", "rs2"]),
            "cv.clip": InstructionTemplate("cv.clip", "R", InstrType.CUSTOM_ALU, 0.5, ["rd", "rs1", "rs2"]),
            
            # CV32E40P Custom Bit Manipulation (2% total)
            "cv.extractr": InstructionTemplate("cv.extractr", "R", InstrType.CUSTOM_BIT, 0.3, ["rd", "rs1", "rs2"]),
            "cv.extractur": InstructionTemplate("cv.extractur", "R", InstrType.CUSTOM_BIT, 0.3, ["rd", "rs1", "rs2"]),
            "cv.insertr": InstructionTemplate("cv.insertr", "R", InstrType.CUSTOM_BIT, 0.3, ["rd", "rs1", "rs2"]),
            "cv.bclrr": InstructionTemplate("cv.bclrr", "R", InstrType.CUSTOM_BIT, 0.2, ["rd", "rs1", "rs2"]),
            "cv.bsetr": InstructionTemplate("cv.bsetr", "R", InstrType.CUSTOM_BIT, 0.2, ["rd", "rs1", "rs2"]),
            "cv.ror": InstructionTemplate("cv.ror", "R", InstrType.CUSTOM_BIT, 0.2, ["rd", "rs1", "rs2"]),
            "cv.ff1": InstructionTemplate("cv.ff1", "R", InstrType.CUSTOM_BIT, 0.2, ["rd", "rs1"]),
            "cv.cnt": InstructionTemplate("cv.cnt", "R", InstrType.CUSTOM_BIT, 0.3, ["rd", "rs1"]),
            
            # Multiply Instructions (7% total) - Creates multicycle hazards
            "mul": InstructionTemplate("mul", "R", InstrType.MULTIPLY, 2.5, ["rd", "rs1", "rs2"]),
            "mulh": InstructionTemplate("mulh", "R", InstrType.MULTIPLY, 1.0, ["rd", "rs1", "rs2"]),
            "mulhsu": InstructionTemplate("mulhsu", "R", InstrType.MULTIPLY, 0.8, ["rd", "rs1", "rs2"]),
            "mulhu": InstructionTemplate("mulhu", "R", InstrType.MULTIPLY, 0.8, ["rd", "rs1", "rs2"]),
            "div": InstructionTemplate("div", "R", InstrType.MULTIPLY, 0.9, ["rd", "rs1", "rs2"]),
            "divu": InstructionTemplate("divu", "R", InstrType.MULTIPLY, 0.7, ["rd", "rs1", "rs2"]),
            "rem": InstructionTemplate("rem", "R", InstrType.MULTIPLY, 0.2, ["rd", "rs1", "rs2"]),
            "remu": InstructionTemplate("remu", "R", InstrType.MULTIPLY, 0.1, ["rd", "rs1", "rs2"]),
            
            # Misaligned Memory Access Instructions (3% total) - Creates structural hazards
            "lw_misaligned": InstructionTemplate("lw", "I", InstrType.MISALIGNED_MEM, 1.0, ["rd", "misaligned_offset", "rs1"]),
            "lh_misaligned": InstructionTemplate("lh", "I", InstrType.MISALIGNED_MEM, 0.8, ["rd", "misaligned_offset", "rs1"]),
            "sw_misaligned": InstructionTemplate("sw", "S", InstrType.MISALIGNED_MEM, 0.8, ["rs2", "misaligned_offset", "rs1"]),
            "sh_misaligned": InstructionTemplate("sh", "S", InstrType.MISALIGNED_MEM, 0.4, ["rs2", "misaligned_offset", "rs1"]),
        }
        
        # Memory layout for load/store operations
        self.memory_base = 0x10000000
        self.memory_size = 0x1000
        
        # Label counter for branches and jumps
        self.label_counter = 0
        self.generated_labels = []
        self.branch_setup_registers = ['t3', 't4', 't5', 't6']  # Registers for branch condition setup
        
    def get_random_register(self, exclude_zero=True) -> str:
        """Get a random register, optionally excluding x0"""
        if exclude_zero:
            return random.choice(self.registers[1:])
        return random.choice(self.registers)
    
    def get_random_immediate(self, bits=12, signed=True) -> int:
        """Generate random immediate value"""
        if signed:
            return random.randint(-(2**(bits-1)), 2**(bits-1)-1)
        else:
            return random.randint(0, 2**bits-1)
    
    def get_random_offset(self) -> int:
        """Generate random memory offset"""
        return random.randint(0, self.memory_size-4) & ~3  # Word-aligned
    
    def get_misaligned_offset(self) -> int:
        """Generate misaligned memory offset"""
        base_offset = random.randint(0, self.memory_size-8) & ~3  # Start with word-aligned base
        misalign = random.choice(self.misaligned_offsets)
        return base_offset + misalign
    
    def generate_misaligned_memory_setup(self, instruction_type: str) -> List[str]:
        """Generate setup instructions for misaligned memory access"""
        setup_instructions = []
        base_reg = random.choice(self.branch_setup_registers)
        
        # Set up base address for misaligned access
        base_addr = self.memory_base + random.randint(0, self.memory_size//2)
        setup_instructions.append(f"    lui {base_reg}, {base_addr >> 12}")
        setup_instructions.append(f"    addi {base_reg}, {base_reg}, {base_addr & 0xfff}")
        
        # Add some test data setup for stores
        if instruction_type in ["sw_misaligned", "sh_misaligned"]:
            data_reg = random.choice([r for r in self.branch_setup_registers if r != base_reg])
            test_value = random.randint(0x1000, 0xFFFF)
            setup_instructions.append(f"    addi {data_reg}, zero, {test_value}")
            return setup_instructions, base_reg, data_reg
        
        return setup_instructions, base_reg, None
    
    def generate_label(self) -> str:
        """Generate a unique label"""
        label = f"label_{self.label_counter}"
        self.label_counter += 1
        self.generated_labels.append(label)
        return label
    
    def generate_branch_setup(self, branch_type: str, taken: bool) -> List[str]:
        """Generate instructions to set up registers for branch conditions"""
        setup_instructions = []
        reg1 = random.choice(self.branch_setup_registers)
        reg2 = random.choice(self.branch_setup_registers)
        
        if taken:
            # Generate conditions that will cause branch to be taken
            if branch_type == "beq":
                val = random.randint(1, 100)
                setup_instructions.append(f"    addi {reg1}, zero, {val}")
                setup_instructions.append(f"    addi {reg2}, zero, {val}")
            elif branch_type == "bne":
                val1 = random.randint(1, 100)
                val2 = random.randint(101, 200)
                setup_instructions.append(f"    addi {reg1}, zero, {val1}")
                setup_instructions.append(f"    addi {reg2}, zero, {val2}")
            elif branch_type == "blt":
                val1 = random.randint(1, 50)
                val2 = random.randint(51, 100)
                setup_instructions.append(f"    addi {reg1}, zero, {val1}")
                setup_instructions.append(f"    addi {reg2}, zero, {val2}")
            elif branch_type == "bge":
                val1 = random.randint(51, 100)
                val2 = random.randint(1, 50)
                setup_instructions.append(f"    addi {reg1}, zero, {val1}")
                setup_instructions.append(f"    addi {reg2}, zero, {val2}")
            elif branch_type == "bltu":
                val1 = random.randint(1, 50)
                val2 = random.randint(51, 100)
                setup_instructions.append(f"    addi {reg1}, zero, {val1}")
                setup_instructions.append(f"    addi {reg2}, zero, {val2}")
            elif branch_type == "bgeu":
                val1 = random.randint(51, 100)
                val2 = random.randint(1, 50)
                setup_instructions.append(f"    addi {reg1}, zero, {val1}")
                setup_instructions.append(f"    addi {reg2}, zero, {val2}")
        else:
            # Generate conditions that will cause branch to NOT be taken
            if branch_type == "beq":
                val1 = random.randint(1, 100)
                val2 = random.randint(101, 200)
                setup_instructions.append(f"    addi {reg1}, zero, {val1}")
                setup_instructions.append(f"    addi {reg2}, zero, {val2}")
            elif branch_type == "bne":
                val = random.randint(1, 100)
                setup_instructions.append(f"    addi {reg1}, zero, {val}")
                setup_instructions.append(f"    addi {reg2}, zero, {val}")
            elif branch_type == "blt":
                val1 = random.randint(51, 100)
                val2 = random.randint(1, 50)
                setup_instructions.append(f"    addi {reg1}, zero, {val1}")
                setup_instructions.append(f"    addi {reg2}, zero, {val2}")
            elif branch_type == "bge":
                val1 = random.randint(1, 50)
                val2 = random.randint(51, 100)
                setup_instructions.append(f"    addi {reg1}, zero, {val1}")
                setup_instructions.append(f"    addi {reg2}, zero, {val2}")
            elif branch_type == "bltu":
                val1 = random.randint(51, 100)
                val2 = random.randint(1, 50)
                setup_instructions.append(f"    addi {reg1}, zero, {val1}")
                setup_instructions.append(f"    addi {reg2}, zero, {val2}")
            elif branch_type == "bgeu":
                val1 = random.randint(1, 50)
                val2 = random.randint(51, 100)
                setup_instructions.append(f"    addi {reg1}, zero, {val1}")
                setup_instructions.append(f"    addi {reg2}, zero, {val2}")
        
        return setup_instructions, reg1, reg2
    
    def format_instruction(self, template: InstructionTemplate, setup_regs=None, misaligned_data=None) -> str:
        """Format an instruction based on its template"""
        operands = []
        
        for operand in template.operands:
            if operand == "rd":
                operands.append(self.get_random_register())
            elif operand == "rs1":
                if setup_regs and template.instr_type == InstrType.BRANCH:
                    operands.append(setup_regs[0])
                elif setup_regs and template.instr_type == InstrType.MISALIGNED_MEM:
                    operands.append(setup_regs[0])  # Base register for memory access
                else:
                    operands.append(self.get_random_register())
            elif operand == "rs2":
                if setup_regs and template.instr_type == InstrType.BRANCH:
                    operands.append(setup_regs[1])
                elif setup_regs and template.instr_type == InstrType.MISALIGNED_MEM and len(setup_regs) > 1:
                    operands.append(setup_regs[1])  # Data register for store operations
                else:
                    operands.append(self.get_random_register())
            elif operand == "imm12":
                operands.append(str(self.get_random_immediate(12)))
            elif operand == "shamt":
                operands.append(str(random.randint(0, 31)))
            elif operand == "offset":
                operands.append(str(self.get_random_offset()))
            elif operand == "misaligned_offset":
                if misaligned_data:
                    operands.append(str(misaligned_data))
                else:
                    operands.append(str(self.get_misaligned_offset()))
            elif operand == "label":
                # For branches, use existing labels or create forward references
                if random.random() < 0.3 and self.generated_labels:
                    operands.append(random.choice(self.generated_labels))
                else:
                    operands.append(self.generate_label())
        
        return f"    {template.mnemonic} {', '.join(operands)}"
    
    def generate_assembly(self, num_instructions: int, distribution: Dict[str, float] = None, cv_weight: float = 1.0, branch_taken_rate: float = 0.5, misaligned_rate: float = 0.3) -> str:
        """Generate assembly code with specified instruction count and distribution"""
        
        # Set branch taken probability and misaligned rate
        self.branch_taken_probability = branch_taken_rate
        self.misaligned_probability = misaligned_rate
        
        # Use default distribution if none provided
        if distribution is None:
            distribution = {instr_type.value: 1.0 for instr_type in InstrType}
        
        # Create weighted instruction list based on distribution
        weighted_instructions = []
        for name, template in self.instruction_templates.items():
            type_weight = distribution.get(template.instr_type.value, 1.0)
            
            # Apply CV extension weight multiplier
            if template.instr_type in [InstrType.CUSTOM_ALU, InstrType.CUSTOM_BIT]:
                type_weight *= cv_weight
            
            final_weight = template.weight * type_weight
            weighted_instructions.extend([name] * int(final_weight * 10))
        
        # Generate assembly header
        assembly = [
            "# CV32E40P Assembly Test Program",
            "# Generated with target instruction distribution",
            "",
            ".section .text",
            ".global _start",
            "",
            "_start:",
            "    # Initialize stack pointer",
            f"    lui sp, {(self.memory_base + self.memory_size) >> 12}",
            f"    addi sp, sp, {(self.memory_base + self.memory_size) & 0xfff}",
            "",
            "    # Initialize base register for memory operations",
            f"    lui t0, {self.memory_base >> 12}",
            f"    addi t0, t0, {self.memory_base & 0xfff}",
            "",
            "main_loop:"
        ]
        
        # Generate instructions
        for i in range(num_instructions):
            if random.random() < 0.1:  # 10% chance of adding a label
                assembly.append(f"{self.generate_label()}:")
            
            instr_name = random.choice(weighted_instructions)
            template = self.instruction_templates[instr_name]
            
            # Special handling for branch instructions to create predictable taken/not-taken patterns
            if template.instr_type == InstrType.BRANCH:
                branch_taken = random.random() < self.branch_taken_probability
                setup_instructions, reg1, reg2 = self.generate_branch_setup(template.mnemonic, branch_taken)
                
                # Add setup instructions
                for setup_instr in setup_instructions:
                    assembly.append(setup_instr)
                
                # Add the branch instruction with setup registers
                assembly.append(self.format_instruction(template, setup_regs=[reg1, reg2]))
                
                # Add some instructions after branch to create pipeline flush scenarios
                if branch_taken:
                    # Add a few NOPs or simple instructions that will be flushed
                    assembly.append("    nop  # This will be flushed if branch taken")
                    assembly.append("    nop  # This will be flushed if branch taken")
            
            # Special handling for misaligned memory instructions
            elif template.instr_type == InstrType.MISALIGNED_MEM:
                setup_instructions, base_reg, data_reg = self.generate_misaligned_memory_setup(instr_name)
                
                # Add setup instructions
                for setup_instr in setup_instructions:
                    assembly.append(setup_instr)
                
                # Generate misaligned offset
                misaligned_offset = random.choice(self.misaligned_offsets)
                
                # Add the misaligned memory instruction
                if data_reg:  # Store instruction
                    assembly.append(self.format_instruction(template, setup_regs=[base_reg, data_reg], misaligned_data=misaligned_offset))
                else:  # Load instruction
                    assembly.append(self.format_instruction(template, setup_regs=[base_reg], misaligned_data=misaligned_offset))
                
                # Add comment about the misalignment
                assembly.append(f"    # Above instruction uses misaligned offset {misaligned_offset} - will cause structural hazard")
                
                # Add a few instructions that might be affected by the misaligned access stall
                assembly.append("    nop  # May be stalled due to misaligned access")
                assembly.append("    add t1, t1, t2  # May be stalled due to misaligned access")
            
            else:
                assembly.append(self.format_instruction(template))
        
        # Add remaining labels that were referenced but not yet defined
        for label in self.generated_labels:
            if f"{label}:" not in assembly:
                assembly.append(f"{label}:")
                assembly.append("    nop")
        
        # Add program termination
        assembly.extend([
            "",
            "program_end:",
            "    # Infinite loop to end program",
            "    j program_end",
            "",
            ".section .data",
            "test_data:",
            "    .word 0x12345678, 0xdeadbeef, 0xcafebabe, 0x0f0f0f0f"
        ])
        
        return "\n".join(assembly)
    
    def generate_statistics(self, assembly_code: str) -> Dict:
        """Generate statistics about the generated assembly"""
        lines = assembly_code.split('\n')
        instruction_lines = [line.strip() for line in lines if line.strip() and not line.strip().startswith('#') and not line.strip().startswith('.') and not line.strip().endswith(':') and line.strip() != '']
        
        stats = {
            'total_instructions': len(instruction_lines),
            'instruction_types': {instr_type.value: 0 for instr_type in InstrType},
            'instruction_breakdown': {}
        }
        
        for line in instruction_lines:
            # Extract instruction mnemonic
            parts = line.strip().split()
            if parts:
                mnemonic = parts[0]
                if mnemonic in self.instruction_templates:
                    template = self.instruction_templates[mnemonic]
                    stats['instruction_types'][template.instr_type.value] += 1
                    stats['instruction_breakdown'][mnemonic] = stats['instruction_breakdown'].get(mnemonic, 0) + 1
        
        return stats

def main():
    parser = argparse.ArgumentParser(description='Generate CV32E40P assembly with target instruction distribution')
    parser.add_argument('-n', '--num-instructions', type=int, default=1000, 
                       help='Number of instructions to generate (default: 1000)')
    parser.add_argument('-o', '--output', type=str, default='test_program.s',
                       help='Output assembly file (default: test_program.s)')
    parser.add_argument('-d', '--distribution', type=str,
                       help='JSON file with instruction type distribution weights')
    parser.add_argument('-s', '--seed', type=int,
                       help='Random seed for reproducible generation')
    parser.add_argument('--stats', action='store_true',
                       help='Generate statistics file')
    parser.add_argument('--preset', choices=['embedded', 'dsp', 'control', 'mixed', 'multiply_heavy', 'branch_heavy', 'misaligned_heavy'], default='embedded',
                       help='Use preset distribution (default: embedded)')
    parser.add_argument('--cv-weight', type=float, default=1.0,
                       help='Weight multiplier for CV32E40P extension instructions (default: 1.0)')
    parser.add_argument('--branch-taken-rate', type=float, default=0.5,
                       help='Probability of branches being taken (0.0-1.0, default: 0.5)')
    parser.add_argument('--misaligned-rate', type=float, default=0.3,
                       help='Probability of memory accesses being misaligned (0.0-1.0, default: 0.3)')
    
    args = parser.parse_args()
    
    # Set random seed if provided
    if args.seed:
        random.seed(args.seed)
    
    generator = CV32E40PAssemblyGenerator()
    
    # Load distribution from file or use preset
    distribution = None
    if args.distribution:
        with open(args.distribution, 'r') as f:
            distribution = json.load(f)
    elif args.preset:
        presets = {
            'embedded': {
                'arithmetic': 2.0, 'logical': 1.5, 'shift': 1.0, 'comparison': 1.2,
                'branch': 1.8, 'load_store': 2.5, 'jump': 0.5, 'custom_alu': 0.8, 'custom_bit': 0.3, 'multiply': 0.8, 'misaligned_mem': 0.2
            },
            'dsp': {
                'arithmetic': 3.0, 'logical': 1.0, 'shift': 2.0, 'comparison': 1.0,
                'branch': 1.0, 'load_store': 2.0, 'jump': 0.3, 'custom_alu': 2.0, 'custom_bit': 1.5, 'multiply': 2.5, 'misaligned_mem': 0.5
            },
            'control': {
                'arithmetic': 1.5, 'logical': 2.0, 'shift': 0.8, 'comparison': 2.5,
                'branch': 3.0, 'load_store': 1.5, 'jump': 1.0, 'custom_alu': 0.5, 'custom_bit': 0.8, 'multiply': 0.3, 'misaligned_mem': 0.1
            },
            'mixed': {
                'arithmetic': 1.0, 'logical': 1.0, 'shift': 1.0, 'comparison': 1.0,
                'branch': 1.0, 'load_store': 1.0, 'jump': 1.0, 'custom_alu': 1.0, 'custom_bit': 1.0, 'multiply': 1.0, 'misaligned_mem': 1.0
            },
            'multiply_heavy': {
                'arithmetic': 1.0, 'logical': 0.5, 'shift': 0.5, 'comparison': 0.8,
                'branch': 0.8, 'load_store': 1.5, 'jump': 0.3, 'custom_alu': 0.5, 'custom_bit': 0.3, 'multiply': 4.0, 'misaligned_mem': 0.3
            },
            'branch_heavy': {
                'arithmetic': 1.0, 'logical': 0.8, 'shift': 0.5, 'comparison': 1.5,
                'branch': 4.0, 'load_store': 1.0, 'jump': 1.5, 'custom_alu': 0.3, 'custom_bit': 0.2, 'multiply': 0.5, 'misaligned_mem': 0.2
            },
            'misaligned_heavy': {
                'arithmetic': 1.0, 'logical': 0.8, 'shift': 0.5, 'comparison': 0.8,
                'branch': 1.0, 'load_store': 2.0, 'jump': 0.3, 'custom_alu': 0.5, 'custom_bit': 0.3, 'multiply': 0.8, 'misaligned_mem': 3.0
            }
        }
        distribution = presets[args.preset]
    
    # Generate assembly
    assembly_code = generator.generate_assembly(args.num_instructions, distribution, args.cv_weight, args.branch_taken_rate, args.misaligned_rate)
    
    # Write output file
    with open(args.output, 'w') as f:
        f.write(assembly_code)
    
    print(f"Generated {args.num_instructions} instructions in {args.output}")
    
    # Generate statistics if requested
    if args.stats:
        stats = generator.generate_statistics(assembly_code)
        stats_file = args.output.replace('.s', '_stats.json')
        with open(stats_file, 'w') as f:
            json.dump(stats, f, indent=2)
        
        print(f"Statistics written to {stats_file}")
        print("\nInstruction Type Distribution:")
        for instr_type, count in stats['instruction_types'].items():
            percentage = (count / stats['total_instructions']) * 100
            print(f"  {instr_type:15}: {count:4d} ({percentage:5.1f}%)")

if __name__ == "__main__":
    main()