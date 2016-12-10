/*
 * Architektura procesoru (ACH 2016)
 * Projekt c. 2 (cuda)
 * Login: xlogin00
 */

#include <cmath>
#include <cfloat>
#include "nbody.h"

__device__ void particles_pos_dev(t_particles p_out, float dt, int i);

__global__ void particles_simulate(t_particles p_in, t_particles p_out, int N, float dt, const float GDT)
{

	int i = blockIdx.x * blockDim.x + threadIdx.x;

	float3 pos_i = p_in.pos[i];
	float4 vel_i = p_in.vel[i];

	//#pragma unroll 128
	for (int j = 0; j < N; j++) {
		// Calculate distance between two points in each axis
		float3 d;
			
		d.x = p_in.pos[j].x - pos_i.x;
		d.y = p_in.pos[j].y - pos_i.y;
		d.z = p_in.pos[j].z - pos_i.z;

		// Calculate vector distance between two points
		float dist_R = d.x * d.x +  d.y*d.y + d.z*d.z + FLT_EPSILON;
		float inv_dist = rsqrtf(dist_R);
		float inv_dist_3R = inv_dist * inv_dist * inv_dist;

		float F = GDT * p_in.vel[j].w * inv_dist_3R;

		vel_i.x = fmaf(F, d.x, vel_i.x);
		vel_i.y = fmaf(F, d.y, vel_i.y);
		vel_i.z = fmaf(F, d.z, vel_i.z);
	}

	__syncthreads();

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
            &p.vel[i].w);
    }
}

void particles_write(FILE *fp, t_particles &p, int N)
{
    for (int i = 0; i < N; i++)
    {
		fprintf(fp, "%10.10f %10.10f %10.10f %10.10f %10.10f %10.10f %10.10f \n",
            p.pos[i].x, p.pos[i].y, p.pos[i].z,
            p.vel[i].x, p.vel[i].y, p.vel[i].z,
            p.vel[i].w);
    }
}
