/*
 * ISA exporter
 * Super uber cool netflow exporter
 * Author: xstehl14		Petr Stehlik		(c)2015
 *
 * usage: ./isa_exporter -i example.pcap -I 100 -v
 *
 * file: flow.cpp
 *
 * note: all methods' descriptions are in the read-pcap.hpp header file
 */

#include "read-pcap.hpp"

using namespace std;


Flow Flow::get_pointer() {
	return *this;
}


u_int32_t Flow::get_uptime(struct pcap_pkthdr *header) {

    long double tmp_time = header->ts.tv_sec;
    tmp_time = tmp_time*1000 + header->ts.tv_usec/1000;

	return (tmp_time - sys_uptime);
	
}

bool Flow::check_records(struct ip* my_ip, const struct tcphdr* my_tcp, struct pcap_pkthdr header) {
	
	if (this->protocol == my_ip->ip_p &&
		this->src_ip == my_ip->ip_src.s_addr &&
		this->dst_ip == my_ip->ip_dst.s_addr &&
		this->src_port == my_tcp->th_sport &&
		this->dst_port == my_tcp->th_dport &&
		!((this->tcp_flags & TH_FIN) || (this->tcp_flags & TH_RST))
		) {

		if ((header.ts.tv_sec - this->start_time) < options.timeout) {
			
			if (options.verbose)
				myfile  << "==============\nFOUND THE SAME PACKET\n==============" << endl;
			
			// increment packet number
			this->flow_packets += 1;

			// Logical OR of current TCP flags and packet's TCP flags
			this->tcp_flags = (this->tcp_flags | my_tcp->th_flags);

			//Update the flow_finish time
			this->flow_finish = get_uptime(&header);
			
			//Found same packet
			return true;

		} else if (options.verbose) {
			// Print why it wasn't stored
			myfile << "TIMEOUT" << endl;
			myfile << this->start_time << endl;
			myfile << header.ts.tv_sec << endl;
			myfile << (header.ts.tv_sec - this->start_time) << endl;
		}
	
	}

	//Didn't found any similar packet
	return false;
}

void Flow::store_packet(struct ip* my_ip, const struct tcphdr* my_tcp, struct pcap_pkthdr header) {
	//Protocol
	this->protocol = my_ip->ip_p;
	this->tos = my_ip->ip_tos;
	//SRC and DST IP
	this->src_ip = my_ip->ip_src.s_addr;
	this->dst_ip = my_ip->ip_dst.s_addr;
	//Ports
	this->src_port = my_tcp->th_sport;
	this->dst_port = my_tcp->th_dport;
	//TCP Flags
	this->tcp_flags = my_tcp->th_flags;

	this->flow_packets = 1;
	this->flow_octets = header.len;

	this->flow_start = this->flow_finish = get_uptime(&header);
};

void Flow::store_packet(struct ip* my_ip, const struct udphdr* my_udp, struct pcap_pkthdr header) {
	//Proto and TOS
	this->protocol = my_ip->ip_p;
	this->tos = my_ip->ip_tos;
	//IP addresses
	this->src_ip = my_ip->ip_src.s_addr;
	this->dst_ip = my_ip->ip_dst.s_addr;
	//Ports
	this->src_port = my_udp->uh_sport;
	this->dst_port = my_udp->uh_dport;
	//Rest
	this->tcp_flags = 0x00;
	this->flow_packets = 1;
	this->flow_octets = ntohs(my_udp->uh_ulen);

	this->flow_start = this->flow_finish = get_uptime(&header);
};

void Flow::store_packet(struct ip* my_ip, struct pcap_pkthdr header) {
	//Proto and TOS
	this->protocol = my_ip->ip_p;
	this->tos = my_ip->ip_tos;
	//IP addresses
	this->src_ip = my_ip->ip_src.s_addr;
	this->dst_ip = my_ip->ip_dst.s_addr;

	this->src_port = 0x00;
	this->dst_port = 0x00;

	this->tcp_flags = 0x00;
	
	this->flow_packets = 1;
	this->flow_octets = ntohs(my_ip->ip_len);

	this->flow_start = this->flow_finish = get_uptime(&header);
};

void Flow::print_flow() {
	char str[INET_ADDRSTRLEN];

	myfile << "PROTOCOL: " << int(this->protocol) << endl;
	myfile << "SRC IP: " << inet_ntop(AF_INET, &this->src_ip, str, INET_ADDRSTRLEN);

	// Reset the string for storing another IP address
	memset(str, 0, INET_ADDRSTRLEN);

	myfile << "\tDEST IP: " << inet_ntop(AF_INET, &this->dst_ip, str, INET_ADDRSTRLEN) << endl;
	myfile << "SRC PORT: " << int(ntohs(this->src_port)) << "\tDEST PORT: " << int(ntohs(this->dst_port)) << endl;

	// Print TCP flags for TCP packet
	if (htons(this->tcp_flags) != 0)
		myfile << htons(this->tcp_flags) << endl;

	myfile << "Packet Count: " << this->flow_packets << endl << "==========" << endl;
}

