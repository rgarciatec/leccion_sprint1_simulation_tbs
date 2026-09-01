# Yosys synthesis tutorial

> AI usage disclaimer: this README was created with the assistance of an AI tool. It is intended as a practical guide, but users should verify commands and project specifics against their local environment and toolchain.

This folder contains a tiny, repeatable flow for synthesizing the `bin2bcd` decoder modules using Yosys. It produces both:

- a generic gate-level netlist
- an Intel FPGA-oriented netlist for an ALM-style target

The automation is driven by the `Makefile` and the two script files:

- `synth_gates.ys` — generic gate synthesis
- `synth_fpga.ys` — Intel FPGA/ALM synthesis

---

## 1. What this project is doing

The scripts read the SystemVerilog sources from the `blocks/bin2bcd` directory and synthesize two top-level modules:

- `bin2bcd_decoder_brute_force`
- `bin2bcd_decoder_double_dabble`

Each script:

1. loads the required package and implementation files
2. checks the design hierarchy
3. synthesizes the logic
4. writes a generated Verilog netlist
5. produces a visual diagram in SVG format

This is useful to compare:

- logic structure
- optimization quality
- portability to FPGA resources
- readability of the generated circuit

---

## 2. Prerequisites and toolchain setup

This project is designed to work with the OSS CAD Suite build of Yosys, which includes the core synthesis tools and utilities commonly used in HDL labs.

Before running this flow, make sure you have the following installed or available in your environment:

- Yosys
- ABC
- the `slang` plugin or equivalent SystemVerilog frontend support
- `make`
- `Graphviz`/`dot` for the `show` command to generate SVG output
- an SVG viewer such as `xdot` or Inkscape
- a working terminal in a Linux environment

The typical setup is to download the Linux x64 archive from the official releases page and extract it. For example:

```bash
wget https://github.com/YosysHQ/oss-cad-suite-build/releases/download/2026-09-01/oss-cad-suite-linux-x64-20260901.tgz
tar -xzf oss-cad-suite-linux-x64-20260901.tgz
source oss-cad-suite/environment
```

The exact filename depends on the platform and release date, so always check the release page for the current archive name before downloading.

This should be repeated in each new terminal session before running Yosys commands.

### Check installation

Run:

```bash
yosys --version
which dot
which xdot
make --version
```

If `yosys` is present but the script fails with a message like `plugin not found` or `slang not found`, then your Yosys build is incomplete or missing the required frontend support.

The scripts begin with:

```yosys
plugin -i slang
```

This means the plugin must be available in your Yosys installation. If it is not, the scripts will not parse the SystemVerilog sources correctly.

### Opening the generated SVGs

The SVGs can be opened with a viewer such as `xdot`, or with a general-purpose SVG editor such as Inkscape.

Examples:

```bash
xdot gate_brute_force.svg
```

or

```bash
inkscape gate_brute_force.svg
```

Use whichever tool is most convenient for inspecting the generated circuit structure.

---

## 3. Directory layout

From this folder you will find:

```text
synth/
├── Makefile
├── synth_gates.ys
├── synth_fpga.ys
├── README.md
```

The modules being synthesized live in:

```text
../blocks/bin2bcd/
├── bin2bcd_pkg.sv
├── bin2bcd_decoder_brute_force.sv
├── bin2bcd_decoder_double_dabble.sv
```

The scripts reference those relative paths, so you should run the commands from the `synth/` directory.

---

## 4. How to run it

Open a terminal, source the OSS CAD environment, and move into this folder:

```bash
source /path/to/oss-cad-suite/environment
cd /path/to/leccion6_simulation_tbs/synth
```

Then use `make`:

```bash
make
```

This runs both synthesis flows:

- `make gates`
- `make fpga`

The Makefile uses a POSIX-compatible shell and `tee` so the synthesis output is shown in the terminal and also saved to a log file. This mirrors the Verible flow and makes it easy to inspect warnings, errors, or synthesis details later while remaining portable across typical Unix shells.

### Generic gate synthesis

```bash
make gates
```

This runs `synth_gates.ys` and generates files such as:

- `yosys_gates.log` for the gate synthesis run

and also the generated netlists:

- `gate_brute_force.sv`
- `gate_brute_force.json`
- `gate_brute_force.svg`
- `gate_brute_force.dot`
- `gate_double_dabble.sv`
- `gate_double_dabble.json`
- `gate_double_dabble.svg`
- `gate_double_dabble.dot`

The JSON files are intended for `netlistsvg`, for example:

```bash
netlistsvg gate_double_dabble.json -o gate_double_dabble.svg
```

This workflow is only useful in the gate-level flow because the FPGA-oriented synthesis output is not a plain generic netlist suitable for the same conversion.

If you want a custom log name:

```bash
make gates GATES_LOG=my_gate_run.log
```

### FPGA-oriented synthesis

```bash
make fpga
```

This runs `synth_fpga.ys` and generates:

- `yosys_fpga.log` for the FPGA synthesis run
- `fpga_brute_force.sv`
- `fpga_brute_force.svg`
- `fpga_brute_force.dot`
- `fpga_double_dabble.sv`
- `fpga_double_dabble.svg`
- `fpga_double_dabble.dot`

If you want a custom FPGA log name:

```bash
make fpga FPGA_LOG=my_fpga_run.log
```

### Clean generated files

```bash
make clean
```

This removes all generated `.sv`, `.svg`, and `.dot` outputs.

---

## 5. What each script is doing

### `synth_gates.ys`

This is the generic logic-synthesis flow.

```yosys
plugin -i slang

read_slang --top bin2bcd_decoder_brute_force \
    ../blocks/bin2bcd/bin2bcd_pkg.sv \
    ../blocks/bin2bcd/bin2bcd_decoder_brute_force.sv

hierarchy -check -top bin2bcd_decoder_brute_force
proc
opt
synth
abc -g gates
write_verilog -noattr -sv gate_brute_force.sv
show -format svg -prefix gate_brute_force
```

Important points:

- `read_slang` loads the package and the design.
- `hierarchy -check` verifies the module structure.
- `proc` and `opt` simplify the logic.
- `synth` performs technology-independent synthesis.
- `abc -g gates` maps the logic into primitive gates.
- `write_verilog` saves the generated gate-level Verilog.
- `show` produces a visual netlist graph.

The same structure is repeated for the second module after `design -reset`.

### `synth_fpga.ys`

This flow targets Intel-style FPGA synthesis.

```yosys
plugin -i slang

read_slang --top bin2bcd_decoder_brute_force \
    ../blocks/bin2bcd/bin2bcd_pkg.sv \
    ../blocks/bin2bcd/bin2bcd_decoder_brute_force.sv

synth_intel_alm -top bin2bcd_decoder_brute_force
write_verilog -noattr -sv fpga_brute_force.sv
show -format svg -prefix fpga_brute_force
```

Important points:

- `synth_intel_alm` is specific to Intel FPGA/ALM-style synthesis.
- This produces output closer to what an Intel FPGA synthesis tool would infer.
- It is useful when you want to see how the design maps into FPGA-friendly primitives.

---

## 6. What to look for in the output

After synthesis, inspect both the generated Verilog and the SVG diagrams.

### In the generated `.sv` files

Look for:

- whether the design synthesized without errors
- any unexpected combinational loops
- large logic expansions or repeated logic blocks
- signal naming and hierarchy structure
- if the netlist matches the expected behavior of the BCD decoder

The generated Verilog is often a flattened or gate-level representation, so it is more useful for checking structure than for reading by hand.

### In the `.svg` files

Open the SVG in a browser or viewer such as `xdot` or Inkscape and look for:

- very crowded or highly tangled logic blocks
- disconnected subgraphs
- obvious duplication of logic between outputs
- whether the design is effectively a tree or a large network

For a simple decoder, the circuit should look structured and deterministic. If the graph is extremely large or chaotic, it may indicate a poor implementation choice or an unoptimized design.

### Compare the two methods

The project intentionally synthesizes the same design in two ways:

- `gates` — generic gate-level implementation
- `fpga` — Intel FPGA-targeted implementation

Compare the two outputs to see:

- how differently Yosys maps the same logic
- whether the FPGA script uses more recognizable primitives or more compact logic
- which version is easier to reason about for hardware implementation

---

## 7. Typical issues and troubleshooting

### 1. `plugin -i slang` fails

This usually means your Yosys install does not include the `slang` plugin.

Fix:

- install a Yosys version with `slang` support
- rebuild Yosys with the needed plugin enabled
- verify with `yosys -Q -p 'plugin -i slang'`
- or use the OSS CAD Suite distribution, which is the recommended path for this lab setup

### 2. `source oss-cad-suite/environment` fails

This usually means the extracted archive is not present in the current directory or the path is wrong.

Check that the folder exists and the command was run from the correct location before using Yosys.

### 3. SVG viewer not available

If `xdot` is missing, you can use Inkscape or another SVG-capable tool.

Example:

```bash
inkscape gate_brute_force.svg
```

### 2. File not found for `../blocks/bin2bcd/...`

This usually means you are not running the command from the `synth` directory.

Run from:

```bash
cd .../leccion6_simulation_tbs/synth
```

### 3. `show` does not create SVG output

This commonly happens when Graphviz is missing.

Install `dot`/Graphviz and verify:

```bash
which dot
```

### 4. Generated files are empty or warnings appear

Check the Yosys output in the terminal carefully. Common causes:

- wrong top module name
- design file syntax issue
- missing package include
- unsupported SystemVerilog construct for the selected frontend

---

## 8. Suggested workflow for learning

A good way to use this project is:

1. run `make gates`
2. inspect the generated gate-level Verilog
3. open the SVG graph
4. run `make fpga`
5. compare the gate-level and FPGA-targeted versions
6. change the source module or try a different design and re-run the flow

This gives you a simple hands-on way to understand:

- synthesis steps
- logic-level optimization
- technology mapping
- gate-level netlist structure
- visual debugging of hardware logic

---

## 9. Summary

This folder is a small synthesis playground:

- `make gates` gives a generic digital-logic view
- `make fpga` gives an Intel FPGA-oriented mapping view
- `make clean` resets the generated outputs

The key idea is to look at both the produced netlists and the graphs to understand how Yosys transforms your design from RTL/SystemVerilog into hardware.

If you want to learn from this flow, focus on the generated SVGs and the final `.sv` outputs, because they reveal the structure of the synthesized circuit much more clearly than the raw source code alone.
