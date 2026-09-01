.PHONY: lint clean

FILES ?= rtl.f
LOG ?= verible_lint.log

lint:
	@mkdir -p .
	verible-verilog-lint $(shell cat $(FILES)) --rules_config=custom_rules_verible_lint.txt --waiver_files=waivers.txt 2>&1 | tee $(LOG)
	@echo "Verible lint log saved to: $(LOG)"

clean:
	rm -f *.log *.out
