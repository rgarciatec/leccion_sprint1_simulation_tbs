package bin2bcd_pkg;
    parameter int BITS_PER_DIGIT = 4;
    parameter int ADD3_THRESHOLD = 4;
    parameter int ADD3_VALUE     = 3;

    typedef enum logic [7:0] {
        VAL_100  = 8'd100,
        VAL_90   = 8'd90,
        VAL_80   = 8'd80,
        VAL_70   = 8'd70,
        VAL_60   = 8'd60,
        VAL_50   = 8'd50,
        VAL_40   = 8'd40,
        VAL_30   = 8'd30,
        VAL_20   = 8'd20,
        VAL_10   = 8'd10
    } sub_t;

    typedef enum int {
        RANGE_90 = 9,
        RANGE_80 = 8,
        RANGE_70 = 7,
        RANGE_60 = 6,
        RANGE_50 = 5,
        RANGE_40 = 4,
        RANGE_30 = 3,
        RANGE_20 = 2,
        RANGE_10 = 1,
        RANGE_00 = 0
    } range_t;
endpackage
