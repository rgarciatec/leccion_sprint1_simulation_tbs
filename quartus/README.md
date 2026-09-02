# Quartus project

> AI usage disclaimer: this README was created or assisted using AI tooling and then reviewed against the actual project files.

This folder contains the Quartus Prime project for the Cyclone V target device used in this laboratory.

The project is configured for:

- Family: Cyclone V
- Device: 5CGXFC5C6F27C7
- Board: Terasic Cyclone V development board
- Reference: https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&CategoryNo=165&No=830

## Files

- `top.qsf` : Quartus settings and pin assignments
- `top.qpf` : project file
- `top.sdc` : timing constraints
- `Makefile` : build and programming flow
- `output_files/` : generated synthesis and fit outputs
- `db/`, `incremental_db/` : local Quartus database files
- `simulation/` : generated simulation outputs

## Common commands

From this folder:

```bash
make all
make programmer
make clean
```

What they do:

- `make all` : run the Quartus flow (`map`, `fit`, `asm`, `sta`, `eda`)
- `make programmer` : launch the programmer for the selected device
- `make clean` : removes the most obvious generated outputs, but keeps the project structure intact

## Build flow

The Quartus workflow is intentionally separated into stages:

1. `quartus_map`
2. `quartus_fit`
3. `quartus_asm`
4. `quartus_sta`
5. `quartus_eda`

This is the right flow for generating the post-fit netlist and timing artifacts used in a GLS simulation.

## Important device note

This project is not generic. It targets the specific Cyclone V FPGA device configured in `top.qsf`.

If you move the design to another board or to a different FPGA family, you must update:

- the device line in `top.qsf`
- the pin assignments
- the SDC constraints
- any board-specific I/O assumptions

## Repo hygiene

Generated Quartus outputs are local build artifacts and should not be committed to the repository. Keep only the source and configuration files tracked in git.
