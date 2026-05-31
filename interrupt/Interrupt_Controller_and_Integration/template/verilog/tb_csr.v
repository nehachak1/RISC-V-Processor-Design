`timescale 1ns/1ps

module tb_csr;
    // Signals for the DUT (Device Under Test)
    reg clk_i, rst_ni;
    reg [11:0] addr_i;
    reg [31:0] wdata_i, pc_i;
    reg write_i, set_i, clear_i, interrupt_i, mret_i, irq_i;
    wire [31:0] rdata_o, mtvec_o, mepc_o;
    wire ipending_o;

    // Instantiate the CSR Controller
    csr dut (
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        .addr_i(addr_i),
        .wdata_i(wdata_i),
        .irq_i(irq_i),
        .pc_i(pc_i),
        .write_i(write_i),
        .set_i(set_i),
        .clear_i(clear_i),
        .interrupt_i(interrupt_i),
        .mret_i(mret_i),
        .rdata_o(rdata_o),
        .mtvec_o(mtvec_o),
        .mepc_o(mepc_o),
        .ipending_o(ipending_o)
    );

    // Clock generation
    always begin
        #5 clk_i = ~clk_i; // 10ns clock period
    end

    // Testbench logic
    initial begin
        // Initialize signals
        clk_i = 0;
        addr_i = 0;
        wdata_i = 0;
        write_i = 0;
        set_i = 0;
        clear_i = 0;
        interrupt_i = 0;
        mret_i = 0;
        irq_i = 0;
        rst_ni = 0;

        // Reset the CSR Controller
        #10 rst_ni = 1;

        // Test cases



        // Test completed
        $display("All tests completed.");
        $finish;
    end
endmodule
