/*
 * PRL Project #3 - Mesh multiplication
 * Author: Petr Stehlik <xstehl14@stud.fit.vutbr.cz>
 * Date:
 */

#include <mpi.h>
#include <iostream>
#include <fstream>
#include <vector>
#include <string>
#include <sstream>


typedef struct {
	int x;
	int y;
} PosT;

#define ROW 0
#define COL 1
#define RES 2
#define TIME 3

typedef std::vector<std::vector<int>> matrix;

class CPU
{
public:
	int rank, m, k;
	PosT pos;

	CPU(int rank, int m, int k)
	{
		this->rank = rank;
		this->m = m;
		this->k = k;

		this->pos.x = (rank / k);
		this->pos.y = (rank % k);
	}

	int posX()
	{
		return this->pos.x;
	}

	int posY()
	{
		return this->pos.y;
	}

    // Calculate left neighbor rank
	int leftCPU() {
	    if (this->pos.y == 0)
	        return 0;
        else
            return (this->rank - 1);
	}

	int rightCPU() {
	    if (this->pos.y == this->k - 1)
	        return -1;
        else
            return (this->rank + 1);
	}

    // Calculate rank of CPU above me
	int topCPU() {
	    if (this->pos.x == 0)
	        return 0;
        else
            return (this->rank - this->k);
	}

    // Calculate rank of CPU below me
	int bottomCPU() {
	    if (this->pos.x == this->m - 1)
	        return -1;
        else
            return (this->rank + this->k);
	}
};

std::pair<int, matrix> loadMat(std::string file);
void printMatrix(matrix &m);
