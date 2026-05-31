
module csr (
    input  wire        clk_i,
    input  wire        rst_ni,
    input  wire [11:0] addr_i,
    input  wire [31:0] wdata_i,
    input  wire        irq_i,
    input  wire [31:0] pc_i,
    input  wire        write_i,
    input  wire        set_i,
    input  wire        clear_i,
    input  wire        interrupt_i,
    input  wire        mret_i,
    output reg  [31:0] rdata_o,
    output wire [31:0] mtvec_o,
    output wire [31:0] mepc_o,
    output reg         ipending_o
);

  //! Don't change the following definition.
  //! Should be used for storing the CSR registers values as
  //! described in the assignment.
  reg [31:0] mstatus_r, mie_r, mtvec_r, mepc_r, mcause_r, mip_r;

  //CSR registers adresses
  localparam MSTATUS_ADDR = 12'h300;
  localparam MIE_ADDR     = 12'h304;
  localparam MTVEC_ADDR   = 12'h305;
  localparam MEPC_ADDR    = 12'h341;
  localparam MCAUSE_ADDR  = 12'h342;
  localparam MIP_ADDR     = 12'h344;

  //unused bits masks
  localparam [31:0] MSTATUS_MASK = 32'h0000_1888;
  localparam [31:0] MIE_MASK   = 32'h0000_0800;
  localparam [31:0] MCAUSE_MASK = 32'h8000_0800;
  localparam [31:0] MIP_MASK   = 32'h0000_0800;

  assign mepc_o  = mepc_r;
  assign mtvec_o = mtvec_r;

always @(posedge clk_i) begin
  if (!rst_ni) begin
    //reset all registers to default value
    mstatus_r <= 32'h1800;
    mie_r <= 0;
    mtvec_r <= 0;
    mepc_r <= 0;
    mcause_r <= 0;
    mip_r <= 0;

  end if (interrupt_i) begin
  //Interrupt currently being processed
    mepc_r <= pc_i;
    mcause_r[31] <= 1;
    mcause_r[11] <= 1;
    mstatus_r[7] <= mstatus_r[3];
    mstatus_r[3] <= 0;

  end else if (mret_i) begin
  //Machine Return
    mstatus_r[3] <= mstatus_r[7];

  end else if (irq_i) begin
  //Interrupt Request pending
    mip_r[11] <= 1;

  end else if ((write_i + set_i + clear_i) == 1) begin
    if (write_i) begin
    //WRITE
      case (addr_i)
        MSTATUS_ADDR: mstatus_r <= wdata_i & MSTATUS_MASK;
        MIE_ADDR    : mie_r     <= wdata_i & MIE_MASK;
        MTVEC_ADDR  : mtvec_r   <= wdata_i;
        MEPC_ADDR   : mepc_r    <= wdata_i;
        MCAUSE_ADDR : mcause_r  <= wdata_i & MCAUSE_MASK;
        MIP_ADDR    : mip_r     <= wdata_i & MIP_MASK;
        default     : ;
      endcase

    end else if (set_i) begin
    //SET
      case (addr_i)
      MSTATUS_ADDR: mstatus_r <= (mstatus_r | wdata_i) & MSTATUS_MASK;
      MIE_ADDR    : mie_r     <= (mie_r     | wdata_i) & MIE_MASK;
      MTVEC_ADDR  : mtvec_r   <= (mtvec_r   | wdata_i);
      MEPC_ADDR   : mepc_r    <= (mepc_r    | wdata_i);
      MCAUSE_ADDR : mcause_r  <= (mcause_r  | wdata_i) & MCAUSE_MASK;
      MIP_ADDR    : mip_r     <= (mip_r     | wdata_i) & MIP_MASK;
      default     : ;
      endcase

    end else if (clear_i) begin
    //CLEAR
      case (addr_i)
      MSTATUS_ADDR: mstatus_r <= (mstatus_r & ~wdata_i) & MSTATUS_MASK;
      MIE_ADDR    : mie_r     <= (mie_r     & ~wdata_i) & MIE_MASK;
      MTVEC_ADDR  : mtvec_r   <= (mtvec_r   & ~wdata_i);
      MEPC_ADDR   : mepc_r    <= (mepc_r    & ~wdata_i);
      MCAUSE_ADDR : mcause_r  <= (mcause_r  & ~wdata_i) & MCAUSE_MASK;
      MIP_ADDR    : mip_r     <= (mip_r     & ~wdata_i) & MIP_MASK;
      default     : ;
      endcase
    end
  end

  //Updating ipending
  ipending_o <= mstatus_r[3] & mie_r[11] & mip_r[11];
end

always @(*) begin
  rdata_o = 0;

  //Asynchronous read
  case (addr_i)
    MSTATUS_ADDR: rdata_o = mstatus_r;
    MIE_ADDR    : rdata_o = mie_r;
    MTVEC_ADDR  : rdata_o = mtvec_r;
    MEPC_ADDR   : rdata_o = mepc_r;
    MCAUSE_ADDR : rdata_o = mcause_r;
    MIP_ADDR    : rdata_o = mip_r;
    default     : rdata_o = 0;
  endcase
end

endmodule
