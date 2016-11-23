/*
 * Architektura procesoru (ACH 2016)
 * Projekt c. 1 (nbody)
 * Login: xstehl14
 */

#ifndef __NBODY_H__
#define __NBODY_H__

#include <cstdlib>
#include <cstdio>

/* gravitacni konstanta */
#define G 6.67384e-11f

/* struktura castice (hmotneho bodu) */
typedef struct
{
    float pos_x;
    float pos_y;
    float pos_z;
    float vel_x;
    float vel_y;
    float vel_z;
    float weight;
} t_particle;

typedef t_particle t_particles[N];

void particles_simulate(t_particles p);

void particles_read(FILE *fp, t_particles p);

void particles_write(FILE *fp, t_particles p);

#endif /* __NBODY_H__ */
