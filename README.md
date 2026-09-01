# LECCION6 Simulation TBs

This repository contains a small RTL design and simulation flow for a binary-to-BCD decoder study.

## Contents

- `blocks/bin2bcd/` : decoder implementations and shared package
- `tb/bin2bcd/` : Questa testbench and Makefile for simulation/debug
- `pkg/` : project-level package definitions
- `top/` : top-level wrapper used for integration
- `quartus/` : Quartus project constraints and settings
- `synth/` : synthesis-related flow and scripts
- `lint/` : linting setup and file lists

## Decoder variants

The project includes two implementations of the same behavior:

- `bin2bcd_decoder_brute_force.sv`
- `bin2bcd_decoder_double_dabble.sv`

Both are exercised by the same testbench, `tb/bin2bcd/bin2bcd_dual_tb.sv`, which applies the same binary stimulus to both decoders and compares the outputs against the expected BCD value.

## Testbench usage

From `tb/bin2bcd/`:

```bash
make run
make debug
make run_debug
make clean
```

- `make run` : batch simulation without GUI
- `make debug` : GUI debug session with signal logging
- `make run_debug` : GUI debug session plus automatic run
- `make clean` : remove generated work library and logs

## Notes

- Waveform dumps and simulation artifacts are intentionally ignored by Git.
- The project uses Questa-compatible commands and expects a working Questa/ModelSim environment.
- Timing constraints are kept in `quartus/top.sdc`, and the simulation delay in the TB is only a functional settle delay, not an SDC enforcement mechanism.

## Repo hygiene

Generated files such as `.vcd`, `.wlf`, `transcript`, `work/`, and Quartus build artifacts are ignored via `.gitignore` so the repository stays focused on source files and project metadata.
