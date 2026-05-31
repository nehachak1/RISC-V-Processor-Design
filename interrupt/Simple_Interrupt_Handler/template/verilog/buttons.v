module buttons (
    input  wire        clk_i,
    input  wire        rst_ni,
    input  wire        en_i,
    input  wire        we_i,
    input  wire [31:0] addr_i,
    input  wire [31:0] wdata_i,
    input  wire [ 9:0] push_i,
    input  wire [ 7:0] switch_i,
    output reg  [31:0] rdata_o,
    output reg         irq_o
);
    // Local parameters for MMIO addresses
    localparam VAL_ADDR = 32'h70000000;
    localparam SRC_ADDR = 32'h70000004;
    localparam PTM_ADDR = 32'h70000008;
    localparam STM_ADDR = 32'h7000000C;

    // Internal Registers
    reg [31:0] val_r;
    reg [31:0] src_r;
    reg [19:0] ptm_r;
    reg [15:0] stm_r;

    // Interrupt detection
    reg [31:0] next_val_r;
    reg [31:0] edges_r;
    reg [31:0] next_src_r;
    reg [31:0] edge_interrupts_r;
    localparam ACTIVE_LOW   = 2'b00;
    localparam RISING_EDGE  = 2'b01;
    localparam FALLING_EDGE = 2'b10;
    localparam ACTIVE_HIGH  = 2'b11;

always @(posedge clk_i) begin
    val_r <= next_val_r;
    src_r <= next_src_r; // conflict with src write ?
    if (!rst_ni) begin
        //RESET
        val_r <= 0;
        src_r <= 0;
        ptm_r <= {20{1'b1}};
        stm_r <= {16{1'b1}};
        rdata_o <= 0;
        irq_o <= 0;
    end else begin
        if (en_i) begin
            if (we_i) begin
                //WRITE
                case (addr_i)
                    SRC_ADDR: src_r <= wdata_i == 0 ? next_src_r & !edge_interrupts_r : next_src_r;
                    PTM_ADDR: ptm_r <= wdata_i[19:0];
                    STM_ADDR: stm_r <= wdata_i[15:0];
                    default: ;
                endcase
            end else begin
                //READ
                case (addr_i)
                    VAL_ADDR: rdata_o <= val_r;
                    SRC_ADDR: rdata_o <= src_r;
                    default:  rdata_o <= 0;
                endcase
            end
        end else begin
            rdata_o <= 0;
        end
        //INTERRUPT REQUEST
        irq_o <= src_r != 0;
    end
end

always @(*) begin
    integer i;
    integer j;
    next_val_r = 0;
    next_src_r = 0;
    edge_interrupts_r = 0;
    next_val_r = {8'h00, switch_i, 6'b000000, push_i};
    edges_r = next_val_r ^ val_r;
    //Detecting interrupts from push buttons
    for(i = 0; i < 10; i = i + 1) begin
        case (ptm_r[2*i +: 2])
            ACTIVE_LOW  : next_src_r[i] = !next_val_r[i];
            RISING_EDGE :
                begin
                    next_src_r[i] = src_r | (edges_r[i] & next_val_r[i]);
                    edge_interrupts_r[i] = 1;
                end
            FALLING_EDGE:
                begin
                    next_src_r[i] = src_r | (edges_r[i] & !next_val_r[i]);
                    edge_interrupts_r[i] = 1;
                end
            ACTIVE_HIGH : next_src_r[i] = next_val_r[i];
            default     : next_src_r[i] = 0;
        endcase
    end
    //Detecting interrupts from switch buttons
    for(i = 0; i < 8; i = i + 1) begin
        j = 16 + i;
        case (stm_r[2*i +: 2])
            ACTIVE_LOW  : next_src_r[j] = !next_val_r[j];
            RISING_EDGE :
                begin
                    next_src_r[j] = src_r | (edges_r[j] & next_val_r[j]);
                    edge_interrupts_r[j] = 1;
                end
            FALLING_EDGE:
                begin
                    next_src_r[j] = src_r | (edges_r[j] & !next_val_r[j]);
                    edge_interrupts_r[i] = 1;
                end
            ACTIVE_HIGH : next_src_r[j] = next_val_r[j];
            default     : next_src_r[j] = 0;
        endcase
    end
    //masking unused bits
    next_src_r = next_src_r & 32'b00000000111111110000001111111111;
    next_val_r = next_val_r & 32'b00000000111111110000001111111111;
end

endmodule
