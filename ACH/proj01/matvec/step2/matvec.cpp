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
	float sum = 0.0f;

	#pragma omp simd reduction(+:sum)
        for (int j = 0; j < cols; j++)
        {
		sum += a[i][j] * b[j];
        }
	c[i] = sum;
    }
}
