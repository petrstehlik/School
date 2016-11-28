# Architektura procesoru (ACH 2016)
# Projekt c. 1 (matvec)
# Login: xstehl14

CFLAGS=-lpapi -ansi-alias
OPT=-O0
REPORT=

ROWS=32
COLS=31
PADDING=0
RUNS=1000000

PARAMS=-DROWS=$(ROWS) -DCOLS=$(COLS) -DPADDING=$(PADDING) -DRUNS=$(RUNS)

PAPI_EVENTS=PAPI_FP_OPS|PAPI_SP_OPS

all:
	icpc $(CFLAGS) $(OPT) $(REPORT) -c matvec.cpp
	icpc $(CFLAGS) $(OPT) -S -fsource-asm -c matvec.cpp
	icpc $(CFLAGS) $(OPT) $(PARAMS) matvec.o main.cpp -o matvec

clean:
	rm -f *.o matvec

run:
	PAPI_EVENTS='$(PAPI_EVENTS)' ./matvec
