/*
 * BMS project 1
 * Author: Petr Stehlik <xstehl14@stud.fit.vutbr.cz>
 * Description: Generic file manipulation. Read bytes as unsigned char.
 * License: GNU GPL
 *
 * Acknowledgment: this program uses external library RSCode
 * (http://rscode.sourceforge.net).
 **/

#pragma once

#include <fstream>
#include <iterator>
#include <vector>

class File {
public:
	typedef std::vector<unsigned char> BinData;

	// Set path of the in/output file
	File(const char* path)
	{
		m_path = path;
	}

	// Read the file set in cunstructor via ifstream
	void read()
	{
		std::ifstream input(m_path, std::ios::binary);
		m_file = BinData(std::istreambuf_iterator<char>(input),
            std::istreambuf_iterator<char>());

		m_size = m_file.size();
	}

	// Write file to the destination m_path
	void write(BinData &data)
	{
		std::ofstream output(m_path, std::ios::binary);

		std::ostream_iterator<unsigned char> output_iterator(output);

        std::copy(data.begin(), data.end(), output_iterator);
	}

	size_t length()
	{
		return m_file.size();
	}

	int size()
	{
		return m_size;
	}

	// Return pointer to the first element of the vector
	// This can trick C code into thinking it is actually char array
	unsigned char* toChar()
	{
		return &m_file[0];
	}

	// Getter for file
	BinData &get()
	{
		return m_file;
	}

private:
	const char* m_path;
	BinData m_file;
	int m_size = 0;

};
