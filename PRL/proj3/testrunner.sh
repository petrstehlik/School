#!/bin/bash

# Number of test runs
if [ $# -lt 1 ]; then
    runs=10;
else
    runs=$1;
fi;

# Size of matrices
if [ $# -lt 2 ]; then
    mat_size=5;
else
    mat_size=$2;
fi;

AVGT=0.0

mpic++ --prefix /usr/local/share/OpenMPI -o mm mm.cpp -std=c++0x

for i in $(seq 1 $runs); do

    # Generate new matN files
    python genmat.py $mat_size

    # Calculate number of CPUs
    mat1=$(head -n1 mat1)
    mat2=$(head -n1 mat2)
    cpus=$((mat1*mat2))

    # Run the mesh multiplication
    O=`mpirun --prefix /usr/local/share/OpenMPI -np $cpus mm > tmp`

    #echo -e $O

    O=`cat tmp`

    # Get execution time
    RTIME=`echo "$O" | tail -n 1`
    AVGT=`bc -l <<< "$AVGT + $RTIME"`

    # Remove the last line with time measurement
    # normally head -n -1 works but on macOS we need to reverse, tail it,
    # and reverse it again
    O=`cat tmp | tail -r | tail -n +2 | tail -r`

    # Sort output via bash
    SO=`cat res`

    #echo $SO
    #echo $O

    # Check if anything changed after sorting
    D=`diff -w <(echo $SO) <(echo $O)`

    # Check if diff produced anything, if so it means an error
    if [ -z $D ]; then
        printf "Test [%03d/%03d]: OK \t" $i $runs
        echo "Time: $RTIME s ($R)"
    else
        echo "Test [$i/$runs]: ERROR"
        echo "$D"
        echo "$O"
    fi;
done

rm tmp res mat1 mat2 mm


bc -l <<< "$AVGT/$runs"
