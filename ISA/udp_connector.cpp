/*
 * ISA exporter
 * Super uber cool netflow exporter
 * Author: xstehl14		Petr Stehlik		(c)2015
 *
 * usage: ./isa_exporter -i example.pcap -I 100 -v
 *
 * file: udp_connector.cpp
 *
 * note: all methods' descriptions are in the read-pcap.hpp header file
 */

#include "read-pcap.hpp"

using namespace std;

UDP::UDP() {
	if (options.verbose)
		myfile << "creating socket" << endl;

	//create dynamic arrays for flow storage
	packet = new (nothrow) u_int8_t[size_packet];
	flows_packet = new (nothrow) u_int8_t[size_flows_packet];

	if (packet == NULL || flows_packet == NULL) {
		err(1, "error allocating dynamic array");
	}

	//init the struct with zeros
	memset(&server, 0, sizeof(server));
	memset(packet, 0, size_packet);
	memset(flows_packet, 0, size_flows_packet);
	memset(&hdr, 0, sizeof(hdr));

	//create a client socket
	if ((sock = socket(AF_INET , SOCK_DGRAM , 0)) == -1)
	    err(1,"socket() failed\n");


	// get ip from hostname
	struct hostent *he;

	if ( (he = gethostbyname(&options.ip[0u]) ) == NULL) {
        err(1, "gethostbyname() failed\n");
    }

	//Fill in the server struct
	server.sin_family = AF_INET;
	server.sin_port = htons(options.port);
	memcpy(&server.sin_addr, he->h_addr, he->h_length);
}

void UDP::add_flow(Flow flow, int offset) {
	flw.src_ip 			= flow.src_ip;
	flw.dst_ip 			= flow.dst_ip;
	flw.nexthop_ip 		= htonl(flow.nexthop_ip);
	flw.if_index_in 	= 0;
	flw.if_index_out 	= 0;
	flw.flow_packets 	= htonl(flow.flow_packets);
	flw.flow_octets 	= htonl(flow.flow_octets);
	flw.flow_start 		= htonl(flow.flow_start);
	flw.flow_finish 	= htonl(flow.flow_finish);
	flw.src_port 		= flow.src_port;
	flw.dst_port 		= flow.dst_port;
	flw.pad1 			= flow.pad1;
	flw.tcp_flags 		= flow.tcp_flags;
	flw.protocol 		= flow.protocol;
	flw.tos 			= flow.tos;
	flw.src_as 			= 0;
	flw.dst_as 			= 0;
	flw.src_mask 		= flow.src_mask;
	flw.dst_mask 		= flow.dst_mask;
	flw.pad2 			= flow.pad2;

	// serialize structure
	memcpy(flows_packet + (offset * sizeof(struct FLOW)), &flw, sizeof(flw));
}

void UDP::send_packet() {
	// copy header to packet
	memcpy(packet, &hdr, sizeof(hdr));

	// copy flows to packet
	memcpy(packet + sizeof(hdr), flows_packet, size_flows_packet);

	i = sendto(sock, packet, size_packet, 0, (struct sockaddr *) &server, sizeof(server));

	// check if data was sent correctly
	if (i == -1)
      	err(1,"sendto() function failed:");
    else if (i != size_packet)
    	err(1,"sendto(): buffer written partially");
}

void UDP::create_header(u_int16_t flows_num, u_int32_t flow_seq, Flow flw) {

	// create header for flow packet
	hdr.version = htons(5);
	hdr.flows = htons(flows_num);
	hdr.uptime_ms = htonl(flw.flow_finish);//0;//htonl(get_uptime() + (tp.tv_usec));
	hdr.time_sec = htonl((flw.flow_finish + sys_uptime)/1000);
	hdr.time_nanosec = htonl((flw.flow_finish + sys_uptime)*1000);
	hdr.flow_sequence = htonl(flow_seq);
	hdr.engine_type = 0x2A;		//answer to everything, in hex!
	hdr.engine_id = 0x2A;
	hdr.sampling_interval = htons((0x01 << 14) | (1 & 0x3FFF));

}

void UDP::reset() {
	// set everything to zero
	memset(packet, 0, size_packet);
	memset(flows_packet, 0, size_flows_packet);
	memset(&hdr, 0, sizeof(hdr));
}

UDP::~UDP() {
	delete packet;
	delete flows_packet;
	close(sock);
	if (options.verbose)
		myfile << "closing socket" << endl;
}