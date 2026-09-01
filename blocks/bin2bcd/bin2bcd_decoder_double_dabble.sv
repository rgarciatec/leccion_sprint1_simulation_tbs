// bin2bcd decoder using double dabble
// https://en.wikipedia.org/wiki/Double_dabble
//Note that: Shift left = multiply by 2
//1-  Add 3 before shift = add 6 after shift (carried through the doubling)
//2-  6 is the gap between binary carry (16) and BCD carry (10)

module bin2bcd_decoder_double_dabble import bin2bcd_pkg::*; #(
    parameter int BIN_WIDTH  = 8,
    parameter int NUM_DIGITS = 3
)(
    input  logic [BIN_WIDTH-1:0]                     bin_in,
    output logic [(NUM_DIGITS * BITS_PER_DIGIT)-1:0] bcd_out
);

    localparam int BCD_WIDTH = (NUM_DIGITS * BITS_PER_DIGIT);
    logic [BCD_WIDTH-1:0] bcd_current;
    logic [BCD_WIDTH-1:0] bcd_next; //
    always_comb begin
        bcd_current = '0; // set default value
        for (int shift = 0; shift < BIN_WIDTH; shift++) begin
            bcd_next = bcd_current;
            for (int digit = 0; digit < NUM_DIGITS; digit++) begin
                if (bcd_next[(digit*BITS_PER_DIGIT) +: BITS_PER_DIGIT] > ADD3_THRESHOLD) begin
                    bcd_next[(digit*BITS_PER_DIGIT) +: BITS_PER_DIGIT] = bcd_next[(digit*BITS_PER_DIGIT) +: BITS_PER_DIGIT] + BCD_WIDTH'(ADD3_VALUE);
                end
            end
            bcd_current = {bcd_next[BCD_WIDTH-2:0], bin_in[BIN_WIDTH-1-shift]};
        end
        bcd_out = bcd_current;
    end
endmodule
