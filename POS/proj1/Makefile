# POS project #1 2017 LS
# Author: xstehl14 Petr Stehlik

CXXFLAGS= -pedantic -Wall -Wextra -lpthread -lc -lrt -std=c11

all: proj1

proj1: proj1.c
		gcc $< -o $@ $(CXXFLAGS) -O2

debug: proj1.c
	gcc $< -o proj1 $(CXXFLAGS) -g -O0 -DDEBUG=1

clean:
		rm proj1

.PHONY: clean

