#!/bin/bash

# Number of test runs
if [ $# -lt 1 ]; then
    runs=10;
else
    runs=$1;
fi;

# Number of numbers (I don't know why I named it R...)
if [ $# -lt 2 ]; then
    R=-1;
else
    R=$2;
fi;

AVGT=0

for i in $(seq 1 $runs); do

    # This number depends on `ulimit -n` setting
    if [ $R -lt 0 ]; then
        R=$((($RANDOM % 199) + 1))
    fi;

    # Generate new numbers file
    dd if=/dev/random bs=1 count=$R of=numbers > /dev/null 2>&1

    # Calculate number of CPUs
    CPU=$((R+1))

    # Run the enumeration sort ommiting the first parsed values
    O=`mpirun --prefix /usr/local/share/OpenMPI -np $CPU es | tail -n+2`

    # Get execution time
    RTIME=`echo "$O" | tail -n1`
    AVGT=`bc -l <<< "$AVGT + $RTIME"`

    # Remove the last line with time measurement
    # normally head -n -1 works but on macOS we need to reverse, tail it,
    # and reverse it again
    O=`echo $O | tail -r | tail -n +2 | tail -r`

    # Sort output via bash
    SO=`echo "$O" | sort -g`

    # Check if anything changed after sorting
    D=`diff -w <( echo "$SO" ) <( echo "$O" )`

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


bc -l <<< "$AVGT/$runs"
