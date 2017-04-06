/*
 * PRL Project #3 - Mesh multiplication
 * Author: Petr Stehlik <xstehl14@stud.fit.vutbr.cz>
 * Date:
 */

#include "mm.h"

using namespace std;

using namespace MPI;

int main(int argc, char **argv)
{
	string inFile1 = "mat1";
	string inFile2 = "mat2";
	Status status;

	// Get size of matrice
	int dim[2];

	// MPI Initialization
    Init(argc, argv);

    // Get rank of current CPU
    int rank = COMM_WORLD.Get_rank();

    // Get total number of CPUs
    int cpu_num = COMM_WORLD.Get_size();

    if (rank == 0) {

		pair<int, matrix> mat1 = loadMat("mat1");
		pair<int, matrix> mat2 = loadMat("mat2");

		// Fill the dim array (in order to be sendable via MPI)
		dim[0] = mat1.first;
		dim[1] = mat2.first;

		cout << mat1.first << ":" << mat2.first << endl;

		printMatrix(mat1.second);

		COMM_WORLD.Bcast(&dim, 2, MPI_INT, 0);
	} else {
		COMM_WORLD.Bcast(&dim, 2, MPI_INT, 0);

		CPU cpu = CPU(rank, dim[0], dim[1]);

		for (int i = 1; i <= cpu_num; i++)
			if (i == rank)
				cout << rank << " : index -- " << cpu.posX() << ":" << cpu.posY() << endl;
	}

    // Measure compute time
    //double start = Wtime();

    Finalize();

    return 0;
}

/**
  * Load matrix specified by path
  */
pair<int, matrix> loadMat(string file)
{
	ifstream fin(file);
	matrix m;
	int dim = 0;
	int lineNum = 0;
	string line;

	pair<int, matrix> result;

	while(getline(fin, line)) {

		stringstream lineS(line);

		if (lineNum == 0) {
			lineS >> dim;
		}
		else {
			vector<int> l;
			int tmp;
			while (lineS >> tmp) {
				l.push_back(tmp);
			}
			m.push_back(l);
		}
		lineNum++;
	}

	return make_pair(dim, m);
}

/**
  * Print given matrix in specified format
  */
void printMatrix(matrix &m) {
	for (auto row : m) {
		bool first = true;
		for (auto num : row) {
			if (first) {
				cout << num;
				first = false;
			}
			else
				cout << " " << num;
		}

		cout << endl;
	}
}
