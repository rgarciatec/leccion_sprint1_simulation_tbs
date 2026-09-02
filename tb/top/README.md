# Top-level testbench and simulation flow

AI usage disclaimer: This README was created or assisted using AI tooling. It was reviewed and adjusted to reflect the actual RTL and post-fit simulation flow used in this project.

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

## RTL simulation workflow

From this directory:

```bash
make run
```

This does the usual flow:

```bash
vlib work
vlog -sv ...
vsim -c work.top_tb -do "run -all; quit"
```

For interactive debugging:

```bash
make debug
```

or

```bash
make run_debug
```

These targets create a GUI session and log the relevant signal hierarchy.

## Quartus / GLS flow

This folder also supports a post-fit simulation flow. This part is intentionally separate from the standard RTL simulation because it loads the generated FPGA netlist produced by Quartus.

Follow this sequence:

1. Build the Quartus project in the parent `quartus/` folder
2. Run the post-fit flow from this directory

Example:

```bash
cd ../../quartus
make all
cd ../tb/top
make gls
```

The `gls` target performs the post-fit flow:

- compile Intel FPGA simulation libraries
- locate the generated netlist `top.svo`
- compile the netlist into the Questa work library
- look for a real delay file (`.sdo` or `.sdf`)
- apply it with `-sdftyp` if it exists
- otherwise run the post-fit netlist without SDF

This behavior is intentionally defensive. It avoids failing on Quartus metadata files such as `.sft`, which are not real timing files.

## Important note about SDF files

The generated Quartus output folder may contain files such as:

- `top.svo`
- `top.sft`

But `top.sft` is not a valid delay file for `vsim -sdftyp`. It is a Quartus settings/metadata file.

The actual delay file must be a real SDF/SDO file, if Quartus generated one for your flow.

## Common targets

```bash
make run        # batch RTL simulation
make debug      # GUI RTL debug
make run_debug  # GUI RTL debug + auto run
make gls        # post-fit / GLS run when Quartus outputs exist
make gui_gls    # GUI GLS session
make clean      # remove work library and generated logs
```

## Why this is a separate flow

Plain RTL simulation checks your source logic in isolation.
GLS checks the actual post-fit FPGA implementation, including primitive mapping and timing annotation.

This is why the Makefile has two different paths.

## References and source material

This document reflects the actual implementation and validation files used by the project, including:

- [../../quartus/top.qsf](../../quartus/top.qsf) : Quartus project configuration and testbench assignments
- [../../quartus/top.sdc](../../quartus/top.sdc) : SDC timing constraints
- [../../top/top.sv](../../top/top.sv) : integrated design under test
- [../../tb/top/top_tb.sv](../../tb/top/top_tb.sv) : full-system verification testbench
- [../../tb/bcd2seven_seg/bcd2seven_seg_tb.sv](../../tb/bcd2seven_seg/bcd2seven_seg_tb.sv) : block-level 7-segment decoder testbench
- [../../tb/bin2bcd/bin2bcd_dual_tb.sv](../../tb/bin2bcd/bin2bcd_dual_tb.sv) : decoder comparison testbench
- [../../tb/top/Makefile](../../tb/top/Makefile) : RTL and GLS target flow

## Repo hygiene

Generated artifacts such as:

- `work/`
- `transcript.log`
- `*.wlf`

are local simulation outputs and should not be committed to the repository.
