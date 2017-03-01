CXXFLAGS=-O2 -pedantic -Wall -Wextra -pthread -std=c++11
all: proj1

proj1: main.cpp gif2bmp.cpp
			c++ $< -o $@ $(CXXFLAGS)

clean:
			rm proj1

.PHONY: clean
