/*
 * Architektura procesoru (ACH 2016)
 * Projekt c. 1 (nbody)
 * Login: xstehl14
 */

#include <cfloat>
#include <cmath>
#include <cstring>
#include "nbody.h"

void particles_simulate(t_particles &p)
{
	float __declspec(align(32)) F_x[N];
	float __declspec(align(32)) F_y[N];
	float __declspec(align(32)) F_z[N];
	float R, F;
	float vel_x_i, vel_y_i, vel_z_i;

	float dx, dy, dz;
	const float GDT = G * DT;

	for (int n = 0; n < STEPS; n++) {
		// Initialization
		memset(F_x, 0, N*sizeof(float));
		memset(F_y, 0, N*sizeof(float));
		memset(F_z, 0, N*sizeof(float));

		for (int i = 0; i < N; i++) {
			vel_x_i = vel_y_i = vel_z_i =  0.0f;

			#pragma omp simd reduction(+:vel_x_i,vel_y_i,vel_z_i) aligned(F_x:32, F_y:32, F_z:32)
			for (int j = i + 1; j < N; j++) {
				// Calculate distance between two points in each axis
				dx = p.pos_x[j] - p.pos_x[i];
				dy = p.pos_y[j] - p.pos_y[i];
				dz = p.pos_z[j] - p.pos_z[i];

				// Calculate vector distance between two points
				R = sqrtf(dx*dx + dy*dy + dz*dz);

				F = (GDT * p.weight[j]) / (R * R * R);

				vel_x_i += F * dx;
				vel_y_i += F * dy;
				vel_z_i += F * dz;

				F_x[j] -= F * dx;
				F_y[j] -= F * dy;
				F_z[j] -= F * dz;
			}

			F_x[i] = vel_x_i;
			F_y[i] = vel_y_i;
			F_z[i] = vel_z_i;
		}

		#pragma omp simd
		#pragma vector aligned
		for (int i = 0; i < N; i++) {
			p.vel_x[i] += F_x[i];
			p.vel_y[i] += F_y[i];
			p.vel_z[i] += F_z[i];

			p.pos_x[i] += p.vel_x[i] * DT;
			p.pos_y[i] += p.vel_y[i] * DT;
			p.pos_z[i] += p.vel_z[i] * DT;

		}
	}
}

void particles_read(FILE *fp, t_particles &p)
{
    for (int i = 0; i < N; i++)
    {
        fscanf(fp, "%f %f %f %f %f %f %f \n",
            &p.pos_x[i], &p.pos_y[i], &p.pos_z[i],
            &p.vel_x[i], &p.vel_y[i], &p.vel_z[i],
            &p.weight[i]);
    }
}

void particles_write(FILE *fp, t_particles &p)
{
    for (int i = 0; i < N; i++)
    {
        fprintf(fp, "%10.10f %10.10f %10.10f %10.10f %10.10f %10.10f %10.10f \n",
            p.pos_x[i], p.pos_y[i], p.pos_z[i],
            p.vel_x[i], p.vel_y[i], p.vel_z[i],
            p.weight[i]);
    }
}
