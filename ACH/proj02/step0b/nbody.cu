/*
 * Architektura procesoru (ACH 2016)
 * Projekt c. 2 (cuda)
 * Login: xlogin00
 */

#include <cmath>
#include <cfloat>
#include "nbody.h"

__global__ void particles_simulate(t_particles p_in, t_particles p_out, int N, float dt, const float GDT)
{

	int i = blockIdx.x * blockDim.x + threadIdx.x;

	float pos_x_i = p_in.pos_x[i];
	float pos_y_i = p_in.pos_y[i];
	float pos_z_i = p_in.pos_z[i];
	float vel_x_i = p_in.vel_x[i];
	float vel_y_i = p_in.vel_y[i];
	float vel_z_i = p_in.vel_z[i];

	#pragma unroll
	for (int j = 0; j < N; j++) {
		if (i == j)
			continue;
		// Calculate distance between two points in each axis
		float dx = p_in.pos_x[j] - pos_x_i;
		float dy = p_in.pos_y[j] - pos_y_i;
		float dz = p_in.pos_z[j] - pos_z_i;

		// Calculate vector distance between two points
		float dist_R = dx*dx + dy*dy + dz*dz;
		//float dist_R = norm3df(dx,dy,dz);
		float inv_dist = rsqrtf(dist_R);
		float inv_dist_3R = inv_dist * inv_dist * inv_dist;

		float F = (GDT * p_in.weight[j]) * inv_dist_3R;//powf(R, 3);
		//float s = GDT * p_in.weight[j] * inv_dist;

		//vel_x_i = fmaf(F, dx, vel_x_i);
		//vel_y_i = fmaf(F, dx, vel_x_i);
		//vel_z_i = fmaf(F, dx, vel_x_i);

		vel_x_i += F * dx;
		vel_y_i += F * dy;
		vel_z_i += F * dz;

	}

	//__syncthreads();

	p_out.vel_x[i] = vel_x_i;
	p_out.vel_y[i] = vel_y_i;
	p_out.vel_z[i] = vel_z_i;

	//p_out.pos_x[i] += p_out.vel_x[i] * dt;
	//p_out.pos_y[i] += p_out.vel_y[i] * dt;
	//p_out.pos_z[i] += p_out.vel_z[i] * dt;

}

__global__ void particles_pos(t_particles p_out, float dt)
{
	int i = blockIdx.x * blockDim.x + threadIdx.x;
	p_out.pos_x[i] += p_out.vel_x[i] * dt;
	p_out.pos_y[i] += p_out.vel_y[i] * dt;
	p_out.pos_z[i] += p_out.vel_z[i] * dt;
}

void particles_read(FILE *fp, t_particles &p, int N)
{
    for (int i = 0; i < N; i++)
    {
		fscanf(fp, "%f %f %f %f %f %f %f \n",
            &p.pos_x[i], &p.pos_y[i], &p.pos_z[i],
            &p.vel_x[i], &p.vel_y[i], &p.vel_z[i],
            &p.weight[i]);
    }
}

void particles_write(FILE *fp, t_particles &p, int N)
{
    for (int i = 0; i < N; i++)
    {
		fprintf(fp, "%10.10f %10.10f %10.10f %10.10f %10.10f %10.10f %10.10f \n",
            p.pos_x[i], p.pos_y[i], p.pos_z[i],
            p.vel_x[i], p.vel_y[i], p.vel_z[i],
            p.weight[i]);
    }
}
