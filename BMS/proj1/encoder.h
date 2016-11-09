#pragma once

#include <strings.h>
#include <cstring>

#include "file.h"
#include "ecc.h"

namespace RS {
class Encoder {

public:
	/* RS code is defined as RS(n,k) where:
	 * n - total byte size
	 * k - raw data
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

	void encode(File::BinData &src, File::BinData &dst)
	{
		unsigned int i = 0;

		for (; i <= src.size() - m_k; i += m_k) {
			unsigned char tmp_codeword[m_n];
			//memset(&tmp_codeword[0], 0, sizeof(tmp_codeword));

			encode_data(&(src)[i], m_k, tmp_codeword);

			dst.insert(dst.end(), tmp_codeword, tmp_codeword + m_n);
		}

		// Dokroceni
		unsigned int diff = src.size() - i;

		if (diff > 0) {
			unsigned char tmp_codeword[diff + NPAR];
			//memset(&tmp_codeword[0], 0, sizeof(tmp_codeword));

			encode_data(&(src)[i], diff, tmp_codeword);

			dst.insert(dst.end(), tmp_codeword, tmp_codeword + diff + NPAR);
		}
	}

	void decode(File::BinData &src, File::BinData &dst)
	{
		unsigned int i;
		int erasures[1];

		for (i = 0; i <= src.size() - m_n; i += m_n) {
			unsigned char tmp_codeword[m_n];

			std::copy(&(src)[i], &(src)[i + m_n], tmp_codeword);

			decode_data(tmp_codeword, m_n);

			if (check_syndrome() != 0) {
				correct_errors_erasures(tmp_codeword, m_n, 0, erasures);
			}

			dst.insert(dst.end(), tmp_codeword, tmp_codeword + m_k);
		}

		int diff = src.size() - i;

		if (diff > 0) {
			unsigned char tmp_codeword[diff];
			std::copy(&(src)[i], &(src)[i + diff], tmp_codeword);
			decode_data(tmp_codeword, diff);
			if (check_syndrome() != 0) {
				correct_errors_erasures(tmp_codeword, diff, 0, erasures);
			}

			File::BinData tmp;

			tmp.insert(tmp.end(), tmp_codeword, tmp_codeword + diff - NPAR);

			dst.insert(dst.end(), tmp.begin(), tmp.end());
		}
	}

private:
	unsigned int m_n = 0;
	unsigned int m_k = 0;
	unsigned int m_parity = 0;
};
}
