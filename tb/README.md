# Testbench directory

> AI usage disclaimer: this README was created or assisted using AI tooling and then reviewed against the actual project files.

This directory contains the project verification setup for both block-level and top-level simulation flows.

## Contents

- `bin2bcd/` : binary-to-BCD comparison testbench
- `bcd2seven_seg/` : 7-segment decoder validation
- `top/` : full-system integration testbench

## Typical usage

From this directory you can open the individual testbench folders and run their local `Makefile` targets.

Examples:

```bash
cd tb/bin2bcd
make run

cd ../bcd2seven_seg
make run

cd ../top
make run
```

## Purpose

This directory separates verification into clear levels:

1. Block-level checks for reusable RTL functionality
2. Top-level integration testing for the full design

This keeps the simulation workflow easier to diagnose and maintain.
