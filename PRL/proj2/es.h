/*
 * PRL Project #2 - Enumeration Sort
 * Author: Petr Stehlik <xstehl14@stud.fit.vutbr.cz>
 * Date: 21/03/2017
 */

#include <mpi.h>
#include <iostream>
#include <fstream>

#define MASTER_CPU 0

#define REG_X   0
#define REG_Y   1
#define REG_Z   2
#define ORD     3

#define REG_EMPTY (-1)

typedef struct {
    int C;
    int X;
    int Y;
    int Z;
} TReg;

TReg initRegisters()
{
	return (TReg) {1, REG_EMPTY, REG_EMPTY, REG_EMPTY};
};
