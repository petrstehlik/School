/* Example use of Reed-Solomon library 
 *
 * Copyright Henry Minsky (hqm@alum.mit.edu) 1991-2009
 *
 * This software library is licensed under terms of the GNU GENERAL
 * PUBLIC LICENSE
 *
 * RSCODE is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * RSCODE is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Rscode.  If not, see <http://www.gnu.org/licenses/>.

 * Commercial licensing is available under a separate license, please
 * contact author for details.
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
 
#include <stdio.h>
#include <stdlib.h>
#include "ecc.h"
 
unsigned char msg[] = "Nervously I loaded the twin ducks aboard the revolving pl\
atform.";
unsigned char codeword[256];
 
/* Some debugging routines to introduce errors or erasures
   into a codeword. 
   */

/* Introduce a byte error at LOC */
void
byte_err (int err, int loc, unsigned char *dst)
{
  printf("Adding Error at loc %d, data %#x\n", loc, dst[loc-1]);
  dst[loc-1] ^= err;
}

/* Pass in location of error (first byte position is
   labeled starting at 1, not 0), and the codeword.
*/
void
byte_erasure (int loc, unsigned char dst[], int cwsize, int erasures[]) 
{
  printf("Erasure at loc %d, data %#x\n", loc, dst[loc-1]);
  dst[loc-1] = 0;
}


int
main (int argc, char *argv[])
{
 
  int erasures[16];
  int nerasures = 0;

  /* Initialization the ECC library */
 
  initialize_ecc ();
 
  /* ************** */
 
  /* Encode data into codeword, adding NPAR parity bytes */
  encode_data(msg, sizeof(msg), codeword);
 
  printf("Encoded data is: \"%s\"\n", codeword);
   for (int i = 0; i < sizeof(codeword); i++)
	printf("Char: %c %d\n", codeword[i], codeword[i]);

 
#define ML (sizeof (msg) + NPAR)


  /* Add one error and two erasures */
  byte_err(0x35, 3, codeword);
  byte_err(0x23, 7, codeword);
  byte_err(0x34, 9, codeword);
  byte_err(0x34, 14, codeword);
  byte_err(0x34, 17, codeword);
  byte_err(0x34, 28, codeword);

  byte_err(0x35, 32, codeword);
  byte_err(0x23, 37, codeword);
  byte_err(0x280, 42, codeword);
  byte_err(0x34, 50, codeword);
  byte_err(0x01, 56, codeword);
  byte_err(0x120, 63, codeword);
  byte_err(0x120, 70, codeword);
  byte_err(0x10, 100, codeword);
  byte_err(0x10, 110, codeword);
  byte_err(0x10, 90, codeword);
  byte_err(0x10, 80, codeword);
  byte_err(0x10, 51, codeword);
  byte_err(0x10, 53, codeword);
  byte_err(0x10, 54, codeword);
  byte_err(0x10, 56, codeword);
  byte_err(0x10, 55, codeword);
  byte_err(0x10, 65, codeword);
  byte_err(0x10, 75, codeword);



  printf("with some errors: \"%s\"\n", codeword);

  /* We need to indicate the position of the erasures.  Eraseure
     positions are indexed (1 based) from the end of the message... */

 //erasures[nerasures++] = ML-17;
// erasures[nerasures++] = ML-19;

  /* Now decode -- encoded codeword size must be passed */
  decode_data(codeword, ML);

 /* check if syndrome is all zeros */
  if (check_syndrome () != 0) {
    correct_errors_erasures (codeword, 
			     ML,
			     nerasures, 
			     erasures);
 
    printf("Corrected codeword: \"%s\"\n", codeword);
  }
 
  exit(0);
}

