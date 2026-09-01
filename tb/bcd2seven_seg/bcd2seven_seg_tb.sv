`timescale 1ns/1ps

module bcd2seven_seg_tb;
    import bcd2seven_seg_pkg::*;

    logic [3:0] bcd_in;
    seven_seg_value_t seven_seg_out;

    bcd2seven_seg_decoder u_dut (
        .bcd_in(bcd_in),
        .seven_seg_out(seven_seg_out)
    );

    function automatic seven_seg_value_t expected_value(input logic [3:0] value);
        case (value)
            4'h0: return ZERO_SEVEN_SEG;
            4'h1: return ONE_SEVEN_SEG;
            4'h2: return TWO_SEVEN_SEG;
            4'h3: return THREE_SEVEN_SEG;
            4'h4: return FOUR_SEVEN_SEG;
            4'h5: return FIVE_SEVEN_SEG;
            4'h6: return SIX_SEVEN_SEG;
            4'h7: return SEVEN_SEVEN_SEG;
            4'h8: return EIGHT_SEVEN_SEG;
            4'h9: return NINE_SEVEN_SEG;
            default: return ERROR_SEVEN_SEG;
        endcase
    endfunction

    initial begin
        $timeformat(-9, 3, " ns", 6);

        for (int i = 0; i < 16; i++) begin
            bcd_in = i[3:0];
            #1ns;

            if (seven_seg_out !== expected_value(bcd_in)) begin
                $display("FAIL: bcd=%0d got=%07b expected=%07b", bcd_in, seven_seg_out, expected_value(bcd_in));
                $fatal(1, "bcd2seven_seg_tb failed");
            end 
            else begin
                $display("PASS: bcd=%0d -> %07b", bcd_in, seven_seg_out);
            end
        end

        $display("All bcd2seven_seg_tb checks passed.");
        $finish;
    end
endmodule
