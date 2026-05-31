.section ".text.init"
.globl _start
_start:

    # I_TYPE: (addi), (slti), (sltiu), (xori), (ori), (andi), (slli), (srli), (srai)
    # R_TYPE: (add), (sub), (sll), (slt), (sltu), (xor), (srl), (sra), (or), (and)
    # U_TYPE: (lui)
    # LOAD  : (lw)
    # S_TYPE: (sw)
    # BREAK : (ebreak)
    # B_TYPE: (beq), (bne), (blt), (bge), (bltu), (bgeu)
    # J_TYPE: (jal)
    # JALR  : (jalr)

    #0000_0110_1101_1011_0100_1111_0110_0110


    li t0, 0x60000000
    li t1, 0b00000110110110110100111101100110
    sw t1, 0(t0)
    ebreak
        