module add_sub (
    input  wire [31:0] a_i,
    input  wire [31:0] b_i,
    input  wire        sub_i,
    output reg        carry_o,
    output reg        zero_o,
    output reg [31:0] r_o
);

reg [31:0] second_operand;
reg [32:0] temp;
always @(*) begin
    carry_o = 0;
    zero_o = 0;
    r_o = 0;
    second_operand = 0;

    second_operand = sub_i ? ~b_i : b_i;
    temp = {1'b0, a_i} + {1'b0, second_operand} + sub_i;
    carry_o = temp[32];
    r_o = temp[31:0];
    zero_o = r_o == 0;
end
endmodule
