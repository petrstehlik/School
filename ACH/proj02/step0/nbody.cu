/*
 * Architektura procesoru (ACH 2016)
 * Projekt c. 2 (cuda)
 * Login: xlogin00
 */

#include <cmath>
#include <cfloat>
#include "nbody.h"

__global__ void particles_simulate(t_particles p_in, t_particles p_out, int N, float dt)
{
    // ZDE DOPLNTE TELO KERNELU
}

void particles_read(FILE *fp, t_particles &p, int N)
{
    for (int i = 0; i < N; i++)
    {
        fscanf(fp, "%f %f %f %f %f %f %f \n",
            // ZDE DOPLNTE NACTENI JEDNE CASTICE
    }
}

void particles_write(FILE *fp, t_particles &p, int N)
{
    for (int i = 0; i < N; i++)
    {
        fprintf(fp, "%10.10f %10.10f %10.10f %10.10f %10.10f %10.10f %10.10f \n",
            // ZDE DOPLNTE VYPSANI JEDNE CASTICE
    }
}
