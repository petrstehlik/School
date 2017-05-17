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
	pair<int, matrix> mat1;
	pair<int, matrix> mat2;
	CPU *cpu;

	int row_num, col_num;
	int sum = 0;

    double start;

	// Sizes of matrices
	int dim1[2];
	int dim2[2];
	int error = 0;

	// MPI Initialization
    Init(argc, argv);

    // Get rank of current CPU
    int rank = COMM_WORLD.Get_rank();

    // Get total number of CPUs
    int cpu_num = COMM_WORLD.Get_size();

    // The first processor will control IO
    if (rank == 0) {
        try {
            mat1 = loadMat("mat1");
            mat2 = loadMat("mat2");
        } catch (const runtime_error& e ) {
            cerr << e.what() << endl;
            error = 1;
            COMM_WORLD.Bcast(&error, 1, MPI_INT, 0);
            Finalize();
            return 1;
        }

		// Fill the dim arrays (in order to be sendable via MPI)
		dim1[0] = mat1.second[0].size();
		dim1[1] = mat1.first;
		dim2[0] = mat2.first;
		dim2[1] = mat2.second.size();

        if (!checkMatrix(mat1.second, dim1)
                || !checkMatrix(mat2.second, dim2)
                || dim1[0] != dim2[1]) {
            error = 1;
            COMM_WORLD.Bcast(&error, 1, MPI_INT, 0);
            cerr << "Sizes of matrices are not correct" << endl;
	        Finalize();
	        return 1;
	    }

		cpu = new CPU(rank, dim1[1], dim2[0]);

        COMM_WORLD.Bcast(&error, 1, MPI_INT, 0);
		COMM_WORLD.Bcast(&dim1, 2, MPI_INT, 0);
		COMM_WORLD.Bcast(&dim2, 2, MPI_INT, 0);
	} else {
        COMM_WORLD.Bcast(&error, 1, MPI_INT, 0);

        if (error != 0) {
            Finalize();
            return 1;
	    }

	    // Receive the final matrix size
		COMM_WORLD.Bcast(&dim1, 2, MPI_INT, 0);
		COMM_WORLD.Bcast(&dim2, 2, MPI_INT, 0);

        cpu = new CPU(rank, dim1[1], dim2[0]);
	}

	COMM_WORLD.Barrier();

	if (cpu->rank == 0) {
	    // Send a column of first matrix
	    for(int i = 0; i < dim1[1]; i++) {
	        int mat1_w = dim1[0];
	        for (int j = 0; j < dim1[0]; j++) {
	            COMM_WORLD.Isend(&mat1.second[i][j], 1, MPI_INT, (i % dim1[1]) * dim2[0], ROW);
            }
	    }

	    for (int i = 0; i < dim2[0]; i++) {
	        for (int j = 0; j < dim2[1]; j++) {
	            COMM_WORLD.Isend(&mat2.second[j][i], 1, MPI_INT, i, COL);
            }
	    }
	}

	COMM_WORLD.Barrier();

    start = Wtime();

    // Receive from left
	for (int i = 0; i < dim1[0]; i++) {
        COMM_WORLD.Recv(&row_num, 1, MPI_INT, cpu->leftCPU(), ROW);
        COMM_WORLD.Recv(&col_num, 1, MPI_INT, cpu->topCPU(), COL);

        sum += row_num * col_num;

        // Send the numbers to neighbours
        if (cpu->rightCPU() >= 0)
            COMM_WORLD.Isend(&row_num, 1, MPI_INT, cpu->rightCPU(), ROW);

        if (cpu->bottomCPU() >= 0)
            COMM_WORLD.Isend(&col_num, 1, MPI_INT, cpu->bottomCPU(), COL);
    }

    //if (cpu->rank == 0) {
    //    cout << setprecision(10) << fixed;
    double time = MPI_Wtime() - start;
    COMM_WORLD.Send(&time, 1, MPI_DOUBLE, 0, TIME);
    //}

    COMM_WORLD.Send(&sum, 1, MPI_INT, 0, RES);

    if (cpu->rank == 0) {
        cout << dim1[1] << ":" << dim2[0] << endl;
        double avg_time = 0.0;
        double tmp_time = 0.0;

        for (int i = 0; i < cpu_num; i++) {
            int res = 0;

            COMM_WORLD.Recv(&res, 1, MPI_INT, i, RES);

            if (i % dim2[0] == dim2[0] - 1 )
                cout << res << endl;
            else
                cout << res << " ";

            COMM_WORLD.Recv(&tmp_time, 1, MPI_DOUBLE, i, TIME);
            avg_time += tmp_time;
        }

        //cout << setprecision(10) << fixed;
        //cout << avg_time/(double)cpu_num << endl;
    }

    // Cleanup
    delete cpu;

    Finalize();

    return 0;
}

bool checkMatrix(matrix &m, int *dim) {
    if (dim[0] == 0 || dim[1] == 0)
        return false;

    // Check number of elements in each row
    for (auto it : m) {
        if (it.size() != dim[0])
            return false;
    }

    if (m.size() != dim[1])
        return false;

    return true;
}

/**
  * Load matrix specified by path
  */
pair<int, matrix> loadMat(string file)
{
	ifstream fin(file);

	if (fin.fail())
	    throw runtime_error("File '" + file + "' can't be opened");

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
			while (lineS.good() && lineS >> tmp) {
				l.push_back(tmp);
			}
			m.push_back(l);
		}
		lineNum++;
	}

	fin.close();

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
