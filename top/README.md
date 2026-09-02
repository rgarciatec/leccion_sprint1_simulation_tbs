# Top-level design

> AI usage disclaimer: this README was created or assisted using AI tooling and then reviewed against the actual project files.

This directory contains the top-level integration module for the project.

## Main file

- `top.sv` : integrates the decoder logic and board-level signal routing

## Design intent

The top module connects:

- switch inputs (`sw`)
- LED outputs (`ledg`, `ledr`)
- 7-segment displays (`hex0` to `hex3`)

It is the design entity used by the Quartus project and by the full-system simulation testbench.

## Build and simulation relationship

This file is used in both of the following flows:

- RTL simulation in Questa
- Quartus compilation and optionally GLS/post-fit simulation

The project-specific board configuration and pin assignments are defined in the Quartus project settings, not in the RTL file itself.
