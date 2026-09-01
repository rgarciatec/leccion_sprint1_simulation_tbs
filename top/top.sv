module top(

    //////////// leds //////////
    output logic     [7:0]        ledg,
    output logic     [9:0]        ledr,

    //////////// sw //////////
    input logic      [9:0]         sw,

    //////////// hex0 //////////
    output logic     [6:0]     hex0,

    //////////// hex1 //////////
    output logic     [6:0]     hex1,

    //////////// hex2 //////////
    output logic     [6:0]     hex2,

    //////////// hex3 //////////
    output logic     [6:0]     hex3
);
    import top_pkg::*;

    logic [15:0] bcd_data;

    // Map binary input to green LEDs (truncated to 8 bits to match ledg width)
    assign ledg = sw[7:0];

    // Map BCD output to red LEDs (truncated to 10 bits to match ledr width)
    assign ledr = bcd_data[9:0];

    // Core decoder instantiation
    generate
        case(BIN2BCD_TYPE)
           BRUTE_FORCE: begin : brute_force_inst
                bin2bcd_decoder_brute_force #(
                    .BIN_WIDTH(10),
                    .NUM_DIGITS(4)
                ) u_bin2bcd (
                    .bin_in(sw),
                    .bcd_out(bcd_data)
                );
           end
           DOUBLE_DABBLE: begin : double_dabble_inst
                bin2bcd_decoder_double_dabble #(
                    .BIN_WIDTH(10),
                    .NUM_DIGITS(4)
                ) u_bin2bcd (
                    .bin_in(sw),
                    .bcd_out(bcd_data)
                );
           end
        endcase
    endgenerate
    // 7-segment display instantiations
    bcd2seven_seg_decoder u_hex0 (
        .bcd_in(bcd_data[3:0]),
        .seven_seg_out(hex0)
    );

    bcd2seven_seg_decoder u_hex1 (
        .bcd_in(bcd_data[7:4]),
        .seven_seg_out(hex1)
    );

    bcd2seven_seg_decoder u_hex2 (
        .bcd_in(bcd_data[11:8]),
        .seven_seg_out(hex2)
    );

    bcd2seven_seg_decoder u_hex3 (
        .bcd_in(bcd_data[15:12]),
        .seven_seg_out(hex3)
    );


endmodule
