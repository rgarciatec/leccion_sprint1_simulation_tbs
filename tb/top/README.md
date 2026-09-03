# Top-Level Testbench and Simulation Flow

> AI usage disclaimer: This README was created or assisted using AI tooling. It was reviewed and adjusted to reflect the actual RTL and post-fit simulation flow used in this project.

This folder contains the validation setup for the full top-level design, not just the individual blocks.

The purpose of this testbench is to verify the integrated system:

- input switches are applied to the top module
- green LEDs reflect the low bits of the input bus
- the binary-to-BCD decoder produces the expected BCD value
- the 7-segment decoders render the correct hexadecimal patterns

## Files

- `top_tb.sv` : full-system testbench for the integrated design
- `Makefile` : RTL + Quartus GLS flow
- `transcript.log` : generated log from the simulator
- `*.wlf` : waveform file from GUI sessions

## DUT under test

The testbench instantiates the top-level module from:

- `../../top/top.sv`

The design includes:

- a `bin2bcd` decoder block
- a `bcd2seven_seg` decoder block
- top-level signal routing for `sw`, `ledg`, `ledr`, and `hex*`

## What the testbench checks

The testbench enumerates all possible switch values from `0` to `1023` and validates:

1. `ledg` matches the lower 8 bits of `sw`
2. `ledr` matches the expected BCD value for the 10-bit input
3. each 7-segment output matches the expected digit pattern

The testbench uses a short settle delay and compares against a function-based expected value model.

## Tool Setup

### Questa

Ensure `vlib`, `vlog`, and `vsim` are in your `$PATH`:

```bash
export PATH="/path/to/questa/bin:$PATH"
```

### Quartus (for GLS flows only)

The Makefile uses `QUARTUS_ROOTDIR` to locate simulation libraries for post-fit flows.

**Default (hardcoded):**
```makefile
QUARTUS_ROOTDIR ?= /home/rongar01/intelFPGA_lite/24.1std/quartus
```

Override with your installation:

```bash
# Via command line
make gls QUARTUS_ROOTDIR=/opt/intelFPGA_lite/24.1/quartus

# Via environment variable
export QUARTUS_ROOTDIR=/opt/intelFPGA_lite/24.1/quartus
make gls
```

Verify the path:
```bash
ls $QUARTUS_ROOTDIR/eda/sim_lib/cyclonev_atoms.v
```

## RTL Simulation Workflow

From this directory:

```bash
make run        # batch simulation
make debug      # GUI debug session
make run_debug  # GUI + auto-run
```

This compiles the RTL and testbench, then runs in Questa. No Quartus required.

## Post-Fit / GLS Simulation

After building Quartus:

```bash
cd ../../quartus
make all
cd ../tb/top
make gls        # post-fit simulation
make gui_gls    # GUI post-fit session
```

The `gls` target:

1. Compiles Intel FPGA simulation libraries
2. Locates the generated netlist `top.svo`
3. Compiles the netlist into Questa
4. Applies SDF delay file if available
5. Runs the testbench against the post-fit netlist

**Important:** `top.sft` is a Quartus metadata file, not a valid SDF. Real delay files are `.sdo` or `.sdf`.

## Common Targets

```bash
make run        # batch RTL simulation
make debug      # GUI RTL debug
make run_debug  # GUI RTL + auto-run
make gls        # post-fit / GLS simulation
make gui_gls    # GUI GLS session
make clean      # remove work library and logs
```

## Why Separate RTL and GLS Flows

Plain RTL simulation checks source logic. GLS checks the post-fit FPGA implementation with primitives and timing. This Makefile supports both paths independently.

## References

- [../../quartus/top.qsf](../../quartus/top.qsf) : Quartus project configuration
- [../../quartus/top.sdc](../../quartus/top.sdc) : timing constraints
- [../../top/top.sv](../../top/top.sv) : top-level design
- [../../tb/top/top_tb.sv](../../tb/top/top_tb.sv) : testbench source
- [Makefile](Makefile) : RTL and GLS simulation orchestration

