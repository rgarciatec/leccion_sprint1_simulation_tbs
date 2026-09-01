package bcd2seven_seg_pkg;
    typedef enum logic[6:0]
    {
        ZERO_SEVEN_SEG    = 7'b1_0_0_0_0_0_0,
        ONE_SEVEN_SEG     = 7'b1_1_1_1_0_0_1,
        TWO_SEVEN_SEG     = 7'b0_1_0_0_1_0_0,
        THREE_SEVEN_SEG   = 7'b0_1_1_0_0_0_0,
        FOUR_SEVEN_SEG    = 7'b0_0_1_1_0_0_1,
        FIVE_SEVEN_SEG    = 7'b0_0_1_0_0_1_0,
        SIX_SEVEN_SEG     = 7'b0_0_0_0_0_1_0,
        SEVEN_SEVEN_SEG   = 7'b1_1_1_1_0_0_0,
        EIGHT_SEVEN_SEG   = 7'b0_0_0_0_0_0_0,
        NINE_SEVEN_SEG    = 7'b0_0_1_0_0_0_0,
        ERROR_SEVEN_SEG   = 7'b0_0_0_0_1_1_0

    } seven_seg_value_t;

endpackage
