module shift_unit (
    input  wire [31:0] a_i,
    input  wire [31:0] b_i,
    input  wire [ 2:0] op_i,
    input  wire        arithmetic_i,
    output reg [31:0] r_o
);

parameter SHIFT_LEFT = 3'b001;
parameter SHIFT_RIGHT = 3'b101;

reg [4:0] shift;
reg [31:0] mask;

always @(*) begin
    r_o = 0;
    shift = b_i[4:0];

    case (op_i)
        SHIFT_LEFT: r_o = a_i << shift;
        SHIFT_RIGHT:
            if (arithmetic_i) begin
                mask = ((1 << shift) - 1) << (32 - shift);
                r_o = a_i[31] == 1 ? mask | (a_i >> shift) : a_i >> shift;
            end else begin
                r_o = a_i >> shift;
            end
        default: r_o = 0;
    endcase
end
endmodule
