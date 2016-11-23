/*
 * Architektura procesoru (ACH 2016)
 * Projekt c. 1 (nbody)
 * Login: xstehl14
 */

#include <cfloat>
#include <cmath>
#include "nbody.h"

void particles_simulate(t_particles p)
{
	float dx, dy, dz;
	float vel_x, vel_y, vel_z;
	float pos_x, pos_y, pos_z;
	float F, R;
	const float GDT = G * DT;

	for (int step = 0; step < STEPS; step++) {
		#pragma omp simd reduction(+:pos_x,pos_y,pos_z) 
		#pragma vector aligned
		for (int i = 0; i < N; i++) {
			vel_x = p[i].vel_x;
			vel_y = p[i].vel_y;
			vel_z = p[i].vel_z;

			pos_x = p[i].pos_x;
			pos_y = p[i].pos_y;
			pos_z = p[i].pos_z;

			#pragma omp simd reduction(+:vel_x,vel_y,vel_z)
			#pragma vector aligned
			for (int j = 0; j < N; j++) {
				if (i == j) {
					continue;
				}
				// Calculate distance between two points in each axis
				dx = p[j].pos_x - pos_x;
				dy = p[j].pos_y - pos_y;
				dz = p[j].pos_z - pos_z;

				// Calculate vector distance between two points
				R = sqrtf(dx*dx + dy*dy + dz*dz);

				// Calculate force
				F = (GDT * p[j].weight) / (R * R * R);
				vel_x += F * dx;
				vel_y += F * dy;
				vel_z += F * dz;
			}

			p[i].vel_x = vel_x;
			p[i].vel_y = vel_y;
			p[i].vel_z = vel_z;

			pos_x += vel_x * DT;
			pos_y += vel_y * DT;
			pos_z += vel_z * DT;

			p[i].pos_x = pos_x;
			p[i].pos_y = pos_y;
			p[i].pos_z = pos_z;
		}
	}

}

void particles_read(FILE *fp, t_particles p)
{
    for (int i = 0; i < N; i++)
    {
        fscanf(fp, "%f %f %f %f %f %f %f \n",
            &p[i].pos_x, &p[i].pos_y, &p[i].pos_z,
            &p[i].vel_x, &p[i].vel_y, &p[i].vel_z,
            &p[i].weight);
    }
}

void particles_write(FILE *fp, t_particles p)
{
    for (int i = 0; i < N; i++)
    {
        fprintf(fp, "%10.10f %10.10f %10.10f %10.10f %10.10f %10.10f %10.10f \n",
            p[i].pos_x, p[i].pos_y, p[i].pos_z,
            p[i].vel_x, p[i].vel_y, p[i].vel_z,
            p[i].weight);
    }
}
