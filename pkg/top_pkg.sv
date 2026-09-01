package top_pkg;

  typedef enum bit {
    BRUTE_FORCE   = 1'b0,
    DOUBLE_DABBLE = 1'b1
  } bin2bcd_t;

  parameter bin2bcd_t BIN2BCD_TYPE = DOUBLE_DABBLE;
endpackage
