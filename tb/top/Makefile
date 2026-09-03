TB_NAME ?= top_tb

# RTL simulation sources
SRC_FILES += ../../pkg/top_pkg.sv
SRC_FILES += ../../blocks/bcd2seven_seg/bcd2seven_seg_pkg.sv
SRC_FILES += ../../blocks/bcd2seven_seg/bcd2seven_seg_decoder.sv
SRC_FILES += ../../blocks/bin2bcd/bin2bcd_pkg.sv
SRC_FILES += ../../blocks/bin2bcd/bin2bcd_decoder_brute_force.sv
SRC_FILES += ../../blocks/bin2bcd/bin2bcd_decoder_double_dabble.sv
SRC_FILES += ../../top/top.sv
SRC_FILES += $(TB_NAME).sv

LOG_FILE := transcript.log
WLF_FILE := $(TB_NAME).wlf
DEBUG_NAME := $(TB_NAME)_dbg
DEBUG_DB := $(TB_NAME).dbg
GLS_DEBUG_DB := $(TB_NAME)_gls.dbg

# Quartus post-fit netlist / delay files
QUARTUS_ROOTDIR ?= /home/rongar01/intelFPGA_lite/24.1std/quartus
QUARTUS_SIM_LIB = $(QUARTUS_ROOTDIR)/eda/sim_lib
QUARTUS_LIBS = altera_primitives.v 220model.v sgate.v altera_mf.v altera_lnsim.sv cyclonev_atoms.v
POSTFIT_DIRS = ../../quartus/simulation/questa ../../quartus/simulation ../../quartus
POSTFIT_BASENAME = top
SDF_TARGET = /$(TB_NAME)/u_dut
GLS_TB_SRC_FILES = ../../pkg/top_pkg.sv $(TB_NAME).sv

.PHONY: rtl run debug run_debug compile compile_quartus_libs compile_postfit simulate_postfit gui_postfit clean

compile:
	vlib work
	vlog -sv $(SRC_FILES) -l $(LOG_FILE)

rtl: compile
	vsim -c work.$(TB_NAME) -l $(LOG_FILE) -do "run -all; quit"

run: rtl

debug: compile
	vopt +acc=npr -debugdb work.$(TB_NAME) -o $(DEBUG_NAME)
	vsim -gui -debugdb=$(DEBUG_DB) -postsimdataflow -wlf $(WLF_FILE) $(DEBUG_NAME) -l $(LOG_FILE) -do "log -r /$(TB_NAME)/*; add wave -r /$(TB_NAME)/*"

run_debug: compile
	vopt +acc=npr -debugdb work.$(TB_NAME) -o $(DEBUG_NAME)
	vsim -gui -debugdb=$(DEBUG_DB) -postsimdataflow -wlf $(WLF_FILE) $(DEBUG_NAME) -l $(LOG_FILE) -do "log -r /$(TB_NAME)/*; add wave -r /$(TB_NAME)/*; run -all"

# Quartus/Intel library compilation for GLS
compile_quartus_libs:
	@if [ ! -d "$(QUARTUS_SIM_LIB)" ]; then \
		echo "ERROR: Quartus sim lib not found: $(QUARTUS_SIM_LIB)"; \
		echo "Check QUARTUS_ROOTDIR or your Intel Quartus install."; \
		exit 1; \
	fi
	vlib work
	vlog -work work $(addprefix $(QUARTUS_SIM_LIB)/,$(QUARTUS_LIBS)) -l $(LOG_FILE)

# Compile post-fit netlist if present
compile_postfit: compile_quartus_libs
	@NETLIST=""; \
	for d in $(POSTFIT_DIRS); do \
		if [ -f $$d/$(POSTFIT_BASENAME).svo ]; then NETLIST=$$d/$(POSTFIT_BASENAME).svo; break; fi; \
	done; \
	if [ "$$NETLIST" != "" ]; then \
		echo "Found post-fit netlist: $$NETLIST"; \
		vlog -sv -work work $$NETLIST; \
	else \
		echo "Warning: post-fit netlist not found in $(POSTFIT_DIRS); RTL simulation only."; \
	fi

# Run GLS if a real timing delay file exists
simulate_postfit: compile_postfit
	@echo "Compiling testbench for post-fit timing simulation..."
	vlog -sv -work work $(GLS_TB_SRC_FILES) -l $(LOG_FILE)
	vopt work.$(TB_NAME) -o $(TB_NAME)_gls
	@SDO=""; \
	for d in $(POSTFIT_DIRS); do \
		if [ -f $$d/$(POSTFIT_BASENAME)_v.sdo ]; then SDO=$$d/$(POSTFIT_BASENAME)_v.sdo; break; fi; \
		if [ -f $$d/$(POSTFIT_BASENAME).sdo ]; then SDO=$$d/$(POSTFIT_BASENAME).sdo; break; fi; \
		if [ -f $$d/$(POSTFIT_BASENAME)_v.sdf ]; then SDO=$$d/$(POSTFIT_BASENAME)_v.sdf; break; fi; \
		if [ -f $$d/$(POSTFIT_BASENAME).sdf ]; then SDO=$$d/$(POSTFIT_BASENAME).sdf; break; fi; \
	done; \
	if [ "$$SDO" != "" ]; then \
		echo "Found delay file: $$SDO"; \
		vsim -L work -sdftyp $(SDF_TARGET)=$$SDO $(TB_NAME)_gls -c -do "run -all; quit" -l $(LOG_FILE) -appendlog; \
	else \
		echo "Warning: no real SDF/SDO delay file found; running post-fit netlist without SDF"; \
		vsim -c $(TB_NAME)_gls -do "run -all; quit" -l $(LOG_FILE) -appendlog; \
	fi

gls: simulate_postfit

# GUI version with optional SDF if available
gui_postfit: compile_postfit
	@echo "Building debug image for GUI..."
	vlog -sv -work work $(GLS_TB_SRC_FILES) -l $(LOG_FILE)
	vopt +acc=npr -debugdb work.$(TB_NAME) -o $(TB_NAME)_dbg_gls
	@SDO=""; \
	for d in $(POSTFIT_DIRS); do \
		if [ -f $$d/$(POSTFIT_BASENAME)_v.sdo ]; then SDO=$$d/$(POSTFIT_BASENAME)_v.sdo; break; fi; \
		if [ -f $$d/$(POSTFIT_BASENAME).sdo ]; then SDO=$$d/$(POSTFIT_BASENAME).sdo; break; fi; \
		if [ -f $$d/$(POSTFIT_BASENAME)_v.sdf ]; then SDO=$$d/$(POSTFIT_BASENAME)_v.sdf; break; fi; \
		if [ -f $$d/$(POSTFIT_BASENAME).sdf ]; then SDO=$$d/$(POSTFIT_BASENAME).sdf; break; fi; \
	done; \
	if [ "$$SDO" != "" ]; then \
		echo "Launching Questa GUI with SDF: $$SDO"; \
		vsim -gui -debugdb=$(GLS_DEBUG_DB) -postsimdataflow $(TB_NAME)_dbg_gls -wlf $(WLF_FILE) -sdftyp $(SDF_TARGET)=$$SDO -do "log -r /*; add wave -r /*"; \
	else \
		echo "Launching Questa GUI without SDF"; \
		vsim -gui -debugdb=$(GLS_DEBUG_DB) -postsimdataflow $(TB_NAME)_dbg_gls -wlf $(WLF_FILE) -do "log -r /*; add wave -r /*"; \
	fi

gui_gls: gui_postfit

clean:
	rm -rf work
	rm -f $(WLF_FILE) $(LOG_FILE) $(DEBUG_DB) $(GLS_DEBUG_DB)
