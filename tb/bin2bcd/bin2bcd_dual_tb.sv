`timescale 1ns/1ps

module bin2bcd_dual_tb;
    import bin2bcd_pkg::*;

    localparam int BIN_WIDTH  = 8;
    localparam int NUM_DIGITS = 3;
    localparam int BCD_WIDTH  = NUM_DIGITS * BITS_PER_DIGIT;
    localparam int MAX_VAL    = (2 ** BIN_WIDTH) - 1;

    // This is a functional simulation delay only. The real timing comes from the
    // .sdc constraint used during synthesis/STA, not from the simulator itself.
    // We keep it below the 20 ns max-delay budget from the SDC so the testbench
    // checks the outputs after the combinational logic has settled.
    localparam time COMB_SETTLE = 5ns;

    logic [BIN_WIDTH-1:0] bin_in;
    logic [BCD_WIDTH-1:0] bcd_brute_force;
    logic [BCD_WIDTH-1:0] bcd_double_dabble;

    int pass_count;
    int fail_count;

    bin2bcd_decoder_brute_force #(
        .BIN_WIDTH  (BIN_WIDTH),
        .NUM_DIGITS (NUM_DIGITS)
    ) u_brute_force (
        .bin_in  (bin_in),
        .bcd_out (bcd_brute_force)
    );

    bin2bcd_decoder_double_dabble #(
        .BIN_WIDTH  (BIN_WIDTH),
        .NUM_DIGITS (NUM_DIGITS)
    ) u_double_dabble (
        .bin_in  (bin_in),
        .bcd_out (bcd_double_dabble)
    );

    function automatic logic [BCD_WIDTH-1:0] expected_bcd(input logic [BIN_WIDTH-1:0] value);
        int value_int;
        int hundreds;
        int tens;
        int ones;
        logic [BCD_WIDTH-1:0] bcd;
        
        value_int = value;
        hundreds  = value_int / 100;
        tens      = (value_int % 100) / 10;
        ones      = value_int % 10;
        bcd       = {4'(hundreds), 4'(tens), 4'(ones)};
        return bcd;

    endfunction

    task automatic check_case(input logic [BIN_WIDTH-1:0] value);
        logic [BCD_WIDTH-1:0] expected;
        int value_int;

        value_int = value;
        bin_in = value;
        #COMB_SETTLE;

        expected = expected_bcd(value);

        if ((bcd_brute_force !== expected) || (bcd_double_dabble !== expected)) begin
            $display("FAIL: value=%0d brute=%0h dd=%0h expected=%0h", value_int, bcd_brute_force, bcd_double_dabble, expected);
            fail_count++;
        end 
        else begin
            pass_count++;
        end
    endtask

    initial begin
        $timeformat(-9, 3, " ns", 6);
        pass_count = 0;
        fail_count = 0;

        for (int i = 0; i <= MAX_VAL; i++) begin
            check_case(i[BIN_WIDTH-1:0]);
        end

        $display("----------------------------------------");
        $display("PASS: %0d  FAIL: %0d  TOTAL: %0d", pass_count, fail_count, pass_count + fail_count);
        $display("----------------------------------------");
        $finish;
    end
endmodule
