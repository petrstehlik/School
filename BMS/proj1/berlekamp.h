/***********************************************************************
 * Copyright Henry Minsky (hqm@alum.mit.edu) 1991-2009
 *
 * This software library is licensed under terms of the GNU GENERAL
 * PUBLIC LICENSE
 * 
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
 *
 * Commercial licensing is available under a separate license, please
 * contact author for details.
 *
 * Source code is available at http://rscode.sourceforge.net
 * Berlekamp-Peterson and Berlekamp-Massey Algorithms for error-location
 *
 * From Cain, Clark, "Error-Correction Coding For Digital Communications", pp. 205.
 *
 * This finds the coefficients of the error locator polynomial.
 *
 * The roots are then found by looking for the values of a^n
 * where evaluating the polynomial yields zero.
 *
 * Error correction is done using the error-evaluator equation  on pp 207.
 *
 */

#include <stdio.h>
//#include "ecc.h"
#include "galois.h"

class Berlekamp {
public:
	Berlekamp(int pBytes)
	{
		m_pBytes = pBytes;
		m_maxDegree = m_pBytes * 2;
	}

private:
	unsigned int m_pBytes = 0;
	unsigned int m_maxDegree = 0;

	/* The Error Locator Polynomial, also known as Lambda or Sigma.
	 * Lambda[0] == 1
	 */
	static int Lambda[MAXDEG];

	/* The Error Evaluator Polynomial */
	static int Omega[MAXDEG];

	/* local ANSI declarations */
	static int compute_discrepancy(int lambda[], int S[], int L, int n);
	static void init_gamma(int gamma[]);
	static void compute_modified_omega(void);
	static void mul_z_poly(int src[]);

	/* error locations found using Chien's search */
	static int ErrorLocs[256];
	static int NErrors;

	/* erasure flags */
	static int ErasureLocs[256];
	static int NErasures;

}
