CC = g++ -std=c++11

all: kry

kry: kry.cpp
	$(CC) -pedantic -Wall -Wextra -O3 -o kry kry.cpp -I/usr/local/include -lgmp -lgmpxx

clean:
	rm kry

