.PHONY: all gates fpga clean

all: gates fpga

GATES_LOG ?= yosys_gates.log
FPGA_LOG ?= yosys_fpga.log

# This Makefile uses a POSIX-compatible shell and tee so the Yosys output is
# visible in the terminal and saved to a log file while capturing both stdout
# and stderr.

gates: synth_gates.ys
	yosys synth_gates.ys 2>&1 | tee $(GATES_LOG)
	@echo "Yosys gate synthesis log saved to: $(GATES_LOG)"

fpga: synth_fpga.ys
	yosys synth_fpga.ys 2>&1 | tee $(FPGA_LOG)
	@echo "Yosys FPGA synthesis log saved to: $(FPGA_LOG)"

clean:
	rm -f gate_brute_force.sv
	rm -f gate_brute_force.json
	rm -f gate_brute_force.svg
	rm -f gate_brute_force.dot
	rm -f gate_double_dabble.sv
	rm -f gate_double_dabble.json
	rm -f gate_double_dabble.svg
	rm -f gate_double_dabble.dot
	rm -f fpga_brute_force.sv
	rm -f fpga_brute_force.svg
	rm -f fpga_brute_force.dot
	rm -f fpga_double_dabble.sv
	rm -f fpga_double_dabble.svg
	rm -f fpga_double_dabble.dot
	rm -f *.log