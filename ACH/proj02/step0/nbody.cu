/*
 * Architektura procesoru (ACH 2016)
 * Projekt c. 2 (cuda)
 * Login: xstehl14
 */

#include <cmath>
#include <cfloat>
#include "nbody.h"

__device__ void particles_pos_dev(t_particles p_out, float dt, int i);

__global__ void particles_simulate(t_particles p_in, t_particles p_out, int N, float dt, const float GDT)
{

	int i = blockIdx.x * blockDim.x + threadIdx.x;

	float3 pos_i = p_in.pos[i];
	float3 d;
	float3 F_i = {0.0f, 0.0f, 0.0f};

	#pragma unroll 128
	for (int j = 0; j < N; j++) {
		// Calculate distance between two points in each axis
		d.x = p_in.pos[j].x - pos_i.x;
		d.y = p_in.pos[j].y - pos_i.y;
		d.z = p_in.pos[j].z - pos_i.z;

		// Calculate vector distance between two points
		float dist_R = rsqrtf(d.x * d.x +  d.y*d.y + d.z*d.z + FLT_EPSILON);
		//float inv_dist = rsqrtf(dist_R);
		float inv_dist_3R = dist_R * dist_R * dist_R;

		float F = GDT * (p_in.vel[j].w) * inv_dist_3R;

		F_i.x = fmaf(F, d.x, F_i.x);
		F_i.y = fmaf(F, d.y, F_i.y);
		F_i.z = fmaf(F, d.z, F_i.z);
	}

	p_out.vel[i].x = p_in.vel[i].x + F_i.x;
	p_out.vel[i].y = p_in.vel[i].y + F_i.y;
	p_out.vel[i].z = p_in.vel[i].z + F_i.z;

	p_out.pos[i].x = fmaf(p_out.vel[i].x,dt, p_in.pos[i].x);
	p_out.pos[i].y = fmaf(p_out.vel[i].y,dt, p_in.pos[i].y);
	p_out.pos[i].z = fmaf(p_out.vel[i].z,dt, p_in.pos[i].z);
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
