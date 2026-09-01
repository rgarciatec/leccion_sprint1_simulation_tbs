module bin2bcd_decoder_brute_force import bin2bcd_pkg::*; #(
    parameter int BIN_WIDTH  = 8,
    parameter int NUM_DIGITS = 3
) (
    input  logic [BIN_WIDTH-1:0]                     bin_in,
    output logic [(NUM_DIGITS * BITS_PER_DIGIT)-1:0] bcd_out
);

    logic [3:0]           hundreds_val;
    logic [3:0]           tens_val;
    logic [3:0]           units_val;
    logic [BIN_WIDTH-1:0] rem_100;
    logic [9:0]           in_range;

    always_comb begin

        if (bin_in >= VAL_100) begin
            hundreds_val = 4'd1;
            rem_100  = bin_in - VAL_100;
        end
        else begin
            hundreds_val = 4'd0;
            rem_100  = bin_in;
        end

        in_range[RANGE_90] = (rem_100 >= VAL_90);
        in_range[RANGE_80] = (rem_100 >= VAL_80) && (rem_100 < VAL_90);
        in_range[RANGE_70] = (rem_100 >= VAL_70) && (rem_100 < VAL_80);
        in_range[RANGE_60] = (rem_100 >= VAL_60) && (rem_100 < VAL_70);
        in_range[RANGE_50] = (rem_100 >= VAL_50) && (rem_100 < VAL_60);
        in_range[RANGE_40] = (rem_100 >= VAL_40) && (rem_100 < VAL_50);
        in_range[RANGE_30] = (rem_100 >= VAL_30) && (rem_100 < VAL_40);
        in_range[RANGE_20] = (rem_100 >= VAL_20) && (rem_100 < VAL_30);
        in_range[RANGE_10] = (rem_100 >= VAL_10) && (rem_100 < VAL_20);
        in_range[RANGE_00] = (rem_100 < VAL_10);

        unique case (1'b1)
            in_range[RANGE_90]: begin
                tens_val  = 4'(RANGE_90);
                units_val = 4'(rem_100 - VAL_90);
            end
            in_range[RANGE_80]: begin
                tens_val  = 4'(RANGE_80);
                units_val = 4'(rem_100 - VAL_80);
            end
            in_range[RANGE_70]: begin
                tens_val  = 4'(RANGE_70);
                units_val = 4'(rem_100 - VAL_70);
            end
            in_range[RANGE_60]: begin
                tens_val  = 4'(RANGE_60);
                units_val = 4'(rem_100 - VAL_60);
            end
            in_range[RANGE_50]: begin
                tens_val  = 4'(RANGE_50);
                units_val = 4'(rem_100 - VAL_50);
            end
            in_range[RANGE_40]: begin
                tens_val  = 4'(RANGE_40);
                units_val = 4'(rem_100 - VAL_40);
            end
            in_range[RANGE_30]: begin
                tens_val  = 4'(RANGE_30);
                units_val = 4'(rem_100 - VAL_30);
            end
            in_range[RANGE_20]: begin
                tens_val  = 4'(RANGE_20);
                units_val = 4'(rem_100 - VAL_20);
            end
            in_range[RANGE_10]: begin
                tens_val  = 4'(RANGE_10);
                units_val = 4'(rem_100 - VAL_10);
            end
            in_range[RANGE_00]: begin
                tens_val  = 4'(RANGE_00);
                units_val = 4'(rem_100);
            end
            default: begin
                tens_val  = 4'd0;
                units_val = 4'd0;
            end
        endcase

        bcd_out = {hundreds_val, tens_val, units_val};
    end

endmodule
