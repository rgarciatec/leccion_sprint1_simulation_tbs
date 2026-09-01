# LECCION6 Simulation TBs

This repository includes a small FPGA-style design and a set of simulation flows:

- RTL functional simulation in Questa
- Quartus project build and netlist generation
- optional post-fit / GLS simulation using the generated netlist and delay data

The purpose is to keep the design source clean, while separating local generated artifacts from the committed project files.

## Project structure

- `blocks/` : RTL blocks such as the BCD decoders and 7-segment decoder
- `pkg/` : package definitions used across modules
- `top/` : integration module used at the top level
- `tb/` : testbenches and per-block Makefiles
- `quartus/` : Quartus project and constraints
- `synth/` : synthesis and Yosys related scripts
- `lint/` : lint rules and waiver configuration

## 1) RTL simulation

This is the normal development loop. It checks logical behavior without involving FPGA primitives or post-fit timing.

From the relevant testbench folder, for example:

```bash
cd tb/bin2bcd
make run
```

Common targets:

```bash
make run
make debug
make run_debug
make clean
```

What these do:

- `make run` : compile the RTL and run in batch mode
- `make debug` : open a GUI debug session
- `make run_debug` : GUI session with `run -all`
- `make clean` : remove `work/` and log files

This is the fastest path for catching logic bugs while developing the RTL.

## 2) Quartus build and generated netlist

The FPGA build is separate from the RTL simulation. Quartus generates post-fit outputs used for timing-aware checking.

From the Quartus folder:

```bash
cd quartus
make all
```

This creates the project outputs, including the generated netlist and post-fit files under:

```text
quartus/simulation/questa/
```

Typical output you may see there:

- `top.svo` : post-fit netlist
- `top.sft` : Quartus-generated settings file, not a true SDF delay file
- additional generated project artifacts in `output_files/` and `db/`

Important: `top.sft` is not the file you pass to `-sdftyp` in Questa. It is a Quartus metadata/settings file, not a timing delay file. The real delay file must be a `.sdo` or `.sdf` generated for post-fit timing, if present.

## 3) GLS / post-fit simulation

This is a different flow from plain RTL simulation. It loads the FPGA netlist and optionally applies delay information.

The correct flow is:

1. Build the Quartus project
2. Compile the Intel/Quartus simulation library into the Questa work library
3. Compile the generated post-fit netlist
4. Run the testbench with `-sdftyp` only if a real delay file exists

The reference pattern is in:

```text
leccion2_hdl_intro/sprint0/tests/sv/Makefile
```

The key idea is that the generated netlist references FPGA primitive modules such as:

- `cyclonev_lcell_comb`
- other Intel primitive definitions

Those modules are not part of the normal RTL simulation library. They only exist in the Quartus simulation library, so you must compile them first.

## 4) Top-level project usage

From the top-level TB folder:

```bash
cd tb/top
make run
make debug
make run_debug
make gls
make gui_gls
```

Meaning:

- `make run` : RTL verification of the full top-level design
- `make debug` : GUI debug for RTL
- `make run_debug` : GUI debug plus auto-run
- `make gls` : post-fit netlist flow when Quartus output exists
- `make gui_gls` : interactive post-fit GUI flow

## Why the GLS flow is more complicated

This part often feels confusing because it mixes three layers:

1. your RTL source
2. Quartus-generated FPGA netlist
3. Intel primitive simulation library

A plain RTL simulation does not need the FPGA library. A post-fit simulation does. That is why you may see errors like:

```text
Module 'cyclonev_lcell_comb' is not defined
```

This means the generated netlist was loaded, but the corresponding Quartus primitive library was not compiled into the Questa work library.

## 5) Working with generated files

Generated files such as:

- `work/`
- `transcript`
- `transcript.log`
- `*.wlf`
- `*.vcd`
- Quartus output folders

should not be committed to source control. The repository uses `.gitignore` to keep the source tree clean and focused on actual design files.

## 6) Recommended workflow

For day-to-day development:

```bash
cd tb/top
make run
```

When you want to check the FPGA timing view:

```bash
cd quartus
make all
cd ../tb/top
make gls
```

If the post-fit delay file is not present, the GLS flow should degrade gracefully and still run the post-fit netlist without SDF rather than failing on a bogus file.

## Repo hygiene notes

- Keep source files in the repo
- keep generated artifacts local
- do not commit Quartus build outputs or simulation artifacts
- treat `top.sft` as a Quartus metadata file, not as a Questa SDF input

This keeps the project reproducible and avoids cluttering the repository with generated output.
