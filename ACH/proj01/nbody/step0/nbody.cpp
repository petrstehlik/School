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
	float fx,fy,fz;
	float GDT = G * DT;
	for (int step = 0; step < STEPS; step++) {
		for (int i = 0; i < N; i++) {
			fx = fy = fz = 0.0f;

			for (int j = 0; j < N; j++) {
				if (i != j) {
					// Calculate distance between two points in each axis
					dx = p[j].pos_x - p[i].pos_x;
					dy = p[j].pos_y - p[i].pos_y;
					dz = p[j].pos_z - p[i].pos_z;

					// Calculate vector distance between two points
					float R = sqrt(dx*dx + dy*dy + dz*dz);

					// Calculate force
					float F = (GDT * p[j].weight) / (R * R * R);
					p[i].vel_x += F * dx;
					p[i].vel_y += F * dy;
					p[i].vel_z += F * dz;
				}
			}
			p[i].pos_x += p[i].vel_x * DT;
			p[i].pos_y += p[i].vel_y * DT;
			p[i].pos_z += p[i].vel_z * DT;
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
