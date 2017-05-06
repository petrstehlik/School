CXXFLAGS=-pedantic -Wall -Wextra -std=c++11 -lc
all: proj1

proj1: main.cpp gif2bmp.cpp bmp.cpp gif2bmp.h
			c++ gif2bmp.cpp bmp.cpp main.cpp -o $@ $(CXXFLAGS)

debug: CXXFLAGS += -DDEBUG=1 -g -O0
debug: proj1

clean:
			rm proj1

.PHONY: clean
