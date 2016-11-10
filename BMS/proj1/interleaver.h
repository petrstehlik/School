/*
 * BMS project 1
 * Author: Petr Stehlik <xstehl14@stud.fit.vutbr.cz>
 * Description: Interleaver for generic RS Coder
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
class Interleaver {

public:
	/* RS code is defined as RS(n,k) where:
	 * n - total byte size
	 * k - raw data
	 * (n-k) - parity bytes
	 */
	Interleaver(unsigned int n = 28, unsigned int k = 20)
	{
		m_n = n;
		m_k = k;
		m_parity = n - k;

		if (m_parity != NPAR) {
			std::cerr << "parity must be " << NPAR << std::endl;
			exit(1);
		}

	}

	// Interlave every m_n-th element so there will be m_n interleaved chunks
	// Example:
	//		m_n = 255, there will be chunk of every 0. element up to 254.
	//		element of the source array.
	void interleave(File::BinData &src, File::BinData &dst)
	{
		int block_count = src.size()/m_n;

		// Reserve rounded size for the dst
		dst.resize(block_count * m_n);

		// Do the magical interleaving
		for (int i = 0; i < block_count; i++) {
			for (unsigned int j = 0; j < m_n; j++) {
				dst[j * block_count + i] = src[i * m_n + j];
			}
		}

		// Insert the final unrounded part without interleaving
		dst.insert(dst.end(), src.begin() + (block_count * m_n), src.end());
	}

	void deinterleave(File::BinData &src, File::BinData &dst)
	{
		int block_count = src.size()/m_n;

		dst.resize(block_count * m_n);

		for (int i = 0; i < block_count; i++) {
			for (unsigned int j = 0; j < m_n; j++) {
				dst[i * m_n + j] = src[j * block_count + i];
			}
		}

		// Insert last part as original (not interleaved)
		dst.insert(dst.end(), src.begin() + (block_count * m_n), src.end());
	}

private:
	unsigned int m_n = 0;
	unsigned int m_k = 0;
	unsigned int m_parity = 0;
};
}
