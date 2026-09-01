.PHONY: all map fit asm sta eda programmer clean

TOP ?= top
PROJECT := $(TOP)

all: map fit asm sta eda

map:
	quartus_map --read_settings_files=on --write_settings_files=off $(PROJECT) -c $(PROJECT)

fit:
	quartus_fit --read_settings_files=off --write_settings_files=off $(PROJECT) -c $(PROJECT)

asm:
	quartus_asm --read_settings_files=off --write_settings_files=off $(PROJECT) -c $(PROJECT)

sta:
	quartus_sta $(PROJECT) -c $(PROJECT)

eda:
	quartus_eda --read_settings_files=off --write_settings_files=off $(PROJECT) -c $(PROJECT)

programmer:
	quartus_pgmw $(PROJECT).qpf

compile: all

clean:
	@echo "No aggressive cleanup here; Quartus keeps generated outputs in output_files/"
