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

	const size_t size = N * sizeof(float);
    // alokace pameti na CPU
    t_particles particles_cpu;

    /* Host allocation */
    cudaHostAlloc(&particles_cpu.pos_x, size, cudaHostAllocDefault);
    cudaHostAlloc(&particles_cpu.pos_y, size, cudaHostAllocDefault);
    cudaHostAlloc(&particles_cpu.pos_z, size, cudaHostAllocDefault);

    cudaHostAlloc(&particles_cpu.vel_x, size, cudaHostAllocDefault);
    cudaHostAlloc(&particles_cpu.vel_y, size, cudaHostAllocDefault);
    cudaHostAlloc(&particles_cpu.vel_z, size, cudaHostAllocDefault);

    cudaHostAlloc(&particles_cpu.weight, size, cudaHostAllocDefault);

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

		cudaMalloc(&(particles_gpu[i].pos_x), size);
		cudaMalloc(&(particles_gpu[i].pos_y), size);
		cudaMalloc(&(particles_gpu[i].pos_z), size);

		cudaMalloc(&(particles_gpu[i].vel_x), size);
		cudaMalloc(&(particles_gpu[i].vel_y), size);
		cudaMalloc(&(particles_gpu[i].vel_z), size);

		cudaMalloc(&(particles_gpu[i].weight), size);

        // kopirovani castic na GPU
        // ZDE DOPLNTE KOPIROVANI DAT Z CPU NA GPU
		cudaMemcpy(particles_gpu[i].pos_x, particles_cpu.pos_x, size, cudaMemcpyHostToDevice);
		cudaMemcpy(particles_gpu[i].pos_y, particles_cpu.pos_y, size, cudaMemcpyHostToDevice);
		cudaMemcpy(particles_gpu[i].pos_z, particles_cpu.pos_z, size, cudaMemcpyHostToDevice);

		cudaMemcpy(particles_gpu[i].vel_x, particles_cpu.vel_x, size, cudaMemcpyHostToDevice);
		cudaMemcpy(particles_gpu[i].vel_y, particles_cpu.vel_y, size, cudaMemcpyHostToDevice);
		cudaMemcpy(particles_gpu[i].vel_z, particles_cpu.vel_z, size, cudaMemcpyHostToDevice);
		
		cudaMemcpy(particles_gpu[i].weight, particles_cpu.weight, size, cudaMemcpyHostToDevice);
    }

	int blocksPerGrid = (thr_blc + N -1) / thr_blc;

	cout << "blocks: " << blocksPerGrid << endl; 
	if (blocksPerGrid == 0) {
		blocksPerGrid = 1;
		thr_blc = N;
	}

	if (thr_blc > N) {
		thr_blc = N;
	}

	cout << "blocks: " << blocksPerGrid << endl; 
	cout << "threads: " << thr_blc << endl; 

	//blocksPerGrid = 256;

	const float GDT = G * dt;

    // vypocet
    gettimeofday(&t1, 0);
    for (int s = 0; s < steps; s++)
    {
        // ZDE DOPLNTE SPUSTENI KERNELU
		particles_simulate <<<blocksPerGrid, thr_blc>>> (particles_gpu[1], particles_gpu[1], N, dt, GDT);
		particles_pos<<<blocksPerGrid, thr_blc>>> (particles_gpu[1], dt);

		//particles_simulate <<<1, N>>> (particles_gpu[1], particles_gpu[1], N, dt, GDT);
		//particles_pos<<<1, N>>> (particles_gpu[1], dt);
		//std::swap(particles_gpu[0], particles_gpu[1]);

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
	cudaMemcpy(particles_cpu.pos_x, particles_gpu[1].pos_x, size, cudaMemcpyDeviceToHost);
	cudaMemcpy(particles_cpu.pos_y, particles_gpu[1].pos_y, size, cudaMemcpyDeviceToHost);
	cudaMemcpy(particles_cpu.pos_z, particles_gpu[1].pos_z, size, cudaMemcpyDeviceToHost);
	cudaMemcpy(particles_cpu.vel_x, particles_gpu[1].vel_x, size, cudaMemcpyDeviceToHost);
	cudaMemcpy(particles_cpu.vel_y, particles_gpu[1].vel_y, size, cudaMemcpyDeviceToHost);
	cudaMemcpy(particles_cpu.vel_z, particles_gpu[1].vel_z, size, cudaMemcpyDeviceToHost);
	cudaMemcpy(particles_cpu.weight, particles_gpu[1].weight, size, cudaMemcpyDeviceToHost);

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
