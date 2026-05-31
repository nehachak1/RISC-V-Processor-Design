`timescale 1ns / 1ps

module tb_logic_unit ();
    // Inputs
    reg [31:0] a_i, b_i;
    reg [2:0]  op_i;

    // Outputs
    wire [31:0] r_o;

    // Instantiate the Unit Under Test (UUT)
    logic_unit uut (
        .a_i  (a_i),
        .b_i  (b_i),
        .op_i (op_i),
        .r_o  (r_o)
    );

    // Operation codes (matching the logic_unit module)
    localparam XOR = 3'b100;
    localparam OR  = 3'b110;
    localparam AND = 3'b111;

    initial begin
        // Generate waveform file
        $dumpfile("dump/tb_logic_unit.vcd");
        $dumpvars(0, tb_logic_unit);
        a_i = 4'b1100;
        b_i = 4'b1010;

        // Test XOR operation
        op_i = XOR;
        #20;  // wait for circuit to settle
        if (r_o == 4'b0110) begin
            $display("Success");
        end else begin
            $display("Error, %d | %d = %d", a_i, b_i, r_o);
        end

        // Test OR operation
        op_i = OR;
        #20;  // wait for circuit to settle
        if (r_o == 4'b1110) begin
            $display("Success");
        end else begin
            $display("Error, %d | %d = %d", a_i, b_i, r_o);
        end

        // Test AND operation
        op_i = AND;
        #20;  // wait for circuit to settle
        if (r_o == 4'b1000) begin
            $display("Success");
        end else begin
            $display("Error, %d | %d = %d", a_i, b_i, r_o);
        end

        // Test undefined operation (should default to all zeros)
        op_i = 3'b011;
        #20;  // wait for circuit to settle
        if (r_o == 4'b0000) begin
            $display("Success");
        end else begin
            $display("Error, %d | %d = %d", a_i, b_i, r_o);
        end

        // Finish simulation
        $finish;
    end
endmodule