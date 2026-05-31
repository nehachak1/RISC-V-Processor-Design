module controller (
    input wire clk_i,
    input wire rst_ni,

    // Current instruction
    input wire [31:0] instruction_i,

    // Branch operation
    output reg branch_op_o,

    // Immediate value correctly extended
    output reg [31:0] imm_o,

    // Instruction Register control signals
    output reg ir_en_o,

    // PC control signals
    output reg pc_add_imm_o,
    output reg pc_en_o,
    output reg pc_sel_alu_o,
    output reg pc_sel_pc_base_o,

    // Register file control signals
    output reg rf_we_o,

    // Multiplexer control signals
    output reg sel_addr_o,
    output reg sel_b_o,
    output reg sel_mem_o,
    output reg sel_pc_o,
    output reg sel_imm_o,

    // Memory control signals
    output reg we_o,

    // ALU control signals
    output reg [5:0] alu_op_o
);

    // States
    parameter FETCH1 = 7'b0000000; // not opcode
    parameter FETCH2 = 7'b0000001; // not opcode
    parameter DECODE = 7'b0000010; // not opcode

    parameter I_TYPE = 7'b0010011;
    parameter R_TYPE = 7'b0110011;
    parameter U_TYPE = 7'b0110111;
    parameter LOAD1  = 7'b0000011;
    parameter LOAD2  = 7'b0000111; // not opcode
    parameter S_TYPE = 7'b0100011;
    parameter BREAK  = 7'b1110011;
    parameter B_TYPE = 7'b1100011;
    parameter J_TYPE = 7'b1101111;
    parameter JALR   = 7'b1100111;

    reg [6:0] state_r, next_state_r;

    // alu_op_o computation
    reg [6:0] opcode_r;
    reg [2:0] funct3_r;
    reg [6:0] funct7_r;


    //Update current state
    always @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            state_r <= FETCH1;
        end else begin
            state_r <= next_state_r;
        end
    end


    // Update next state
    always @(*) begin
        // Default signal values
        branch_op_o = 0;
        imm_o = 32'b0;
        ir_en_o = 0;
        pc_add_imm_o = 0;
        pc_en_o = 0;
        pc_sel_alu_o = 0;
        pc_sel_pc_base_o = 0;
        rf_we_o = 0;
        sel_addr_o = 0;
        sel_b_o = 0;
        sel_mem_o = 0;
        sel_pc_o = 0;
        sel_imm_o = 0;
        we_o = 0;

        case (state_r)
            FETCH1: begin
                next_state_r = FETCH2;
            end
            FETCH2: begin
                ir_en_o = 1;
                pc_en_o = 1;
                next_state_r = DECODE;
            end
            DECODE: begin
                next_state_r = instruction_i[6:0]; // execute states == opcode
            end
            I_TYPE: begin
                imm_o = {{20{instruction_i[31]}}, instruction_i[31:20]};
                rf_we_o = 1;

                next_state_r = FETCH2;
            end
            R_TYPE: begin
                rf_we_o = 1;
                sel_b_o = 1;

                next_state_r = FETCH2;
            end
            U_TYPE: begin
                sel_imm_o = 1;
                rf_we_o = 1;
                imm_o = {instruction_i[31:12], 12'b0};

                next_state_r = FETCH2;
            end
            LOAD1: begin
                sel_addr_o = 1;
                imm_o = {{20{instruction_i[31]}}, instruction_i[31:20]};

                next_state_r = LOAD2;
            end
            LOAD2: begin
                imm_o = {{20{instruction_i[31]}}, instruction_i[31:20]};
                sel_mem_o = 1;
                sel_addr_o = 1;
                rf_we_o = 1;

                next_state_r = FETCH1;
            end
            S_TYPE: begin
                imm_o = {{20{instruction_i[31]}}, instruction_i[31:25], instruction_i[11:7]};
                sel_addr_o = 1;
                we_o = 1;

                next_state_r = FETCH1;
            end
            BREAK: begin
                next_state_r = BREAK;
            end
            B_TYPE: begin
                imm_o = {{20{instruction_i[31]}}, instruction_i[7], instruction_i[30:25],
                    instruction_i[11:8], 1'b0};
                branch_op_o = 1;
                pc_add_imm_o = 1;
                pc_sel_pc_base_o = 1;
                sel_b_o = 1;

                next_state_r = FETCH1;
            end
            J_TYPE: begin
                imm_o = {{12{instruction_i[31]}}, instruction_i[19:12], instruction_i[20],
                    instruction_i[30:21], 1'b0};
                pc_en_o = 1;
                pc_add_imm_o = 1;
                pc_sel_pc_base_o = 1;
                sel_pc_o = 1;
                rf_we_o = 1;

                next_state_r = FETCH1;
            end
            JALR: begin
                imm_o = {{20{instruction_i[31]}}, instruction_i[31:20]};
                sel_pc_o = 1;
                pc_sel_alu_o = 1;
                pc_en_o = 1;
                rf_we_o = 1;

                next_state_r = FETCH1;
            end
            default: begin
                next_state_r = FETCH1;
            end
        endcase
    end


    // compute alu_op_o from the newly fetched instruction
    always @(*) begin
        alu_op_o = 0; // initialize value to avoid latches
        opcode_r = instruction_i[ 6: 0];
        funct3_r = instruction_i[14:12];
        funct7_r = instruction_i[31:25];

        case (opcode_r)
            I_TYPE: begin
                case (funct3_r)
                    3'b000: alu_op_o = 6'b000000; //addi
                    3'b010: alu_op_o = 6'b011100; //slti
                    3'b011: alu_op_o = 6'b011110; //sltiu
                    3'b100: alu_op_o = 6'b100100; //xori
                    3'b110: alu_op_o = 6'b100110; //ori
                    3'b111: alu_op_o = 6'b100111; //andi
                    3'b001: alu_op_o = funct7_r == 0 ? 6'b110001 : 0; //slli
                    3'b101: alu_op_o = funct7_r == 0 ? 6'b110101 : 6'b111101; //srli : srai
                    default: alu_op_o = 0;
                endcase
            end
            R_TYPE: begin
                case (funct3_r)
                    3'b000: alu_op_o = funct7_r == 7'b0100000 ? 6'b001000 : 6'b000000; //sub : add
                    3'b001: alu_op_o = funct7_r == 0 ? 6'b110001 : 0; //sll
                    3'b010: alu_op_o = funct7_r == 0 ? 6'b011100 : 0; //slt
                    3'b011: alu_op_o = funct7_r == 0 ? 6'b011110 : 0; //sltu
                    3'b100: alu_op_o = funct7_r == 0 ? 6'b100100 : 0; //xor
                    3'b101: alu_op_o = funct7_r == 7'b0100000 ? 6'b111101 : 6'b110101; //sra : srl
                    3'b110: alu_op_o = funct7_r == 0 ? 6'b100110 : 0; //or
                    3'b111: alu_op_o = funct7_r == 0 ? 6'b100111 : 0; //and
                    default: alu_op_o = 0;
                endcase
            end
            B_TYPE: begin
                alu_op_o = {3'b011, funct3_r};
            end
            default: begin
                alu_op_o = 0;
            end
        endcase
    end

endmodule
