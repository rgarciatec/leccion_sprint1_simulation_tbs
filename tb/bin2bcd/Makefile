TB_NAME ?= bin2bcd_dual_tb

SRC_FILES += ../../blocks/bin2bcd/bin2bcd_pkg.sv
SRC_FILES += ../../blocks/bin2bcd/bin2bcd_decoder_brute_force.sv
SRC_FILES += ../../blocks/bin2bcd/bin2bcd_decoder_double_dabble.sv
SRC_FILES += $(TB_NAME).sv

LOG_FILE = transcript.log
WLF_FILE = $(TB_NAME).wlf
DEBUG_NAME = $(TB_NAME)_dbg

.PHONY: run debug run_debug compile clean

run: compile
	vsim -c work.$(TB_NAME) -l $(LOG_FILE) -do "run -all; quit"

debug: compile
	vopt +acc=npr work.$(TB_NAME) -o $(DEBUG_NAME)
	vsim -gui -wlf $(WLF_FILE) $(DEBUG_NAME) -l $(LOG_FILE) -do "log -r /$(TB_NAME)/*; add wave -r /$(TB_NAME)/*"

run_debug: compile
	vopt +acc=npr work.$(TB_NAME) -o $(DEBUG_NAME)
	vsim -gui -wlf $(WLF_FILE) $(DEBUG_NAME) -l $(LOG_FILE) -do "log -r /$(TB_NAME)/*; add wave -r /$(TB_NAME)/*; run -all"

compile:
	vlib work
	vlog -sv $(SRC_FILES) -l $(LOG_FILE)

clean:
	rm -rf work
	rm -f $(WLF_FILE) $(LOG_FILE)
