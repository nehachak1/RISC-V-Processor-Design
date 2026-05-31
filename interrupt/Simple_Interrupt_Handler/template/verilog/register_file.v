module register_file (
    input  wire        clk_i,
    input  wire [ 4:0] aa_i,
    input  wire [ 4:0] ab_i,
    input  wire [ 4:0] aw_i,
    input  wire        wren_i,
    input  wire [31:0] wrdata_i,
    output reg [31:0] a_o,
    output reg [31:0] b_o
);
  /////////////////////
  // Internal Registers
  /////////////////////
  //! Do not rename the reg_array_r signal
  //! Use it to store the register file contents
  reg [31:0] reg_array_r[32];

  /*assign a_o = reg_array_r[aa_i];
  assign b_o = reg_array_r[ab_i];*/

  always @(*) begin
    a_o = 0;
    b_o = 0;

    a_o = aa_i == 0 ? 0 : reg_array_r[aa_i];
    b_o = ab_i == 0 ? 0 : reg_array_r[ab_i];
  end

  always @(posedge clk_i) begin
    if (wren_i) begin
      reg_array_r[aw_i] <= wrdata_i;
    end
  end

endmodule
