# Architektura procesoru (ACH 2016)
# Projekt c. 1 (nbody)
# Login: xstehl14

CFLAGS=-lpapi -ansi-alias
OPT=-O2 -xavx -qopenmp-simd
REPORT=-qopt-report=5

N=1000
DT=0.001f
STEPS=1000

INPUT=../input.dat
OUTPUT=../step2.dat

PARAMS=-DN=$(N) -DDT=$(DT) -DSTEPS=$(STEPS)

# _TCA = total cache access
# _TCM = total cache misses
# _TCH = total cache hits

PAPI_EVENTS=PAPI_FP_OPS|PAPI_SP_OPS
PAPI_EVENTS_L1=PAPI_L1_DCM|PAPI_LD_INS|PAPI_SR_INS|PAPI_L2_DCM|PAPI_L2_DCA
PAPI_EVENTS_L2=PAPI_L2_DCM|PAPI_L2_DCA
PAPI_EVENTS_L3=PAPI_L3_TCM|PAPI_L3_TCA|PAPI_FP_OPS|PAPI_SP_OPS

all:
	icpc $(CFLAGS) $(OPT) $(REPORT) $(PARAMS) -c nbody.cpp
	icpc $(CFLAGS) $(OPT) $(PARAMS) -S -fsource-asm -c nbody.cpp
	icpc $(CFLAGS) $(PARAMS) nbody.o main.cpp -o nbody
	icpc $(CFLAGS) gen.cpp -o gen

clean:
	rm -f *.o nbody

run:
	PAPI_EVENTS='$(PAPI_EVENTS)' ./nbody $(INPUT) $(OUTPUT)

l1:
	PAPI_EVENTS='$(PAPI_EVENTS_L1)' ./nbody $(INPUT) $(OUTPUT)

l2:
	PAPI_EVENTS='$(PAPI_EVENTS_L2)' ./nbody $(INPUT) $(OUTPUT)

l3:
	PAPI_EVENTS='$(PAPI_EVENTS_L3)' ./nbody $(INPUT) $(OUTPUT)


