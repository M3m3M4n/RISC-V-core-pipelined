TARGET = TopModule

SOURCEDIR = srcs
TESTDIR = tests

TESTBUILDDIR = build_test

SRCFILES  := $(shell find $(SOURCEDIR) -type f -name '*.v' -o -name '*.sv')
TESTFILES := $(shell find $(TESTDIR) -type f -name '*.v' -o -name '*.sv')

default: test

all: test

# USE LATEST IVERILOG FROM GIT
test: $(TESTFILES)
	mkdir -p $(TESTBUILDDIR)
	for TESTFILE in $^ ; do \
		DUMPFILENAME="$${TESTFILE##*/}"; \
		DUMPFILENAME="$${DUMPFILENAME%.*}"; \
		DUMPFILENAMEARG="DUMPFILENAME=\"$(TESTBUILDDIR)/$${DUMPFILENAME}.vcd\""; \
		../bin/iverilog -g2012 -D $${DUMPFILENAMEARG} -o "$(TESTBUILDDIR)/$${DUMPFILENAME}.vvp" $${TESTFILE} $(SRCFILES); \
		../bin/vvp $(TESTBUILDDIR)/$${DUMPFILENAME}.vvp; \
	done

clean:
	rm -rf $(TESTBUILDDIR) *.svf *.bit *.config *.ys *.json

.PHONY: all clean test default
