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
#include "encoder.h"

using namespace std;

int main (int argc, char *argv[])
{
	if (argc != 2) {
		cerr << "incorrect number of arguments, should be ./bms1A 'input file'" << endl;
		exit(1);
	}

	string loc(argv[1]);
	string outPath(loc + ".ok");

	File inFile(argv[1]);
	File outFile(outPath.c_str());

	cout << "Start" << endl;

	/* Initialization the ECC library */
	initialize_ecc();

	cout << "initialized" << endl;

	inFile.read();

	File::BinData codeword;
	File::BinData codeword_2;

	//RS::Encoder decoder(605,350);
	RS::Encoder decoder(255,146);
	//RS::Encoder decoder_2(125,100);

	decoder.decode(inFile.get(), codeword);
	//decoder_2.decode(codeword, codeword_2);

	outFile.write(codeword);

	exit(0);
}

