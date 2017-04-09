#!/bin/bash

function printhelp {
	echo -e "Enumeration sort algoritm implementation\nUsage: ./bash [n] where n is number > 1 (default 10)"
}

#pocet cisel bud zadam nebo 10 :)
if [ $# -lt 1 ]; then
    numbers=10;
else
    numbers=$1;

    if [ $numbers -lt 1 ]; then
		printhelp
		exit 1
	fi;
fi;

# preklad cpp zdrojaku
mpic++ --prefix /usr/local/share/OpenMPI -o es es.cpp

# vyrobeni souboru s random cisly
dd if=/dev/random bs=1 count=$numbers of=numbers > /dev/null 2>&1

# spusteni
mpirun --prefix /usr/local/share/OpenMPI -np $((numbers+1)) es

# uklid
rm -f es numbers
