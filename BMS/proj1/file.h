#pragma once

#include <fstream>
#include <iterator>
#include <vector>

class File {
public:
	typedef std::vector<unsigned char> BinData;

	File(const char* path)
	{
		m_path = path;
	}

	void read()
	{
		std::ifstream input(m_path, std::ios::binary);
		m_file = BinData(std::istreambuf_iterator<char>(input),
            std::istreambuf_iterator<char>());

		m_size = m_file.size();
	}

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

	unsigned char* toChar()
	{
		return &m_file[0];
	}

	BinData &get()
	{
		return m_file;
	}

private:
	const char* m_path;
	BinData m_file;
	int m_size = 0;

};
