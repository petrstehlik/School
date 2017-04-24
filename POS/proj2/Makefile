CXXFLAGS=-O2 -pedantic -Wall -Wextra -pthread -std=c99

SRC=proj2.c parser.c

all: proj2 parser
	gcc proj2.o parser.o -o proj2

proj2: proj2.c parser.c proj2.h parser.h
	gcc -c proj2.c $(CXXFLAGS)

parser: parser.c
	gcc -c parser.c $(CXXFLAGS)

clean:
	rm proj2 proj2.o parser.o

.PHONY: clean

