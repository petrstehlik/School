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
	#include "rscode/ecc.h"
}
#include "file.h"

using namespace std;

int main (int argc, char *argv[])
{

	string loc(argv[1]);
	string outPath(loc + "_encoded");

	File inFile(argv[1]);
	File outFile(outPath.c_str());

	/* Initialization the ECC library */
	initialize_ecc();

	inFile.read();

	File::BinData codeword;

	encode_data(inFile.toChar(), inFile.length(), &codeword[0]);
	cout << "File size:" << inFile.length() << endl;

	outFile.write(codeword);

  /* ************** */
  /* Encode data into codeword, adding NPAR parity bytes */
  //encode_data(string, fsize+1, codeword);

 
//printf("Encoded data is: \"%s\"\n", codeword);
 
#define ML (sizeof (string) + NPAR)

//printf("with some errors: \"%s\"\n", codeword);

  /* We need to indicate the position of the erasures.  Eraseure
     positions are indexed (1 based) from the end of the message... */

  //erasures[nerasures++] = ML-17;
  //erasures[nerasures++] = ML-19;

 
  /* Now decode -- encoded codeword size must be passed */
  //decode_data(codeword, ML);

  /* check if syndrome is all zeros */
  /*if (check_syndrome () != 0) {
    correct_errors_erasures (codeword, 
			     ML,
			     nerasures, 
			     erasures);
 
    printf("Corrected codeword: \"%s\"\n", codeword);
  }*/
 
  exit(0);
}

