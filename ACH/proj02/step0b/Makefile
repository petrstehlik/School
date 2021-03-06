# Architektura procesoru (ACH 2016)
# Projekt c. 2 (cuda)
# Login: xstehl14

N=8192
DT=0.001f
STEPS=1000
THREADS_PER_BLOCK=128
#N=932
#DT=0.001f
#STEPS=100

#INPUT=../test/thompson_points_932.dat
INPUT=../input.dat
OUTPUT=../step0.dat

N_T = 2
DT_T=0.00001f
STEPS_T=543847
INPUT_T=test.dat
OUTPUT_T=step0.dat

CXXFLAGS = -Xcompiler="-Wall -O3 -fopenmp -ffast-math -fassociative-math -march=native" \
           -O3 -std=c++11  \
    	#--generate-code arch=compute_20,code=sm_20  #  \
#     --generate-code arch=compute_35,code=sm_35

all:
	nvcc -Xptxas="-v" $(CXXFLAGS) nbody.cu main.cu -o nbody

gen:
	icpc gen.cpp -o gen

clean:
	rm -f *.o nbody

run:
	./nbody $(N) $(DT) $(STEPS) $(THREADS_PER_BLOCK) $(INPUT) $(OUTPUT)

test:
	./nbody $(N_T) $(DT_T) $(STEPS_T) $(THREADS_PER_BLOCK) $(INPUT_T) $(OUTPUT_T)

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
