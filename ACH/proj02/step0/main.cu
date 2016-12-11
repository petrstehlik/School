/*
 * Architektura procesoru (ACH 2016)
 * Projekt c. 2 (cuda)
 * Login: xstehl14
 */

#include <sys/time.h>
#include <cstdio>
#include <cmath>
#include <iostream>
#include <algorithm>

#include "nbody.h"

using namespace std;

int main(int argc, char **argv)
{
    FILE *fp;
    struct timeval t1, t2;
    int N;
    float dt;
    int steps;
    int thr_blc;

    // parametry
    if (argc != 7)
    {
        printf("Usage: nbody <N> <dt> <steps> <thr/blc> <input> <output>\n");
        exit(1);
    }
    N = atoi(argv[1]);
    dt = atof(argv[2]);
    steps = atoi(argv[3]);
    thr_blc = atoi(argv[4]);

    printf("N: %d\n", N);
    printf("dt: %f\n", dt);
    printf("steps: %d\n", steps);
    printf("threads/block: %d\n", thr_blc);

	int blocksPerGrid = (thr_blc + N -1) / thr_blc;

	if (blocksPerGrid == 0) {
		blocksPerGrid = 1;
		thr_blc = N;
	}

	if (thr_blc > N) {
		thr_blc = N;
	}
	cout << "blocks: " << blocksPerGrid << endl; 
	cout << "threads/block: " << thr_blc << endl; 

	//const size_t size = N * sizeof(float);
    // alokace pameti na CPU
    t_particles particles_cpu;
    int size = N/thr_blc;
    if (N % thr_blc != 0)
    	size++;

    size *= thr_blc;

    cout << "size of array: " << size << endl;

    /* Host allocation */
    cudaHostAlloc(&particles_cpu.pos, size * sizeof(float3),cudaHostAllocDefault);
    cudaHostAlloc(&particles_cpu.vel, size * sizeof(float4), cudaHostAllocDefault);
	
	const float GDT = G * dt;

    // nacteni castic ze souboru
    fp = fopen(argv[5], "r");
    if (fp == NULL)
    {
        printf("Can't open file %s!\n", argv[2]);
        exit(1);
    }
    particles_read(fp, particles_cpu, N);
    fclose(fp);

    t_particles particles_gpu[2];
    for (int i = 0; i < 2; i++)
    {
        // alokace pameti na GPU
        // ZDE DOPLNTE ALOKACI PAMETI NA GPU

		cudaMalloc(&(particles_gpu[i].pos), size * sizeof(float3));
		cudaMalloc(&(particles_gpu[i].vel), size * sizeof(float4));

        // kopirovani castic na GPU
        // ZDE DOPLNTE KOPIROVANI DAT Z CPU NA GPU
		cudaMemcpy(particles_gpu[i].pos, particles_cpu.pos,
				size * sizeof(float3), cudaMemcpyHostToDevice);
		cudaMemcpy(particles_gpu[i].vel, particles_cpu.vel,
				size * sizeof(float4), cudaMemcpyHostToDevice);
    }

    // vypocet
    gettimeofday(&t1, 0);
    for (int s = 0; s < steps; s++)
    {
        // ZDE DOPLNTE SPUSTENI KERNELU
		particles_simulate <<<blocksPerGrid, thr_blc>>> (particles_gpu[0], particles_gpu[1], N, dt, GDT);
		//particles_pos<<<blocksPerGrid, thr_blc>>> (particles_gpu[0], particles_gpu[1], dt);
		t_particles tmp = particles_gpu[0];
		particles_gpu[1] = particles_gpu[0];
		particles_gpu[0] = tmp;
    }
    // ZDE DOPLNTE SYNCHRONIZACI
    cudaDeviceSynchronize();
    gettimeofday(&t2, 0);

	// check for error
	cudaError_t error = cudaGetLastError();
	if(error != cudaSuccess)
	{
		// print the CUDA error message and exit
		printf("CUDA error: %s\n", cudaGetErrorString(error));
		exit(-1);
	}

    // cas
    double t = (1000000.0 * (t2.tv_sec - t1.tv_sec) + t2.tv_usec - t1.tv_usec) / 1000000.0;
    printf("Time: %f s\n", t);

    // kpirovani castic zpet na CPU
    // ZDE DOPLNTE KOPIROVANI DAT Z GPU NA CPU
	cudaMemcpy(particles_cpu.pos, particles_gpu[1].pos,
			N * sizeof(float3), cudaMemcpyDeviceToHost);
	cudaMemcpy(particles_cpu.vel, particles_gpu[1].vel,
			N * sizeof(float4), cudaMemcpyDeviceToHost);

    // ulozeni castic do souboru
    fp = fopen(argv[6], "w");
    if (fp == NULL)
    {
        printf("Can't open file %s!\n", argv[6]);
        exit(1);
    }
    particles_write(fp, particles_cpu, N);
    fclose(fp);

	for (int i = 0; i < 2; i++) {
		cudaFree(&particles_gpu[i]);
	}

	cudaFreeHost(&particles_cpu);
	cudaFree(&particles_gpu[0]);
	cudaFree(&particles_gpu[1]);

    return 0;
}
