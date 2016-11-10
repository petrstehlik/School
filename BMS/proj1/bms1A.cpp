/*
 * BMS project 1
 * Author: Petr Stehlik <xstehl14@stud.fit.vutbr.cz>
 * Description: Encoder using Reed-Solomon algorithms with interleaving
 * License: GNU GPL
 *
 * Acknowledgment: this program uses external library RSCode
 * (http://rscode.sourceforge.net).
 **/

#include <iostream>

// RSCode library precompiled with NPAR = 109
extern "C" {
	#include "ecc.h"
}

// File manipulation
#include "file.h"

// Actually the whole en/decoder
#include "encoder.h"

// De/interleaver
#include "interleaver.h"

using namespace std;

int main (int argc, char *argv[])
{
	if (argc != 2) {
		cerr << "incorrect number of arguments, should be ./bms1A 'input file'" << endl;
		exit(1);
	}

	// Initialize input and output File instances
	string loc(argv[1]);
	string outPath(loc + ".out");

	File inFile(argv[1]);
	File outFile(outPath.c_str());

	// Codewords are already encoded parts
	File::BinData codeword;
	File::BinData codeword_int;

	// Encoder instance with configuration RS(255,146) which means 109 parity
	// bytes which gives us about 174.6% size of the original file.
	RS::Encoder encoder(255,146);

	// Interleaver must be with the same configuration as encoder
	RS::Interleaver inter(255,146);

	// Initialization of the RSCode library
	initialize_ecc();

	// Read the input file, encode it and interleave the encoded data
	inFile.read();
	encoder.encode(inFile.get(), codeword);
	inter.interleave(codeword, codeword_int);

	// Write the finalized codeword
	outFile.write(codeword_int);

	exit(0);
}

