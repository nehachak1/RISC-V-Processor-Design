module decoder (
    input  wire [31:0] addr_i,
    output reg        en_ram_o,
    output reg        en_leds_o,
    output reg        en_7_seg_lcd_o,
    output reg        en_buttons_o
);

always @(*) begin
    //initialization
    en_ram_o       = 0;
    en_leds_o      = 0;
    en_7_seg_lcd_o = 0;
    en_buttons_o   = 0;

    //logic
    en_leds_o      = (32'h50000000 <= addr_i) && (addr_i <= 32'h50000FFF);
    en_7_seg_lcd_o = (32'h60000000 <= addr_i) && (addr_i <= 32'h60000FFF);
    en_buttons_o   = (32'h70000000 <= addr_i) && (addr_i <= 32'h70000FFF);
    en_ram_o       = (32'h80000000 <= addr_i) && (addr_i <= 32'h9FFFFFFF);
end

endmodule
