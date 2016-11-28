# Architektura procesoru (ACH 2016)
# Projekt c. 2 (cuda)
# Login: xlogin00

N=8192
DT=0.001f
STEPS=1000
THREADS_PER_BLOCK=

INPUT=../input.dat
OUTPUT=../step0.dat

all:
	nvcc -Xptxas="-v" nbody.cu main.cu -o nbody
	icpc gen.cpp -o gen

clean:
	rm -f *.o nbody

run:
	./nbody $(N) $(DT) $(STEPS) $(THREADS_PER_BLOCK) $(INPUT) $(OUTPUT)

profile:
	nvprof \
		--devices 0 \
		--metrics flops_sp \
		--metrics flops_sp_add \
		--metrics flops_sp_mul \
		--metrics flops_sp_fma \
		--metrics flops_sp_special \
		--metrics flop_sp_efficiency \
		--metrics sm_efficiency \
		--metrics alu_fu_utilization \
		--metrics gld_transactions \
		--metrics l1_cache_global_hit_rate \
		--metrics shared_load_transactions \
		./nbody $(N) $(DT) 1 $(THREADS_PER_BLOCK) $(INPUT) $(OUTPUT)
