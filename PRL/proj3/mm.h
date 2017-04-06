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

		this->pos.x = (rank % m);
		// TODO: this index is wrong
		this->pos.y = (rank % k) + this->pos.x;
	}

	int posX()
	{
		return this->pos.x;
	}

	int posY()
	{
		return this->pos.y;
	}
};

std::pair<int, matrix> loadMat(std::string file);
void printMatrix(matrix &m);
