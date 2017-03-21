/*
 * PRL Project #2 - Enumeration Sort
 * Author: Petr Stehlik <xstehl14@stud.fit.vutbr.cz>
 * Date: 21/03/2017
 */

#include "es.h"
#include <mpi.h>

using namespace std;

using namespace MPI;

int main(int argc, char **argv)
{
    int cpu_id;     // ID of the current CPU
    int cpu_num;    // Number of CPUs running
    MPI::Status status;
    TReg reg = initRegisters();

    // MPI Initialization
    Init(argc, argv);

    // Measure compute time
    double start = MPI_Wtime();

    cpu_id = COMM_WORLD.Get_rank();
    cpu_num = COMM_WORLD.Get_size();
        int dup = 0;

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

            MPI::COMM_WORLD.Send(&number, 1, MPI_INT, i+1, REG_X);
            MPI::COMM_WORLD.Send(&number, 1, MPI_INT, 1, REG_Y);
        }

        cout << endl;
        fin.close();
    } else {
        // Save the x_i number to the register X
        COMM_WORLD.Recv(&reg.X, 1, MPI_INT, MASTER_CPU, REG_X, status);
        int duplicate = 0;


        for (int i = 1; i < cpu_num; i++) {
            // Receive the y_i-1 value to the register Y
            COMM_WORLD.Recv(&reg.Y, 1, MPI_INT, cpu_id - 1, REG_Y, status);

            if (reg.X != REG_EMPTY && reg.Y != REG_EMPTY) {
                if (reg.X > reg.Y)
                    reg.C++;

                if (reg.X == reg.Y)
                    dup++;
            }

            // Send Y register value to my neighbour
            if (cpu_id != cpu_num - 1)
                COMM_WORLD.Send(&reg.Y, 1, MPI_INT, cpu_id + 1, REG_Y);
        }

        /*for (int i = cpu_id; i < cpu_num; i++) {
            // Receive the y_i-1 value to the register Y
            //COMM_WORLD.Recv(&reg.Y, 1, MPI_INT, cpu_id - 1, REG_Y, status);

            if (reg.X != REG_EMPTY && reg.Y != REG_EMPTY) {
                if (reg.X > reg.Y)
                    reg.C++;
            }

            // Send Y register value to my neighbour
            //if (cpu_id != cpu_num - 1)
                //COMM_WORLD.Send(&reg.Y, 1, MPI_INT, cpu_id + 1, REG_Y);
        }*/
    }

    MPI_Barrier(COMM_WORLD);

    cout << cpu_id << ": REG: " << reg.C << " / " << reg.X << " / " << reg.Y << " / " << reg.Z << "  dup: " << dup << endl;
    MPI_Barrier(COMM_WORLD);

    if (cpu_id != MASTER_CPU) {
        COMM_WORLD.Isend(&reg.X, 1, MPI_INT, reg.C, REG_Z);

        //COMM_WORLD.Bcast(&to_send, 1, MPI_INT, i);
        COMM_WORLD.Irecv(&reg.Z, 1, MPI_INT, MPI_ANY_SOURCE, REG_Z);
    }

    //MPI_Barrier(COMM_WORLD);

    //cout << cpu_id << ": NREG: " << reg.C << "/" << reg.X << "/" << reg.Y << "/" << reg.Z << endl;

    MPI_Barrier(COMM_WORLD);

   for (int i = 1; i < cpu_num; i++) {
        // Master CPU will print the number
        if (cpu_id == MASTER_CPU) {
            COMM_WORLD.Recv(&reg.Z, 1, MPI_INT, 1, REG_Z);
            cout << reg.Z << endl;
        } else {
            COMM_WORLD.Send(&reg.Z, 1, MPI_INT, cpu_id - 1, REG_Z);
        }

        if (cpu_id != MASTER_CPU && cpu_id != cpu_num - 1) {
            COMM_WORLD.Recv(&reg.Z, 1, MPI_INT, cpu_id + 1, REG_Z);
        }
    }

    double end = MPI_Wtime();

    if (cpu_id == MASTER_CPU)
        cout << "Exec time: " << end - start << endl;

    Finalize();
    return 0;
}

TReg initRegisters()
{
    return (TReg) {1, REG_EMPTY, REG_EMPTY, REG_EMPTY};
}
