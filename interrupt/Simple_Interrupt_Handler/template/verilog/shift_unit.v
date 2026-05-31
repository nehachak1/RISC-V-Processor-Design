module shift_unit (
    input  wire [31:0] a_i,
    input  wire [31:0] b_i,
    input  wire [ 2:0] op_i,
    input  wire        arithmetic_i,
    output reg [31:0] r_o
);

parameter SHIFT_LEFT = 3'b001;
parameter SHIFT_RIGHT = 3'b101;

reg [4:0] shift_r;
reg [31:0] mask_r;

always @(*) begin
    r_o = 0;
    shift_r = b_i[4:0];

    case (op_i)
        SHIFT_LEFT: r_o = a_i << shift_r;
        SHIFT_RIGHT:
            if (arithmetic_i) begin
                mask_r = ((1 << shift_r) - 1) << (32 - shift_r);
                r_o = a_i[31] == 1 ? mask_r | (a_i >> shift_r) : a_i >> shift_r;
            end else begin
                r_o = a_i >> shift_r;
            end
        default: r_o = 0;
    endcase
end
endmodule
