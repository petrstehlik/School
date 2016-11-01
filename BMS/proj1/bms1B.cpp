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
	string outPath(loc + "_decoded");

	File inFile(argv[1]);
	File outFile(outPath.c_str());

	/* Initialization the ECC library */
	initialize_ecc();

	inFile.read();

	File::BinData codeword;

	for (size_t i = 0; i < inFile.length(); i += 28) {
		unsigned char tmp_codeword[28];

		copy(&(inFile.get())[i], &(inFile.get())[i + 28], tmp_codeword);

		//encode_data(&(inFile.get())[i], 24, tmp_codeword);

		//cout << tmp_codeword << endl;

		decode_data(tmp_codeword, 28);

		int erasures[1];

		/* check if syndrome is all zeros */
	//	if (check_syndrome() != 0) {
		correct_errors_erasures(tmp_codeword, 28, 0, erasures);

		codeword.insert(codeword.end(), tmp_codeword, tmp_codeword + 24);

		for (auto it : tmp_codeword)
			cout << it;

		cout << endl;


	}

	outFile.write(codeword);

	exit(0);
}

