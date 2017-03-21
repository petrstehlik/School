#!/bin/bash

if [ $# -lt 1 ]; then
    runs=10;
else
    runs=$1;
fi;


for i in $(seq 1 $runs); do

    R=$((($RANDOM % 20) + 1))

    dd if=/dev/random bs=1 count=$R of=numbers > /dev/null 2>&1

    CPU=$((R+1))

    O=`mpirun --prefix /usr/local/share/OpenMPI -np $CPU es | tail -n+2`
    #T=`time mpirun --prefix /usr/local/share/OpenMPI -np $CPU es`
    #mpirun --prefix /usr/local/share/OpenMPI -np $CPU es | tail -n+2 > out
    #cat out | sort > sout

    SO=`echo "$O" | sort -g`

    #echo "$O"

    D=`diff -w <( echo "$SO" ) <( echo "$O" )`

    if [ -z $D ]; then
        echo "Test: OK"
     #   echo "NUM: $R  TIME: $T"
    else
        echo "Test: ERROR"
        echo "$D"
        echo "$O"
    fi;
done
