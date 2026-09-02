# Binary-to-BCD testbench

> AI usage disclaimer: this README was created or assisted using AI tooling and then reviewed against the actual project files.

This directory contains the comparison-based verification for the `bin2bcd` decoder implementations.

## Files

- `bin2bcd_dual_tb.sv` : testbench that checks both implementations against the same inputs
- `Makefile` : compile and run flow

## Purpose

This project includes two implementations:

- `bin2bcd_decoder_brute_force.sv`
- `bin2bcd_decoder_double_dabble.sv`

The testbench applies the same `sw` value to both decoders and verifies that they agree on the produced BCD output.

This is useful to confirm:

- functional equivalence
- correct handling of edge cases
- signal naming conventions and output alignment

## Typical workflow

From this directory:

```bash
make run
make debug
make run_debug
make clean
```

### What the targets do

- `make run` : compile and run the design in batch mode
- `make debug` : open the GUI with logged signals and waves
- `make run_debug` : open GUI and immediately run the testbench
- `make clean` : remove local work files and logs

## Why this TB matters

This flow is a strong intermediate validation step before moving to the full top-level testbench. It isolates the BCD-generation logic and makes debugging much quicker.
