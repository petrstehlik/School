/*
 * Architektura procesoru (ACH 2016)
 * Projekt c. 2 (cuda)
 * Login: xstehl14
 */

#include <cmath>
#include <cfloat>
#include "nbody.h"

#define BLOCK_SIZE 128

__device__ void particles_pos_dev(t_particles p_out, float dt, int i);

__global__ void particles_simulate(t_particles p_in, t_particles p_out, int N, float dt, const float GDT)
{

	int i = blockIdx.x * blockDim.x + threadIdx.x;

	float4 pos_i = p_in.pos[i];
	float3 vel_i = p_in.vel[i];
	float3 d;

	for (int tile = 0; tile < gridDim.x; tile++) {
		__shared__ float4 spos_j[BLOCK_SIZE];
		spos_j[threadIdx.x] = p_in.pos[tile * blockDim.x + threadIdx.x];
		__syncthreads();      

		#pragma unroll 4
		for (int j = 0; j < BLOCK_SIZE; j++) {
			// Calculate distance between two points in each axis
			d.x = spos_j[j].x - pos_i.x;
			d.y = spos_j[j].y - pos_i.y;
			d.z = spos_j[j].z - pos_i.z;

			// Calculate vector distance between two points
			float dist_R = rsqrtf(d.x * d.x +  d.y*d.y + d.z*d.z + FLT_EPSILON);
			//float inv_dist = rsqrtf(dist_R);
			float inv_dist_3R = dist_R * dist_R * dist_R;

			float F = GDT * spos_j[j].w * inv_dist_3R;

			//vel_i.x += F * d.x;
			vel_i.x = fmaf(F, d.x, vel_i.x);
			//vel_i.y += F * d.y;
			vel_i.y = fmaf(F, d.y, vel_i.y);
			//vel_i.z += F + d.z;
			vel_i.z = fmaf(F, d.z, vel_i.z);
		}
		__syncthreads();
	}


	p_out.vel[i] = vel_i;
	p_out.pos[i].x = fmaf(p_out.vel[i].x,dt, p_in.pos[i].x);
	p_out.pos[i].y = fmaf(p_out.vel[i].y,dt, p_in.pos[i].y);
	p_out.pos[i].z = fmaf(p_out.vel[i].z,dt, p_in.pos[i].z);
}

__global__ void particles_pos(t_particles p_in, t_particles p_out, float dt)
{
	//int i = blockIdx.x * blockDim.x + threadIdx.x;
			__syncthreads();
}

void particles_read(FILE *fp, t_particles &p, int N)
{
    for (int i = 0; i < N; i++)
    {
		fscanf(fp, "%f %f %f %f %f %f %f \n",
			&p.pos[i].x, &p.pos[i].y, &p.pos[i].z,
            &p.vel[i].x, &p.vel[i].y, &p.vel[i].z,
            &p.pos[i].w);
    }
}

void particles_write(FILE *fp, t_particles &p, int N)
{
    for (int i = 0; i < N; i++)
    {
		fprintf(fp, "%10.10f %10.10f %10.10f %10.10f %10.10f %10.10f %10.10f \n",
            p.pos[i].x, p.pos[i].y, p.pos[i].z,
            p.vel[i].x, p.vel[i].y, p.vel[i].z,
            p.pos[i].w);
    }
}
