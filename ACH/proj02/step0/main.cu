/*
 * Architektura procesoru (ACH 2016)
 * Projekt c. 2 (cuda)
 * Login: xlogin00
 */

#include <sys/time.h>
#include <cstdio>
#include <cmath>

#include "nbody.h"

int main(int argc, char **argv)
{
    FILE *fp;
    struct timeval t1, t2;
    int N;
    float dt;
    int steps;
    int thr_blc;

    // parametry
    if (argc != 7)
    {
        printf("Usage: nbody <N> <dt> <steps> <thr/blc> <input> <output>\n");
        exit(1);
    }
    N = atoi(argv[1]);
    dt = atof(argv[2]);
    steps = atoi(argv[3]);
    thr_blc = atoi(argv[4]);

    printf("N: %d\n", N);
    printf("dt: %f\n", dt);
    printf("steps: %d\n", steps);
    printf("threads/block: %d\n", thr_blc);

    // alokace pameti na CPU
    t_particles particles_cpu;
    // ZDE DOPLNTE ALOKACI PAMETI NA CPU

    // nacteni castic ze souboru
    fp = fopen(argv[5], "r");
    if (fp == NULL)
    {
        printf("Can't open file %s!\n", argv[2]);
        exit(1);
    }
    particles_read(fp, particles_cpu, N);
    fclose(fp);

    t_particles particles_gpu[2];
    for (int i = 0; i < 2; i++)
    {
        // alokace pameti na GPU
        // ZDE DOPLNTE ALOKACI PAMETI NA GPU

        // kopirovani castic na GPU
        // ZDE DOPLNTE KOPIROVANI DAT Z CPU NA GPU
    }

    // vypocet
    gettimeofday(&t1, 0);
    for (int s = 0; s < steps; s++)
    {
        // ZDE DOPLNTE SPUSTENI KERNELU
    }
    // ZDE DOPLNTE SYNCHRONIZACI
    gettimeofday(&t2, 0);

    // cas
    double t = (1000000.0 * (t2.tv_sec - t1.tv_sec) + t2.tv_usec - t1.tv_usec) / 1000000.0;
    printf("Time: %f s\n", t);

    // kpirovani castic zpet na CPU
    // ZDE DOPLNTE KOPIROVANI DAT Z GPU NA CPU

    // ulozeni castic do souboru
    fp = fopen(argv[6], "w");
    if (fp == NULL)
    {
        printf("Can't open file %s!\n", argv[6]);
        exit(1);
    }
    particles_write(fp, particles_cpu, N);
    fclose(fp);

    return 0;
}
