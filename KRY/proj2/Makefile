CC = g++ -std=c++11

all: kry

kry: kry.cpp
	$(CC) -g -Wall -Wextra -O2 -o kry kry.cpp -I/usr/local/include -lgmp -lgmpxx

clean:
	rm kry