module bcd2seven_seg_decoder import bcd2seven_seg_pkg::*; (
    input logic [3:0] bcd_in,
    output seven_seg_value_t seven_seg_out
);

    always_comb begin

        case(bcd_in)

            4'h0: begin
                seven_seg_out = ZERO_SEVEN_SEG;
            end

            4'h1: begin
                seven_seg_out = ONE_SEVEN_SEG;
            end

            4'h2: begin
                seven_seg_out = TWO_SEVEN_SEG;
            end

            4'h3: begin
                seven_seg_out = THREE_SEVEN_SEG;
            end

            4'h4: begin
                seven_seg_out = FOUR_SEVEN_SEG;
            end

            4'h5: begin
                seven_seg_out = FIVE_SEVEN_SEG;
            end

            4'h6: begin
                seven_seg_out = SIX_SEVEN_SEG;
            end

            4'h7: begin
                seven_seg_out = SEVEN_SEVEN_SEG;
            end

            4'h8: begin
                seven_seg_out = EIGHT_SEVEN_SEG;
            end

            4'h9: begin
                seven_seg_out = NINE_SEVEN_SEG;
            end

            default : begin
                seven_seg_out = ERROR_SEVEN_SEG;
            end

        endcase
    end


endmodule
