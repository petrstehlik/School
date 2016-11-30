/*
 * Architektura procesoru (ACH 2016)
 * Projekt c. 1 (matvec)
 * Login: xstehl14
 */

#include "matvec.h"

void mat_vec_mul(unsigned int rows, unsigned int cols, float** a, float* b, float* c)
{
    for (int i = 0; i < rows; i++)
    {
        c[i] = 0.0f;

        #pragma nounroll
        for (int j = 0; j < cols; j++)
        {
            c[i] += a[i][j] * b[j];
        }
    }
}
