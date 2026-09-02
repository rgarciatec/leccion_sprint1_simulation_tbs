# BCD-to-7-segment decoder testbench

> AI usage disclaimer: this README was created or assisted using AI tooling and then reviewed against the actual project files.

This folder contains the focused verification for the 7-segment decoder block.

## Files

- `bcd2seven_seg_tb.sv` : testbench for all valid BCD inputs
- `Makefile` : compile and run commands

## Purpose

The block takes a 4-bit BCD value and drives the seven outputs of a hexadecimal digit display.

This testbench checks the decoder over all valid inputs to ensure:

- each output bit matches the expected symbol pattern
- the decoder handles every BCD state without errors
- the logic is stable and deterministic

## Typical workflow

From this directory:

```bash
make run
make debug
make run_debug
make clean
```

### What the targets do

- `make run` : compile and run the TB in batch mode
- `make debug` : open a GUI session on the compiled design
- `make run_debug` : GUI session with `run -all`
- `make clean` : remove local simulator outputs

## Notes

This is a block-level verification. It is the quickest way to validate the 7-segment decode logic without the complexity of the full top-level integration.
