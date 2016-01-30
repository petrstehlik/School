CC=g++

CFLAGS+=-Wall -Wextra -g -DUSE_SLEEP -std=c++11 -o3

LFLAGS+= -lpcap

#CFLAGS+=

#all: read-pcap sniff sniff-filter -lpcap
all: isa_exporter

isa_exporter: *.cpp
	$(CC) $(CFLAGS) $^ -o $@ $(LFLAGS)

clean:
	rm -f *.core core *~ isa_exporter
cln:
	rm -f nfcapd/*
