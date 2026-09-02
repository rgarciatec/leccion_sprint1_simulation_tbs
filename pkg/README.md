# Project packages

> AI usage disclaimer: this README was created or assisted using AI tooling and then reviewed against the actual project files.

This directory contains the shared package definitions used by the SystemVerilog design.

## Main file

- `top_pkg.sv` : project-wide package definitions used across the design

## Purpose

Packages are used for:

- common typedefs
- enums
- configuration constants
- reusable parameter and type declarations

Keeping shared definitions in a package keeps the RTL cleaner and makes block integration easier.
