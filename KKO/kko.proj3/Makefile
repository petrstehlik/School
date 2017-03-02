CXXFLAGS=-pedantic -Wall -Wextra -std=c++11 -g -lc
all: proj1

proj1: main.cpp gif2bmp.cpp gif2bmp.h
			c++ gif2bmp.cpp main.cpp -o $@ $(CXXFLAGS)

clean:
			rm proj1

.PHONY: clean
