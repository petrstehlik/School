/* Example use of Reed-Solomon library 
 *
 * (C) Universal Access Inc. 1996 
 * hqm@alum.mit.edu
 *
 * This same code demonstrates the use of the encodier and 
 * decoder/error-correction routines. 
 *
 * We are assuming we have at least four bytes of parity (NPAR >= 4).
 * 
 * This gives us the ability to correct up to two errors, or 
 * four erasures. 
 *
 * In general, with E errors, and K erasures, you will need
 * 2E + K bytes of parity to be able to correct the codeword
 * back to recover the original message data.
 *
 * You could say that each error 'consumes' two bytes of the parity,
 * whereas each erasure 'consumes' one byte.
 *
 * Thus, as demonstrated below, we can inject one error (location unknown)
 * and two erasures (with their locations specified) and the 
 * error-correction routine will be able to correct the codeword
 * back to the original message.
 * */

#include <iostream>

extern "C" {
	#include "ecc.h"
}
#include "file.h"

using namespace std;

int main (int argc, char *argv[])
{
	if (argc != 2) {
		cerr << "incorrect number of arguments, should be ./bms1A 'input file'" << endl;
		exit(1);
	}

	string loc(argv[1]);
	string outPath(loc + "_encoded");

	File inFile(argv[1]);
	File outFile(outPath.c_str());

	/* Initialization the ECC library */
	initialize_ecc();

	inFile.read();

	File::BinData codeword;

	int i = 0;

	for (; i < inFile.size()-24; i += 24) {
		unsigned char tmp_codeword[28];

		encode_data(&(inFile.get())[i], 24, tmp_codeword);

		codeword.insert(codeword.end(), tmp_codeword, tmp_codeword + 28);
	}

	// Dokroceni
	int diff = inFile.size() % 24;

	if (diff > 0) {
		unsigned char tmp_codeword[diff];

		encode_data(&(inFile.get())[i], diff, tmp_codeword);

		codeword.insert(codeword.end(), tmp_codeword, tmp_codeword + diff + 4);
	}

	outFile.write(codeword);

	exit(0);
}

