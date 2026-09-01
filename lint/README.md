# Verible lint setup

> AI usage disclaimer: this README was created with the assistance of an AI tool. It is intended as a practical guide, but users should verify commands and project specifics against their local environment and toolchain.

This directory contains a lightweight Verible lint setup for the SystemVerilog sources used in this project.

The command used for linting is:

```bash
verible-verilog-lint $(cat rtl.f) --rules_config=custom_rules_verible_lint.txt --waiver_files=waivers.txt
```

This works by passing all files listed in `rtl.f` to the linter, then applying a custom rule configuration and a waiver file.

The `make lint` target also captures the terminal output to a log file, so you can inspect the warnings later without rerunning the linter. The default log file is `verible_lint.log`, and you can override it with `LOG=my_log_name.log`.

---

## 1. Installing Verible

To use this flow, install Verible first.

The recommended approach is to use the official release binaries from the Chips Alliance project:

```bash
wget https://github.com/chipsalliance/verible/releases
```

Then choose the Linux build matching your architecture, for example:

```bash
wget https://github.com/chipsalliance/verible/releases/download/v0.0-<release-tag>/verible-v0.0-<release-tag>-linux-static-x86_64.tar.gz
tar -xzf verible-v0.0-<release-tag>-linux-static-x86_64.tar.gz
```

Move the extracted `bin/` directory into your PATH or source it manually:

```bash
export PATH="$PWD/verible-v0.0-<release-tag>-linux-static-x86_64/bin:$PATH"
```

Then confirm it is available:

```bash
verible-verilog-lint --help
```

If the release file name differs on the website, use the exact asset name shown in the release page for your platform.

---

## 2. Why the file list matters

The file `rtl.f` is a source list, not a build script. It enumerates the SystemVerilog files that should be checked by the linter.

For this project it contains:

```text
../pkg/top_pkg.sv
../top/top.sv
../blocks/bcd2seven_seg/bcd2seven_seg_pkg.sv
../blocks/bcd2seven_seg/bcd2seven_seg_decoder.sv
../blocks/bin2bcd/bin2bcd_pkg.sv
../blocks/bin2bcd/bin2bcd_decoder_brute_force.sv
../blocks/bin2bcd/bin2bcd_decoder_double_dabble.sv
```

This matters because Verible checks files as standalone compilation units. A file list is useful when:

- the design is spread across several sources
- not all modules are part of the active top-level hierarchy
- the project contains helper packages, reusable blocks, and top-level wrappers
- you want to lint all relevant RTL without needing to compile the full project

In other words, `rtl.f` is a practical way to tell the linter: “these are the files worth checking.”

---

## 2. Why not all modules are instantiated

This project intentionally includes files that are not all used in one instantiation tree.

That is common in HDL work:

- packages are included for typedefs, enums, and constants
- reusable blocks are present as design alternatives or comparison implementations
- some modules are kept for evaluation, experiments, or architecture comparison
- the top module may instantiate only a subset of the available blocks

Because Verible is a style linter, not a full semantic netlist analyzer, it does not need every module to be instantiated in order to check the file for syntax, structure, naming, and style issues.

So the lint pass is usually aimed at all relevant RTL files, even if the hierarchy does not instantiate every module in the same build.

---

## 3. What the command does

```bash
verible-verilog-lint $(cat rtl.f) --rules_config=custom_rules_verible_lint.txt --waiver_files=waivers.txt
```

This expands as:

- `$(cat rtl.f)` reads every file listed in the filelist
- `verible-verilog-lint` runs the lint tool on those files
- `--rules_config=custom_rules_verible_lint.txt` loads extra rules or overrides
- `--waiver_files=waivers.txt` suppresses selected warnings that are known and intentional

This is a good pattern for lab or project work where you want a tighter rule set without editing the source to bury every warning.

---

## 4. Custom rules file

The file `custom_rules_verible_lint.txt` currently contains:

```text
+parameter-name-style=localparam_style:ALL_CAPS
```

This means:

- enable the `parameter-name-style` rule
- enforce `localparam` names to use `ALL_CAPS`

This is useful when the project wants a consistent naming convention for local constants.

The general format for rule configuration is:

```text
+rule-name=param:value
```

or

```text
-rule-name
```

to disable a rule.

See the Verible documentation for the complete rule catalogue and supported parameters:

- https://chipsalliance.github.io/verible/verilog_lint.html
- https://github.com/chipsalliance/verible/blob/master/verible/verilog/tools/lint/README.md

---

## 5. Waiver file

The file `waivers.txt` contains:

```text
waive --rule=line-length
```

This tells Verible to waive the `line-length` violation globally.

Waivers are very useful when:

- long signal names or parameter lists are intentional
- generated or lab-specific code is easier to read with longer lines
- a project wants to keep some style exceptions without disabling the rule entirely

The Waiver file format supports entries such as:

```text
waive --rule=line-length
waive --rule=module-port --line=42
waive --rule=signal-name-style --location=".*some_file.*"
```

This is an external, non-invasive way to keep the source clean while documenting exceptions.

---

## 6. Typical workflow

From this directory:

```bash
verible-verilog-lint $(cat rtl.f) --rules_config=custom_rules_verible_lint.txt --waiver_files=waivers.txt
```

If you want a more reusable command, add a Makefile target like:

```make
lint:
	verible-verilog-lint $$(cat rtl.f) --rules_config=custom_rules_verible_lint.txt --waiver_files=waivers.txt
```

Then run:

```bash
make lint
```

The command prints the Verible output to the terminal and saves the same output to `verible_lint.log`. At the end you will see a message similar to:

```text
Verible lint log saved to: verible_lint.log
```

You can also provide your own file list without changing the default project setup:

```bash
make lint FILES=new.f
```

or, for a different custom path:

```bash
make lint FILES=path/to/my_files.f
```

This keeps the same lint configuration while letting you run the check on any list of RTL files you choose.

### Example: lint only the BCD-to-7-segment decoder

Create a file list containing only the decoder package and the decoder module:

```bash
cat > bcd2seven_only.f <<'EOF'
../blocks/bcd2seven_seg/bcd2seven_seg_pkg.sv
../blocks/bcd2seven_seg/bcd2seven_seg_decoder.sv
EOF
```

Then run:

```bash
make lint FILES=bcd2seven_only.f
```

This is equivalent to:

```bash
verible-verilog-lint $(cat bcd2seven_only.f) --rules_config=custom_rules_verible_lint.txt --waiver_files=waivers.txt
```

If you also want to include the top module that instantiates it, use:

```bash
cat > bcd2seven_top_only.f <<'EOF'
../pkg/top_pkg.sv
../top/top.sv
../blocks/bcd2seven_seg/bcd2seven_seg_pkg.sv
../blocks/bcd2seven_seg/bcd2seven_seg_decoder.sv
EOF
```

and then:

```bash
make lint FILES=bcd2seven_top_only.f
```

This is useful when you want to check a specific subsystem without linting every file in the repository.

---

## 7. Notes from Verible behavior

A few important points from the Verible linter behavior:

- it works on individual files, not necessarily in a full elaborated connectivity sense
- it does not need every module to be instantiated in your top-level design
- it is a syntax and style checker, not a simulator or elaboration tool
- file lists are a practical method for linting a project directory without compiling everything at once
- waivers are helpful when the project deliberately accepts certain style exceptions

---

## 8. Summary

This lint setup is intentionally simple:

- `rtl.f` defines the files to lint
- `custom_rules_verible_lint.txt` adds one project-specific rule
- `waivers.txt` suppresses selected known exceptions
- `verible-verilog-lint` runs the check against the listed files

This keeps the flow consistent while acknowledging that not every file in the project is part of the same instantiated hierarchy.
