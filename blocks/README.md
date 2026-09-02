# RTL blocks

> AI usage disclaimer: this README was created or assisted using AI tooling and then reviewed against the actual project files.

This directory contains the reusable RTL blocks used by the top-level design.

## Subdirectories

- `bin2bcd/` : binary-to-BCD implementations and package files
- `bcd2seven_seg/` : BCD-to-7-segment decoder logic

## Typical role

These blocks are implemented independently so they can be:

- tested in isolation
- compared against alternate implementations
- integrated into a larger top-level design

## Design intent

The repository includes both a brute-force and a double-dabble binary-to-BCD implementation. The block-level tests validate these implementations separately before they are used in the higher-level design.
