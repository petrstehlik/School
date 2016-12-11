/*
 * Architektura procesoru (ACH 2016)
 * Projekt c. 2 (cuda)
 * Login: xlogin14
 */

#ifndef __NBODY_H__
#define __NBODY_H__

#include <cstdlib>
#include <cstdio>

/* gravitacni konstanta */
#define G 6.67384e-11f

/* struktura castic */
typedef struct
{
	// ZDE DOPLNTE CLENY STRUKTURY CASTIC
    float *pos_x;
    float *pos_y;
    float *pos_z;
    float *vel_x;
    float *vel_y;
    float *vel_z;
    float *weight;

} t_particles;

__global__ void particles_simulate(t_particles p_in, t_particles p_out, int N, float dt, const float GDT);
__global__ void particles_pos(t_particles p_out, float dt);

void particles_read(FILE *fp, t_particles &p, int N);

void particles_write(FILE *fp, t_particles &p, int N);

#endif /* __NBODY_H__ */
