/*
 * PRL Project #2 - Enumeration Sort
 * Author: Petr Stehlik <xstehl14@stud.fit.vutbr.cz>
 * Date: 21/03/2017
 */

#include "es.h"

using namespace std;

using namespace MPI;

int main(int argc, char **argv)
{
    int cpu_id;     // ID of the current CPU
    int cpu_num;    // Number of CPUs running
    Status status;  // Status struct for Send and Recv
    TReg reg = initRegisters();

    // MPI Initialization
    Init(argc, argv);

    // Measure compute time
    double start = Wtime();

	// Get rank of current CPU
    cpu_id = COMM_WORLD.Get_rank();

    // Get total number of CPUs
    cpu_num = COMM_WORLD.Get_size();

    // CPU with ID 0 loads the numbers file
    if (cpu_id == 0) {
        char input[] = "numbers";
        int number;

        fstream fin;
        fin.open(input, ios::in);

        for (int i = 0; i < (cpu_num-1) && fin.good(); i++) {
            number = fin.get();

            if (i == 0)
                cout << number;
            else {
                cout << " " << number;
            }

			// Send read number to i-th CPU
            COMM_WORLD.Send(&number, 1, MPI_INT, i+1, REG_X);

            // Send read number and its index to 1st CPU
            COMM_WORLD.Send(&number, 1, MPI_INT, 1, REG_Y);
            COMM_WORLD.Send(&i, 1, MPI_INT, 1, ORD);
        }

        cout << endl;
        fin.close();
    } else {
        // Save the x_i number to the register X
        COMM_WORLD.Recv(&reg.X, 1, MPI_INT, MASTER_CPU, REG_X, status);
        int duplicate = 0;	// How many duplicates is there
        int j = REG_EMPTY;	// tmp register, holds the Y number's index

        for (int i = 1; i < cpu_num; i++) {
            // Receive the y_i-1 value to the register Y...
            COMM_WORLD.Recv(&reg.Y, 1, MPI_INT, cpu_id - 1, REG_Y, status);
			// ...and its index
            COMM_WORLD.Recv(&j, 1, MPI_INT, cpu_id - 1, ORD, status);

			// The comparison algorithm
            if (reg.X != REG_EMPTY && reg.Y != REG_EMPTY) {
				// Original check
                if (reg.X > reg.Y)
                    reg.C++;

				// Check duplicities
                if (reg.X == reg.Y) {
                    dup++;

					// We will always have at least one duplicity
					// when we compare the same numbers.
					// Otherwise we will have a real duplicity
                    if (dup > 1) {
                        if (j < cpu_id)
                            reg.C++;
                    }
                }
            }

            // Send Y register value and its index to my neighbour
            if (cpu_id != cpu_num - 1) {
                COMM_WORLD.Send(&reg.Y, 1, MPI_INT, cpu_id + 1, REG_Y);
                COMM_WORLD.Send(&j, 1, MPI_INT, cpu_id + 1, ORD);
            }
        }
    }

	// We must wait for all CPUs to finish comparisons
    MPI_Barrier(COMM_WORLD);

	// Set register Z values (async)
    if (cpu_id != MASTER_CPU) {
        COMM_WORLD.Isend(&reg.X, 1, MPI_INT, reg.C, REG_Z);
        COMM_WORLD.Irecv(&reg.Z, 1, MPI_INT, MPI_ANY_SOURCE, REG_Z);
    }

	// Everyone has the correct number now
    MPI_Barrier(COMM_WORLD);

	for (int i = 1; i < cpu_num; i++) {
		// Master CPU will print the number
        if (cpu_id == MASTER_CPU) {
            COMM_WORLD.Recv(&reg.Z, 1, MPI_INT, 1, REG_Z);
            cout << reg.Z << endl;
        } else {
        	// Shift the z number to lower neighbour
            COMM_WORLD.Send(&reg.Z, 1, MPI_INT, cpu_id - 1, REG_Z);
        }

        if (cpu_id != MASTER_CPU && cpu_id != cpu_num - 1) {
        	// Accept the shifting
            COMM_WORLD.Recv(&reg.Z, 1, MPI_INT, cpu_id + 1, REG_Z);
        }
    }

    double end = MPI_Wtime();

    if (cpu_id == MASTER_CPU)
        cout << end - start << endl;

    Finalize();
    return 0;
}
