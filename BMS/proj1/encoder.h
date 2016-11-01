#pragma once

#include <strings.h>

#include "file.h"
#include "galois.h"

namespace RS {
class Encoder {

public:
	/* RS code is defined as RS(n,k) where:
	 * n - total byte size
	 * k - raw data
	 * (n-k) - parity bytes
	 */
	Encoder(unsigned int n = 28, unsigned int k = 24)
	{
		m_n = n;
		m_k = k;
		m_parity = n - k;
	}

	void encode(File::BinData &src, File::BinData &dst)
	{
		int i, LFSR[m_parity+1], dbyte, j;

		bzero(LFSR, m_parity+1);

		for (i = 0; i < src->size(); i++)
		{
			dbyte = src[i] ^ LFSR[m_parity - 1];

			for (j = m_parity - 1; j > 0; j--)
				LFSR[j] = LFSR[j-1] ^ gmult(genPoly[j], dbyte);

			LFSR[0] = gmult(genPoly[0], dbyte);
		}

		for (i = 0; i < m_parity; i++)
			pBytes[i] = LFSR[i];

		/* Append the parity bytes at the end of the destination vector */
		m_dst = m_src;
		m_dst.insert(m_dst.end(), m_pBytes.begin(), m_pBytes.end());
	}

	void setSource(File::BinData &src)
	{
		m_src = src;
	}

	void setDestination(File::BinData &dst)
	{
		m_dst = dst;
	}

private:
	compute_genpoly() {}
	unsigned int m_n = 0;
	unsigned int m_k = 0;
	unsigned int m_parity = 0;

	File::BinData &m_src;
	File::BinData m_dst;
	File::BinData m_pBytes;
};
}
