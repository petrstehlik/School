CXXFLAGS=-O0 -g -pedantic -Wall -Wextra -pthread -ansi#-std=c99

SRC=proj2.c parser.c

all: proj2 parser pidlist
	gcc proj2.o parser.o pidlist.o -o proj2

proj2: proj2.c parser.c proj2.h parser.h
	gcc -c proj2.c $(CXXFLAGS)

parser: parser.c
	gcc -c parser.c $(CXXFLAGS)

pidlist: pidlist.c
	gcc -c pidlist.c $(CXXFLAGS)

clean:
	rm proj2 proj2.o parser.o

.PHONY: clean

