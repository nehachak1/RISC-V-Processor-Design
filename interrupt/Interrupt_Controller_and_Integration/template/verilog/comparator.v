module comparator (
    input  wire       a_31_i,
    input  wire       b_31_i,
    input  wire       diff_31_i,
    input  wire       carry_i,
    input  wire       zero_i,
    input  wire [2:0] op_i,
    output reg       r_o
);

parameter EQUAL                 = 3'b000;
parameter NOT_EQUAL             = 3'b001;
parameter LESS_SIGNED           = 3'b100;
parameter GREATER_EQ_SIGNED     = 3'b101;
parameter LESS_UNSIGNED         = 3'b110;
parameter GREATER_EQ_UNSIGNED   = 3'b111;

always @(*) begin
    r_o = 0;

    case (op_i)
        EQUAL:               r_o = zero_i;
        NOT_EQUAL:           r_o = ~zero_i;
        LESS_SIGNED:         r_o = (a_31_i && ~b_31_i) || ((a_31_i ~^ b_31_i) && diff_31_i);
        GREATER_EQ_SIGNED:   r_o = (~a_31_i && b_31_i) || ((a_31_i ~^ b_31_i) && ~diff_31_i);
        LESS_UNSIGNED:       r_o = ~carry_i && ~zero_i;
        GREATER_EQ_UNSIGNED: r_o = carry_i || zero_i;
        default:             r_o = 0;
    endcase
end

endmodule
