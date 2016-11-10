/*
 * BMS project 1
 * Author: Petr Stehlik <xstehl14@stud.fit.vutbr.cz>
 * Description: Generic en/decoder class using the RSCode library..
 * License: GNU GPL
 *
 * Acknowledgment: this program uses external library RSCode
 * (http://rscode.sourceforge.net).
 **/

#pragma once

#include <strings.h>
#include <cstring>

#include "file.h"

extern "C" {
	#include "ecc.h"
}

namespace RS {
class Encoder {

public:
	/* RS code is defined as RS(n,k) where:
	 * n - total byte size
	 * k - raw data byte size
	 * (n-k) - parity bytes
	 */
	Encoder(unsigned int n = 28, unsigned int k = 20)
	{
		m_n = n;
		m_k = k;
		m_parity = n - k;

		if (m_parity != NPAR) {
			std::cerr << "parity must be " << NPAR << std::endl;
			exit(1);
		}
	}

	// Encode data from src to dst using the RS encoder set up in constructor
	void encode(File::BinData &src, File::BinData &dst)
	{
		unsigned int i = 0;

		for (; i <= src.size() - m_k; i += m_k) {
			// I know, VLA are not okay in C++...
			unsigned char tmp_codeword[m_n];

			encode_data(&(src)[i], m_k, tmp_codeword);

			// Append the codeword to dst
			dst.insert(dst.end(), tmp_codeword, tmp_codeword + m_n);
		}

		// Finalization (final step) in order to encode last unaligned part
		unsigned int diff = src.size() - i;

		if (diff > 0) {
			unsigned char tmp_codeword[diff + NPAR];

			encode_data(&(src)[i], diff, tmp_codeword);

			dst.insert(dst.end(), tmp_codeword, tmp_codeword + diff + NPAR);
		}
	}

	// Decode encoded data from src to dst. The decoder must be set up the same
	// as encoder otherwise it spits out nonsense.
	void decode(File::BinData &src, File::BinData &dst)
	{
		unsigned int i;
		// Variable needed by RSCode lib, actually not used in thsi project
		int erasures[1];

		for (i = 0; i <= src.size() - m_n; i += m_n) {
			unsigned char tmp_codeword[m_n];

			// Take the codeword from src
			// RSCode lib rewrites the contents of passed array
			std::copy(&(src)[i], &(src)[i + m_n], tmp_codeword);

			// Analyze the codeword (no actual decoding happens)
			decode_data(tmp_codeword, m_n);

			// Basically checks if there are errors in the codeword
			if (check_syndrome() != 0) {
				correct_errors_erasures(tmp_codeword, m_n, 0, erasures);
			}

			// Append corrected data
			dst.insert(dst.end(), tmp_codeword, tmp_codeword + m_k);
		}

		// Finalization as in the encoding method but a bit trickier
		int diff = src.size() - i;

		if (diff > 0) {
			unsigned char tmp_codeword[diff];
			std::copy(&(src)[i], &(src)[i + diff], tmp_codeword);
			decode_data(tmp_codeword, diff);
			if (check_syndrome() != 0) {
				correct_errors_erasures(tmp_codeword, diff, 0, erasures);
			}

			// Append corrected data
			dst.insert(dst.end(), tmp_codeword, tmp_codeword + diff - NPAR);
		}
	}

private:
	unsigned int m_n = 0;
	unsigned int m_k = 0;
	unsigned int m_parity = 0;
};
}
