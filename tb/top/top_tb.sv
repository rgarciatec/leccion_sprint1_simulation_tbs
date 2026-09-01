`timescale 1ns/1ps

module top_tb;
    import top_pkg::*;

    localparam int SW_WIDTH = 10;
    localparam int LEDG_WIDTH = 8;
    localparam int LEDR_WIDTH = 10;
    localparam int HEX_WIDTH = 7;
    localparam time COMB_SETTLE = 1ns;

    logic [SW_WIDTH-1:0] sw;
    logic [LEDG_WIDTH-1:0] ledg;
    logic [LEDR_WIDTH-1:0] ledr;
    logic [HEX_WIDTH-1:0] hex0;
    logic [HEX_WIDTH-1:0] hex1;
    logic [HEX_WIDTH-1:0] hex2;
    logic [HEX_WIDTH-1:0] hex3;

    top u_dut (
        .sw(sw),
        .ledg(ledg),
        .ledr(ledr),
        .hex0(hex0),
        .hex1(hex1),
        .hex2(hex2),
        .hex3(hex3)
    );

    function automatic logic [15:0] expected_bcd(input logic [SW_WIDTH-1:0] value);
        int value_int;
        int thousands;
        int hundreds;
        int tens;
        int ones;
        logic [15:0] bcd;

        value_int = value;
        thousands = value_int / 1000;
        hundreds  = (value_int % 1000) / 100;
        tens      = (value_int % 100) / 10;
        ones      = value_int % 10;

        bcd = {4'(thousands), 4'(hundreds), 4'(tens), 4'(ones)};
        return bcd;
    endfunction

    function automatic logic [HEX_WIDTH-1:0] expected_hex(input logic [3:0] bcd_digit);
        case (bcd_digit)
            4'h0: return 7'b1000000;
            4'h1: return 7'b1111001;
            4'h2: return 7'b0100100;
            4'h3: return 7'b0110000;
            4'h4: return 7'b0011001;
            4'h5: return 7'b0010010;
            4'h6: return 7'b0000010;
            4'h7: return 7'b1111000;
            4'h8: return 7'b0000000;
            4'h9: return 7'b0010000;
            default: return 7'b0001110;
        endcase
    endfunction

    initial begin
        $timeformat(-9, 3, " ns", 6);

        for (int i = 0; i < (2 ** SW_WIDTH); i++) begin
            sw = i[SW_WIDTH-1:0];
            #COMB_SETTLE;

            if (ledg !== sw[7:0]) begin
                $display("FAIL: sw=%0d ledg=%0b expected=%0b", i, ledg, sw[7:0]);
                $fatal(1, "ledg mismatch");
            end

            if (ledr !== expected_bcd(sw)[9:0]) begin
                $display("FAIL: sw=%0d ledr=%0b expected=%0b", i, ledr, expected_bcd(sw)[9:0]);
                $fatal(1, "ledr mismatch");
            end

            if (hex0 !== expected_hex(expected_bcd(sw)[3:0])) begin
                $display("FAIL: sw=%0d hex0=%07b expected=%07b", i, hex0, expected_hex(expected_bcd(sw)[3:0]));
                $fatal(1, "hex0 mismatch");
            end

            if (hex1 !== expected_hex(expected_bcd(sw)[7:4])) begin
                $display("FAIL: sw=%0d hex1=%07b expected=%07b", i, hex1, expected_hex(expected_bcd(sw)[7:4]));
                $fatal(1, "hex1 mismatch");
            end

            if (hex2 !== expected_hex(expected_bcd(sw)[11:8])) begin
                $display("FAIL: sw=%0d hex2=%07b expected=%07b", i, hex2, expected_hex(expected_bcd(sw)[11:8]));
                $fatal(1, "hex2 mismatch");
            end

            if (hex3 !== expected_hex(expected_bcd(sw)[15:12])) begin
                $display("FAIL: sw=%0d hex3=%07b expected=%07b", i, hex3, expected_hex(expected_bcd(sw)[15:12]));
                $fatal(1, "hex3 mismatch");
            end

            $display("PASS: sw=%0d -> ledg=%0b ledr=%0b hex=[%07b %07b %07b %07b]", i, ledg, ledr, hex3, hex2, hex1, hex0);
        end

        $display("All top_tb checks passed.");
        $finish;
    end
endmodule
