CC = g++ -std=c++11

all: bms1A

bms1A: bms1A.cpp
	$(CC) -o bms1A bms1A.cpp -L. -lecc

subdir:
	$(CC) -o bms1A bms1A.cpp -Lrscode -lecc

genfile:
	dd if=/dev/urandom of=file.bin bs=4096 count=1024

clean:
	rm bms1A
