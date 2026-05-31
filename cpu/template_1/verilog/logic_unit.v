module logic_unit (
    input  wire [31:0] a_i,
    input  wire [31:0] b_i,
    input  wire [ 2:0] op_i,
    output reg [31:0] r_o
);

parameter XOR = 3'b100;
parameter OR = 3'b110;
parameter AND = 3'b111;

    always @(*) begin
        r_o = 0;

        case (op_i)
            XOR: r_o = a_i ^ b_i;
            OR: r_o = a_i | b_i;
            AND: r_o = a_i & b_i;
            default: r_o = 0;
        endcase

    end
endmodule
