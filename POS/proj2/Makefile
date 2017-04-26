CXXFLAGS=-O0 -g -pedantic -Wall -Wextra -pthread -std=c99
CFLAGS=-Wall -Wextra -pedantic -pthread -std=c99

SRC=proj2.c parser.c

all: proj2.c parser.c pidlist.c
	gcc proj2.c parser.c pidlist.c -o proj2 $(CFLAGS)

part: proj2 parser pidlist
	gcc proj2.o parser.o pidlist.o -o proj2 $(CXXFLAGS)

proj2: proj2.c parser.c proj2.h parser.h
	gcc -c proj2.c $(CXXFLAGS)

parser: parser.c
	gcc -c parser.c $(CXXFLAGS)

pidlist: pidlist.c
	gcc -c pidlist.c $(CXXFLAGS)

clean:
	rm -f proj2 proj2.o parser.o

.PHONY: clean

