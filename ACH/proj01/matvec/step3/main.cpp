/*
 * Architektura procesoru (ACH 2016)
 * Projekt c. 1 (matvec)
 * Login: xstehl14
 */

#include <cstdio>
#include <cmath>
#include <xmmintrin.h>

#include "matvec.h"
#include "papi_cntr.h"

#define COLWIDTH  (COLS + PADDING)

void mat_init(int row, int col, float off, float** a)
{
    for (int i = 0; i < row; i++)
        for (int j = 0; j < col; j++)
            a[i][j] = fmod(i * j + off, 10.0);

    if (PADDING > 0) // optional padding
        for  (int i = 0; i < row; i++)
            for (int j = col; j < COLWIDTH; j++)
                a[i][j] = 0.0;
}

void vec_init(int length, float off, float* a)
{
    for (int i = 0; i < length; i++)
        a[i] = fmod(i + off, 10.0);

    if (PADDING > 0) // optional padding
        for  (int i = length; i < COLWIDTH; i++)
            a[i] = 0.0;
}

double vec_sum(int length, float* vec)
{
    double sum = 0.0;

    for (int i = 0; i < length; i++)
        sum += vec[i];

    return sum;
}

int main(int argc, char **argv)
{
    PapiCounterList papi_routines;
    papi_routines.AddRoutine("mat_vec_mul");

    float* a[ROWS];
    float* b;
    float c[ROWS] = { 0.0 };

    for (int i = 0; i < ROWS; i++)
        a[i] = static_cast<float*>(_mm_malloc(COLWIDTH * sizeof(float), 32));
    b = static_cast<float*>(_mm_malloc(COLWIDTH * sizeof(float), 32));

    printf("rows: %d\n", ROWS);
    printf("cols: %d\n", COLS);
    printf("padding: %d\n", PADDING);

    // initialize matrix & vector
    mat_init(ROWS, COLS, 1.0, a);
    vec_init(COLS, 3.0, b);

    // do the measurement
    papi_routines["mat_vec_mul"].Start();
    for (int i = 0; i < RUNS; i++)
        mat_vec_mul(ROWS, COLWIDTH, a, b, c);
    papi_routines["mat_vec_mul"].Stop();

    // print results
    printf("control sum: %f\n", vec_sum(ROWS, c));
    printf("\n");
    papi_routines.PrintScreen();

    for (int i = 0; i < ROWS; i++)
        _mm_free(a[i]);
    _mm_free(b);

    return 0;
}
