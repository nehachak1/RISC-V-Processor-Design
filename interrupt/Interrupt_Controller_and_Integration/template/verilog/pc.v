module pc (
    input  wire        clk_i,
    input  wire        rst_ni,
    input  wire        en_i,
    input  wire        sel_alu_i,
    input  wire        sel_pc_base_i,
    input  wire        add_imm_i,
    input  wire [31:0] imm_i,
    input  wire [31:0] alu_i,
    input  wire        sel_mtvec_i,
    input  wire [31:0] mtvec_i,
    input  wire        sel_mepc_i,
    input  wire [31:0] mepc_i,
    output reg  [31:0] addr_o
);

reg [31:0] next_addr_r;

always @(posedge clk_i) begin
    if (!rst_ni) begin
        addr_o <= 32'h80000000;
    end else if (en_i) begin
        addr_o <= next_addr_r;
    end
end

always @(*) begin
    next_addr_r = 32'h80000000;
    if (sel_mtvec_i) begin
        next_addr_r = {mtvec_i[31:2], 2'b00};
    end else if (sel_mepc_i) begin
        next_addr_r = mepc_i;
    end else if (sel_alu_i) begin
        next_addr_r = alu_i & 32'hFFFFFFFC;
    end else if (add_imm_i) begin
        if (sel_pc_base_i) begin
            next_addr_r = addr_o - 4 + imm_i;
        end else begin
            next_addr_r = addr_o + imm_i;
        end
    end else begin
        next_addr_r = addr_o + 4;
    end
end


endmodule
