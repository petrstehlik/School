#!/usr/bin/env bash

# Author: Petr Stehlik
# Description: This script runs through available tests in testfiles folder
#
# You must set the correct number of tests!

# Colors for colorful output
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

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
    echo "# Script output:"
    ../simplify-bkg -${ALG} testfiles/${TESTNO}-test.in
    echo -e "\n# Correct result"

    if [ ${ALG} == "i" ]; then
        cat testfiles/${TESTNO}-test.in
    else
        cat testfiles/${TESTNO}-test-${ALG}.out
    fi
    echo -e "${CYAN}~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${NC}"
done
