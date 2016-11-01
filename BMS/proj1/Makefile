CC = g++ -std=c++11

all: bms1A bms1B

bms1A: bms1A.cpp
	$(CC) -g -pedantic -Wall -Wextra -O0 -o bms1A bms1A.cpp -L. -lecc

bms1B: bms1B.cpp
	$(CC) -g -pedantic -Wall -Wextra -O0 -o bms1B bms1B.cpp -L. -lecc

subdir:
	$(CC) -o bms1A bms1A.cpp -Lrscode -lecc

genfile:
	dd if=/dev/urandom of=file.bin bs=4096 count=1024

rscode:
	wget http://downloads.sourceforge.net/project/rscode/rscode/1.3/rscode-1.3.tgz
	tar -zxf rscode-1.3.tgz
	make -C rscode-1.3
	cp rscode-1.3/libecc.a rscode-1.3/ecc.h ./
	rm -r rscode-1.3*

clean:
	rm bms1A bms1B
