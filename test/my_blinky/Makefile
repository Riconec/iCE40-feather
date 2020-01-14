CC=riscv32-unknown-elf-
CFLAGS=

VERILOG_SRC = test.v

## $@ is the name of the target of the rule
## $< is the name of the first prerequisite
## $^ is the name of the all prerequisites

.PHONY: all sim runsim clean view synth prog

all: 

sim: test_tb.vvp

runsim: sim
	vvp -N test_tb.vvp

view:
	gtkwave testbench.vcd

test_tb.vvp: test_tb.v $(VERILOG_SRC)
	iverilog -s testbench -o $@ $^ `yosys-config --datdir/ice40/cells_sim.v`

synth: test.asc

test.json: test.v
	yosys -ql test.log -p 'synth_ice40 -top test -json test.json' $^

test.asc: ice40feather.pcf test.json
	nextpnr-ice40 --freq 13 --up5k --asc test.asc --pcf ice40feather.pcf --json test.json

test.bin: test.asc
	icetime -d up5k -c 12 -mtr test.rpt test.asc
	icepack test.asc test.bin

prog: test.bin
	iceprog test.bin

clean:
	rm *.vvp
	rm *.bin
	rm *.asc
	rm *.vcd
	rm *.json
	rm *.log
	rm *.rpt