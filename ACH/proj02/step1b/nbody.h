/*
 * Architektura procesoru (ACH 2016)
 * Projekt c. 2 (cuda)
 * Login: xstehl14
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
    float4 *pos;
    float3 *vel;
} t_particles;

__global__ void particles_simulate(t_particles p_in, t_particles p_out, const int N, const float dt, const float GDT);

void particles_read(FILE *fp, t_particles &p, int N);

void particles_write(FILE *fp, t_particles &p, int N);

#endif /* __NBODY_H__ */
