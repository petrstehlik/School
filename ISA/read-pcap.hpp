/*
 * ISA exporter
 * Super uber cool netflow exporter
 * Author: xstehl14		Petr Stehlik		(c)2015
 *
 * usage: ./isa_exporter -i example.pcap -I 100 -v
 *
 * file: read-pcap.hpp
 */

//C++ libs
#include <iostream>
#include <string>
#include <cstring>
#include <list>
#include <algorithm>
#include <fstream>
#include <chrono>
#include <iomanip>
#include <sstream>
#include <bitset>

//C libs
#include <getopt.h>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <pcap.h>
#include <errno.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netinet/ip.h>
#include <netinet/tcp.h>
#include <netinet/udp.h>
#include <arpa/inet.h>
#include <netinet/if_ether.h> 
#include <err.h>
#include <unistd.h>
#include <sys/sysinfo.h>
#include <netdb.h>

#ifndef PCAP_ERRBUF_SIZE
#define PCAP_ERRBUF_SIZE (256)
#endif

// offset of Ethernet header to L3 protocol
#define SIZE_ETHERNET (14)

 // size of a flow batch to be send to collector
#define MAX_FLOWS (30)

// structure for options
struct opts {
	std::string input = "-";
	int port = 2055;
	std::string ip = "127.0.0.1";
	unsigned int interval = 300;
	unsigned int flows = 50;
	int timeout = 300;
	bool verbose = false;
};

// options structure
extern opts options;

// log file
extern std::ofstream myfile;

// system uptime
extern long double sys_uptime;


class Flow {
	public:
		//V5 FLOW items
		u_int32_t src_ip, dst_ip, nexthop_ip = 0x00;
		u_int16_t if_index_in, if_index_out = 0x00;
		u_int32_t flow_packets, flow_octets = 0x00;
		u_int32_t flow_start, flow_finish = 0x00;
		u_int16_t src_port, dst_port = 0x00;
		u_int8_t pad1 = 0x00;
		u_int8_t tcp_flags, protocol, tos = 0x00;
		u_int16_t src_as, dst_as = 0x00;
		u_int8_t src_mask, dst_mask = 0x00;
		u_int16_t pad2 = 0x00;

		// When the flow started
		time_t start_time;
		u_int32_t time_nanosec;

		// Get current uptime of the exporter
		u_int32_t get_uptime(struct pcap_pkthdr *header);

		// Not nice, but functional!
		// Get pointer to the object
		Flow get_pointer();

		// Check if the same record already exists
		bool check_records(struct ip* my_ip, const struct tcphdr* my_tcp, struct pcap_pkthdr header);

		// Store the packet, method for each type of packet
		void store_packet(struct ip* my_ip, const struct tcphdr* my_tcp, struct pcap_pkthdr header);
		void store_packet(struct ip* my_ip, const struct udphdr* my_udp, struct pcap_pkthdr header);
		void store_packet(struct ip* my_ip, struct pcap_pkthdr header);

		// Print the flow (in verbose mode)		
		void print_flow();
};


class UDP {

	// Items for UDP connection
	int sock;                        // socket descriptor
	int n, i;
	struct sockaddr_in server, from; // address structures of the server and the client
	struct hostent *servent;         // network host entry required by gethostbyname()
	socklen_t len, fromlen;        

	// Netflow V5 header struct
	// Author: softflowd (couldnt find it)
	// Source: https://github.com/exported/softflowd
	struct HEADER {
		u_int16_t version, flows;
		u_int32_t uptime_ms, time_sec, time_nanosec, flow_sequence;
		u_int8_t engine_type, engine_id;
		u_int16_t sampling_interval;
	};

	HEADER hdr;

	// Netflow V5 flow struct
	// Author: softflowd (couldnt find it)
	// Source: https://github.com/exported/softflowd
	struct FLOW {
		u_int32_t src_ip, dst_ip, nexthop_ip;
		u_int16_t if_index_in, if_index_out;
		u_int32_t flow_packets, flow_octets;
		u_int32_t flow_start, flow_finish;
		u_int16_t src_port, dst_port;
		u_int8_t pad1;
		u_int8_t tcp_flags, protocol, tos;
		u_int16_t src_as, dst_as;
		u_int8_t src_mask, dst_mask;
		u_int16_t pad2;
	};

	FLOW flw;

	// Dynamic arrays for structure serialization
	u_int8_t * packet;
	u_int8_t * flows_packet;

	int size_flows_packet = sizeof(struct FLOW) * MAX_FLOWS;
	int size_packet = sizeof(struct HEADER) + size_flows_packet;

	public:
		// create socket and initialize everything needed
		UDP();

		// DESTROY EVERYTHING AND EVERYBODY
		~UDP();

		// Send the created packet of serialized flows
		void send_packet();

		// serialize flow to packet
		void add_flow(Flow flow, int offset);

		// header creation for flow packet
		void create_header(u_int16_t flows_num, u_int32_t flow_seq, Flow flw);

		// reset socket so we can send again
		void reset();

		// uptime for correct times
		u_int32_t get_uptime();
	
};

// Expire current flows in flow cache
void expire(std::list<Flow> *flows, std::list<Flow> *flows_cache, bool single);

// Export flows to collector
void export_flows(std::list<Flow> flows, UDP *socket);

// What it can do...
void printHelp();

// Parse arguments and store them to options struct
void parseArg(int argc, char *argv[]);

// A handful cleaning lady, sorry, facility manager, to close everything needed and exit
void cleanup(int exitcode);
