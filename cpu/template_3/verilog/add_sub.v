module add_sub (
    input  wire [31:0] a_i,
    input  wire [31:0] b_i,
    input  wire        sub_i,
    output reg        carry_o,
    output reg        zero_o,
    output reg [31:0] r_o
);

reg [31:0] second_operand_r;
reg [32:0] temp_r;
always @(*) begin
    carry_o = 0;
    zero_o = 0;
    r_o = 0;
    second_operand_r = 0;

    second_operand_r = sub_i ? ~b_i : b_i;
    temp_r = {1'b0, a_i} + {1'b0, second_operand_r} + sub_i;
    carry_o = temp_r[32];
    r_o = temp_r[31:0];
    zero_o = r_o == 0;
end
endmodule
