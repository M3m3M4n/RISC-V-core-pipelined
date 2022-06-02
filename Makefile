TARGET = TopModule

CONSTRAINTDIR = constraints
SOURCEDIR = srcs
TESTDIR = tests

BUILDDIR = build
TESTBUILDDIR = build_test

SRCFILES  := $(shell find $(SOURCEDIR) -type f -name '*.v' -o -name '*.sv')
TESTFILES := $(shell find $(TESTDIR) -type f -name '*.v' -o -name '*.sv')

default: bitstream

all: bitstream test

$(TARGET).json: $(SRCFILES)
	mkdir -p $(BUILDDIR)
	yosys -p "read_verilog -sv $^" -p "synth_ecp5 -json $(BUILDDIR)/$@" $^

$(TARGET)_out.config: $(TARGET).json
	nextpnr-ecp5 --25k --package CABGA381 --speed 6 --json $(BUILDDIR)/$< --textcfg $(BUILDDIR)/$@ --lpf $(CONSTRAINTDIR)/colorlighti5.lpf --freq 65

$(TARGET).bit: $(TARGET)_out.config
	ecppack --svf $(BUILDDIR)/${TARGET}.svf $(BUILDDIR)/$< $(BUILDDIR)/$@

${TARGET}.svf: ${TARGET}.bit

bitstream: ${TARGET}.svf

# vvp console -> trace on
test: $(TESTFILES) #$(TESTDIR)/*.v $(TESTDIR)/*.sv
	mkdir -p $(TESTBUILDDIR)
	for TESTFILE in $^ ; do \
		DUMPFILENAME="$${TESTFILE##*/}"; \
		DUMPFILENAME="$${DUMPFILENAME%.*}"; \
		DUMPFILENAMEARG="DUMPFILENAME=\"$(TESTBUILDDIR)/$${DUMPFILENAME}.vcd\""; \
		../bin/iverilog -pfileline=1 -g2012 -D $${DUMPFILENAMEARG} -o "$(TESTBUILDDIR)/$${DUMPFILENAME}.vvp" $${TESTFILE} $(SRCFILES); \
		../bin/vvp $(TESTBUILDDIR)/$${DUMPFILENAME}.vvp; \
	done

prog: bitstream
	openFPGALoader -b colorlight-i5 $(BUILDDIR)/$(TARGET).bit

clean:
	rm -rf $(BUILDDIR) $(TESTBUILDDIR) *.svf *.bit *.config *.ys *.json

.PHONY: all prog clean bitstream test default
