/*
 * Architektura procesoru (ACH 2016)
 * Projekt c. 1 (matvec)
 * Login: xstehl14
 */

#include "matvec.h"

void mat_vec_mul(unsigned int rows, unsigned int cols, float** a, float* b, float* c)
{
	float sum;

    for (int i = 0; i < rows; i++)
    {
		sum = 0.0f;

		#pragma omp simd reduction(+:sum)
		#pragma unroll(4)
		#pragma vector aligned
        for (int j = 0; j < cols; j++)
        {
			sum += a[i][j] * b[j];
        }
		
		c[i] = sum;
    }
}
