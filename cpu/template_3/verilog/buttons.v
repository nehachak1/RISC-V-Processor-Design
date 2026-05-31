module buttons (
    input  wire        clk_i,
    input  wire        rst_ni,
    input  wire        en_i,
    input  wire [31:0] addr_i,
    input  wire [ 9:0] push_i,
    input  wire [ 7:0] switch_i,
    output reg [31:0] rdata_o
);

localparam BASE_ADDR = 32'h70000000;
reg [31:0] val_r;
reg read_initiated_r;

always @(posedge clk_i) begin
    if (read_initiated_r) begin
    rdata_o <= val_r;
    read_initiated_r <= 0;
    end

    if (!rst_ni) begin
        val_r <= 0;
    end else if(en_i && (addr_i == BASE_ADDR)) begin
        val_r <= {8'h00, switch_i, 6'b000000, push_i};
        read_initiated_r <= 1;
    end
end

endmodule
