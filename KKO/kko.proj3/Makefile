CXXFLAGS=-pedantic -Wall -Wextra -std=c++11 -lc
all: gif2bmp

gif2bmp: main.cpp gif2bmp.cpp bmp.cpp gif2bmp.h gif.cpp
			c++ gif2bmp.cpp bmp.cpp main.cpp gif.cpp -o $@ $(CXXFLAGS)

debug: CXXFLAGS += -DDEBUG=1 -g -O0
debug: gif2bmp

clean:
			rm gif2bmp

.PHONY: clean
