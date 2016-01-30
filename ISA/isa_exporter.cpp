/*
 * ISA exporter
 * Super uber cool netflow exporter
 * Author: xstehl14		Petr Stehlik		(c)2015
 *
 * usage: ./isa_exporter -i example.pcap -I 100 -v
 *
 * file: isa_exporter.cpp
 */

#include "read-pcap.hpp"

using namespace std;

opts options;
ofstream myfile;
long double sys_uptime;
int i, seq = 0;

int main(int argc, char *argv[]) {
	
	// start the clock so we can measure runtime
	unsigned t0=clock(),t1;

	// parse arguments
	parseArg(argc, argv);

	//packet count
	int n = 0;

	// error buffer for pcap analysis, constant defined in pcap.h
	char errbuf[PCAP_ERRBUF_SIZE];
	// PCAP packet structures
	const u_char *packet;
	struct ip *my_ip;
	const struct tcphdr *my_tcp;    // pointer to the beginning of TCP header
	const struct udphdr *my_udp;    // pointer to the beginning of UDP header
	struct pcap_pkthdr header;  
	// file/device handler
	pcap_t *handle;
	u_int size_ip;
	// bool for checking storage status of a packet
	bool stored;

	//UDP socket for flow sending
	UDP socket;

	//List of flow records/classes
	list<Flow> flows;
	list<Flow> flows_cache;

	list<Flow>::iterator flw_begin;
	Flow flw_end;

	// open file for logging if -v is set
	if (options.verbose) {
		myfile.open ("log.log");
	}
	
	// open the input file
	if ((handle = pcap_open_offline(options.input.c_str(), errbuf)) == NULL) {
		cerr << "Can't open file " << options.input << " for reading";
		cleanup(1);
	}
	
	// read packets from the file
	while ((packet = pcap_next(handle,&header)) != NULL) {

		// on first run setup the export timer
		if (n == 0) {
			sys_uptime = header.ts.tv_sec;
			sys_uptime = sys_uptime*1000 + header.ts.tv_usec/1000;
		}
		n++;

		// Skip Ethernet header
		my_ip = (struct ip*) (packet+SIZE_ETHERNET);

       	// Length of IP header
		size_ip = my_ip->ip_hl*4;
		
		//New flow item (yeah, for each packet, who cares about TCP, C++ will solve it out)
		Flow item;

		// Skip all IPv6 packets
		if (my_ip->ip_v != 4) {
			if (options.verbose)
				myfile << "INFO: Packet #" << n << " is an ipv6 packet, skipping." << endl;
			continue;
		}
		
		// Let's sort them out!
		switch (my_ip->ip_p) {
			case 1:
				//my_icmp = (struct icmphdr *) (packet+SIZE_ETHERNET+size_ip); // pointer to the ICMP header

	    		// store the packet
	    		item.store_packet(my_ip, header);

	    		// store the flow
				flows_cache.push_back(item);

				if(options.verbose)
		    		myfile << "Storing ICMP" << endl;
				break;

			case 6: // TCP protocol
				my_tcp = (struct tcphdr *) (packet+SIZE_ETHERNET+size_ip); // pointer to the TCP header
				stored = false;
				
				// first run
				if (flows_cache.size() == 0) {
		    		item.store_packet(my_ip, my_tcp, header);
					flows_cache.push_back(item);
				} else {
					// iterate over the whole flows list and search for the same packet
					for (list<Flow>::iterator flowsIter = flows_cache.begin();
						flowsIter != flows_cache.end(); 
						flowsIter++ ) {

						if (flowsIter->check_records(my_ip, my_tcp, header)) {
			    			stored = true;
			    			break;
						}
					}
					// We ain't found sh**! Ehm, no similar flow, so store it
					if (!stored) {
						item.store_packet(my_ip, my_tcp, header);
			    		if(options.verbose)
				    		myfile << "Storing TCP" << endl;
						flows_cache.push_back(item);
					}
				}
				
				break;

			case 17: // UDP protocol				
				my_udp = (struct udphdr *) (packet+SIZE_ETHERNET+size_ip); // pointer to the UDP header

	    		item.store_packet(my_ip, my_udp, header);
				flows_cache.push_back(item);

				if(options.verbose)
		    		myfile << "Storing UDP" << endl;
				break;

			default:
				if (options.verbose) {
					myfile << "Unknown packet\t";
					myfile << "PROTO: " << (int)my_ip->ip_p << endl;
				}
				break;
		}

		// Check if flow has to be expired
		if (flows_cache.size() == options.flows)
			expire(&flows, &flows_cache, true);

		// Export all expired flows in case of reaching the interval 
		if (flows.size()) {
			flw_begin = flows.begin();
			flw_end = flows.back();
	
			if (flw_end.flow_finish - flw_begin->flow_start > options.interval*1000) {
				if (options.verbose)
					myfile << "Interval reached, exporting collected expired flows" << endl;
				
				export_flows(flows, &socket);
				flows.clear();
			}
		}

	} // while

	if (options.verbose) {
		myfile << "Packet to flow record processing finished." << endl;
		myfile << "Flows cache size: " << flows_cache.size() << endl;
	}
	
	// Expire everything what is left in flow cache
	expire(&flows, &flows_cache, false);

	// Send all collected flows to collector
	if (flows.size() > 0) {
		export_flows(flows, &socket);
	}

	//Some stats
	if (options.verbose) {
		myfile << setw(80) << setfill('.') << "" << endl;
		myfile << "STATISTICS" << endl;
		myfile << setw(80) << setfill('.') << "" << endl;
		myfile << "Flows created: " << flows.size() << endl;
		myfile << "Packets processed: " << n << endl << endl;
		t1=clock()-t0;
		myfile << "Total execution time: " << (double)t1/CLOCKS_PER_SEC << endl;
	}

	// Just clean the lists in case of fire
	flows_cache.clear();
	flows.clear();

	// Close the capture device and deallocate resources
	if (options.verbose)
		myfile.close();
	
	pcap_close(handle);

	// Bye bye
	return 0;
}

// Split string by a given character
// Author: Mario Kuka
void split(const string &s, char c, vector<string> &elems) {    
    elems.clear();
    // create stream
    stringstream ss(s);
    string item;
    // divide by c
    while (getline(ss, item, c))
        // storing to vector 
        elems.push_back(item);
}


void printHelp() {
	cout << setw(80) << setfill('.') << "" << endl;
	cout << "Super uber cool offline NetFlow exporter" << endl;
	cout << "-i [--input] <file> filename of the pcap file to be processed (STDIN in case of no argument)" << endl;
	cout << "-c [--collector] <neflow_collector:port> IPv4 address, or hostname of NetFlow collector. Optional UDP port (default 127.0.0.1:2055)" << endl;
	cout << "-I [--interval] <interval> - interval in seconds after which the flows are exported on the collector (300)" << endl;
	cout << "-m [--max-flows] <count> - maximum number of flows in flow cache (50)" << endl;
	cout << "-t [--tcp-timeout] <seconds> - interval for TCP flow timeout (300)" << endl;
	cout << "-h [--help] – what do you think, huh?" << endl;
	cout << "-b [--body] – how many points I want. Over 9 000 of course!" << endl;
	cout << setw(80) << setfill('.') << "" << endl;
	cout << "Author: Petr Stehlik (xstehl14) " << "\u00A9" << "2015" << endl;

	cleanup(0); 
}

void parseArg(int argc, char *argv[]) {
	static struct option long_options[] = {
		{"input",		required_argument, 	0, 'i'},
		{"collector",	required_argument, 	0, 'c'},
		{"interval",	required_argument, 	0, 'I'},
		{"max-flows",	required_argument, 	0, 'm'},
		{"tcp-timeout",	required_argument, 	0, 't'},
		{"verbose", 	no_argument, 		0, 'v'},
		{"help", 		no_argument, 		0, 'h'},
		{"body", 		no_argument, 		0, 'b'},
		{0, 0, 0, 0}
	};


	int option_index = 0;
	int c;

	//fill the options sin_addr
	while ((c = getopt_long (argc, argv, "i:c:I:m:t:vhb", long_options, &option_index)) != -1 ) {
		switch(c) {
			case 'i':
				options.input = optarg;
				break;
			case 'c':
				{
					string tmp(optarg);
					vector<string> seglist;
					split(tmp, ':', seglist);
					if (seglist.size() > 1)
						options.port = stoi(seglist[1]);
					options.ip = seglist[0];
				}
				break;
			case 'I':
				options.interval = atoi(optarg);
				break;
			case 'm':
				options.flows = atoi(optarg);
				break;
			case 't':
				options.timeout = atoi(optarg);
				break;
			case 'v':
				options.verbose = true;
				break;
			case 'h':
				printHelp();
				break;
			case 'b':
				cout << "15" << endl;
				cleanup(0);
			default:
				break;
		}
	}
}

void expire(std::list<Flow> *flows, std::list<Flow> *flows_cache, bool single) {
	if (single) {
		if (options.verbose)
	    		myfile << "Reached max flow cache, exporting the first flow" << endl;

    	flows->push_back(flows_cache->front());
    	flows_cache->pop_front();
	} else {
		list<Flow >::iterator flows_cache_iter;

		for (flows_cache_iter = flows_cache->begin(); flows_cache_iter != flows_cache->end(); flows_cache_iter++) {

			flows->push_back(flows_cache_iter->get_pointer());

		}
	}
}

void export_flows(std::list<Flow> flows, UDP *socket) {
	int total_packets = flows.size() % MAX_FLOWS;
	int exported_packets = (int)(flows.size() / MAX_FLOWS) * MAX_FLOWS;
	list<Flow >::iterator flowsIter;

	for (flowsIter = flows.begin(); flowsIter != flows.end(); flowsIter++) {
    	if (options.verbose)
    		flowsIter->print_flow();

    	socket->add_flow(flowsIter->get_pointer(), i);
    	i++;
    	if (i == MAX_FLOWS) {
    		socket->create_header(i, seq, flowsIter->get_pointer());
    		seq += 30;
			socket->send_packet();
			i = 0;
			socket->reset();
    	}			
	}

	if (total_packets != 0) {
		if (options.verbose)
			myfile << "Sending the rest of exported flows: " << total_packets << endl;
		
		flowsIter = flows.begin();
		advance(flowsIter, exported_packets - 1);
		seq += total_packets;
		socket->create_header(total_packets, seq, flowsIter->get_pointer());
		socket->send_packet();
		socket->reset();
		i = 0;
	}
}

void cleanup(int exitcode) {
	// flows_cache.clear();
	// flows.clear();

	// close the capture device and deallocate resources
	if (options.verbose)
		myfile.close();
	
	// pcap_close(handle);

	// delete socket;

	exit(exitcode);
}
