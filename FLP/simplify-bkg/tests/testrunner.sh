#!/usr/bin/env bash

# Author: Petr Stehlik
# Description: This script runs through available tests in testfiles folder
#
# You must set the correct number of tests!

# Colors for colorful output
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0;m'

# This
TESTCOUNT=`ls -l testfiles/*.in | wc -l`

if [ -z $1 ]; then
    echo "Warn: no param was set, setting it to \"2\""
    ALG=2
else
    ALG=$1
fi

for TESTNO in $(seq 1 ${TESTCOUNT}); do
    echo -e "\n${GREEN}### TEST No. ${TESTNO} ###${NC}"
    echo "# Script output: ../simplify-bkg -${ALG} testfiles/${TESTNO}-test.in"
    OUT=`../simplify-bkg -${ALG} testfiles/${TESTNO}-test.in`
	echo -e "${OUT}"
    echo -e "\n# Correct result"

    if [ ${ALG} == "i" ]; then
        CAT=`cat testfiles/${TESTNO}-test.in`
    else
        CAT=`cat testfiles/${TESTNO}-test-${ALG}.out`
    fi

	echo -e "${CAT}"

	DIF=`diff <(echo ${OUT}) <(echo ${CAT})`

	if [ -z "$DIF" ]; then
		echo -e "Result:$GREEN OK $NC"
	else
		echo -e "Result:$RED diff not passed but can be correct$NC"
		echo -e "${DIF}"
	fi
    echo -e "${CYAN}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
done
