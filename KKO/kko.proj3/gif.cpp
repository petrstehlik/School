/**
  * GIF class implementation. Implements operations with GIF include LZW
  * decompression and colour handling.
  *
  * Author: Petr Stehlik <xstehl14@stud.fit.vutbr.cz>
  * Date: 2017/05/07
  *
  * file: gif.cpp
  */

#include "gif.h"

using namespace std;

GIF::GIF(FILE *fp)
{
	this->input = fp;
}

int GIF::Convert()
{
	packedField packedF;
	int GCT_length = 0;
	color *GCT = NULL;
	color *LCT = NULL;
	int code_length;
	GCE ext;
	vector<byte> data;

	try {
		readHeader();
	} catch ( GIFError &e ) {
		return error(e.what());
	}

	fread(&(this->descriptor), 1, 7, this->input);

	parsePackedField(&descriptor, &packedF);

	/**
	  * If present, parse global color table
	  */
	if (packedF.GCT_flag) {
		GCT_length = POW(packedF.GCT_size + 1);
		code_length = packedF.GCT_size + 1;

		GCT = (color *)malloc(sizeof(color) * GCT_length);

		for (int var = 0; var < GCT_length; ++var) {
			fread(&(GCT[var]), sizeof(color), 1, this->input);
		}

		// Print the GCT in debug
		if (DEBUG) {
			cerr << "Global Color Table: " << GCT_length << " (OK)" << endl;
			for (int i = 0; i < GCT_length; i++) {
				cerr << i << " (" <<
					(int)GCT[i].r << ", " <<
					(int)GCT[i].g << ", " <<
					(int)GCT[i].b << ")" << endl;
			}
		}
	} else if (DEBUG){
		cerr << "No GCT found" << endl;
	}

	/**
	  * EXTENSION FLAG parsing
	  */
	uint8_t extension_flag = fgetc(this->input);

	while (extension_flag == 0x21) {
		if (DEBUG)
			cerr << "Extension flag found!" << endl;

		uint8_t control_label = fgetc(this->input);

		if (DEBUG)
			cerr << "control label: " << control_label << endl;

		if (control_label == 0xF9) {
			if (DEBUG)
				cerr << "Control label found!" << endl;;

			fread(&ext, sizeof(GCE), 1, this->input);

			if (DEBUG)
				cerr << "size of extension: " << ext.size << endl;

			if (ext.terminator != 0x00)
				return error("Graphic Control Extension not terminated correctly");
		} else if (DEBUG){
			cerr << std::hex << "Different control label: " << control_label << endl;;
			cerr << std::dec;
		}

		extension_flag = fgetc(this->input);

		if (DEBUG)
			cerr << "extension flag: " << extension_flag << endl;;
	}

	/**
	  * Check for extension flags
	  */
	if (extension_flag == IMAGE_DESCRIPTOR) {
		if (DEBUG)
			cerr << "Image descriptor found" << endl;

		// Load logical screen descriptor up to packed byte
		fread(&(this->logical_screen_descriptor), sizeof(uint16_t), 4, this->input);

		if (DEBUG)
			cerr << "Size: " << width() << " x " << height() << endl;

		parseImgDescPack(&(this->logical_screen_descriptor.p), fgetc(this->input));

		if (DEBUG && has_LCT()) {
			cerr << "HAS INTERLACE FLAG";
		}

		if (has_LCT()) {
			if (DEBUG) {
				cerr << "-- LCT is present" << endl;
				cerr << "Size: " << LCT_size() << endl;
			}

			code_length = LCT_size() + 1;

			uint16_t LCT_length = POW(LCT_size() + 1);

			LCT = (color *)malloc(sizeof(color) * LCT_length);

			for (int var = 0; var < LCT_length; ++var) {
				fread(&(LCT[var]), sizeof(color), 1, this->input);
			}

			if (DEBUG) {
				cerr << "LCT length: " << (int)LCT_length << endl;
				cerr << "--------------LCT TABLE-----------" << endl;
				for (int i = 0; i < LCT_length; i++) {
					cerr << i << " (" <<
						(int)LCT[i].r << ", " <<
						(int)LCT[i].g << ", " <<
						(int)LCT[i].b << ")" << endl;
				}
			}
		}
	}

	/**
	  * Acquire data from the file
	  */
	// Now we are going to parse data
	uint8_t minCodeSize = fgetc(this->input);

	if (DEBUG)
		cerr << "Min code size: " << (int)minCodeSize << endl;

	uint8_t subBlockSize = fgetc(this->input);

	while (true) {
		if (DEBUG)
			cerr << "Sub block size: " << (int)subBlockSize << endl;

		vector<byte> tmp_data((int)subBlockSize);

		for (int i = 0; i < (int)subBlockSize; ++i) {
			tmp_data[i] = fgetc(this->input);
		}

		data.insert(data.end(), tmp_data.begin(), tmp_data.end());

		// Print the loaded data
		if (DEBUG) {
			for (auto it : tmp_data) {
				//cerr << std::hex << (int)it << " " << endl;
				cerr << "Color " << (int)it << ": (" <<
					GCT[(int)it].r << ", " <<
					GCT[(int)it].g << ", " <<
					GCT[(int)it].b << ")" << endl;
			}

			// Reset cerr to use decimal again
			cerr << std::dec << endl;
		}

		// Get next block size
		subBlockSize = fgetc(this->input);

		// End of data
		if (subBlockSize == 0x00) {
			if (DEBUG)
				cerr << "End of data" << endl;
			break;
		}
	}

	// Check the trailer byte
	if (fgetc(this->input) != TRAILER) {
		return error("Trailer byte not found!");
	}

	if (DEBUG)
		cerr << "data size: " << data.size() << endl;

	// TODO: Decompress acquired data
	uint8_t * out2;
	out2 = (uint8_t *)malloc (sizeof(uint8_t) * width() * height());

	try {
		// we need this conversion because we will manipulate with pointers
		decompress(code_length, (uint8_t *)&(data[0]), data.size(), out2);
	} catch (GIFError &e) {
		return error(e.what());
	}

	// Get colours of each pixel
	this->pixel_data.resize(width() * height());

	if (has_LCT()) {
		for (int i = 0; i < width() * height(); i++) {
				//printf("%x (%d) ", out2[i], out2[i]);
				pixel_data[i] = LCT[(int)out2[i]];
		}
	} else {
		for (int i = 0; i < width() * height(); i++) {
				//printf("%x (%d) ", out2[i], out2[i]);
				pixel_data[i] = GCT[(int)out2[i]];
		}
	}

	if (has_interlace())
		interlace();

	// Cleanup
	free(GCT);
	free(LCT);
	free(out2);

	return 0;

}

void GIF::readHeader()
{
	fread(&(this->header), 3, 2, this->input);

	if (strncmp((const char *)this->header.signature, "GIF", 3) == 0) {
		if (DEBUG)
			cerr << "Signature: OK" << endl;
	} else {
		throw GIFError("Bad signature");
	}

	//if (strncmp((const char *)h->version, "87a", 3) == 0)
	//	throw GIFError("Version 87a is not supported");

	if (strncmp((const char *)this->header.version, "89a", 3) == 0 ||
			strncmp((const char *)this->header.version, "87a", 3) == 0) {
		if (DEBUG)
			cerr << "Version: OK" << endl;
	} else {
		throw GIFError("Unknown version");
	}
}

void GIF::parsePackedField (descriptor_t *d, packedField *p)
{
	p->GCT_flag = (d->packed & 0x80) >> 7;
	p->colorResolution = (d->packed & 0x70) >> 4;
	p->sortFlag = (d->packed & 0x08) >> 3;
	p->GCT_size = (d->packed & 0x07);
}

void GIF::parseImgDescPack(imgDescPack *i, char c)
{
	i->LCT_flag = (c & 0x80) >> 7;
	i->interlace_flag = (c & 0x40) >> 6;
	i->sort_flag = (c & 0x20) >> 5;
	i->futureuse = (c & 0x18) >> 3;
	i->LCT_size = (c & 0x07);
}

// https://www.daubnet.com/en/file-format-gif
void GIF::interlace() {
	if (DEBUG)
		cerr <<	"should interlace" << endl;

	/*int scheme[] = {8,8,4,2};
	int lines[] = {0, 4, 2, 1};

	vector<color> tmp;

	// Will do 4 passes
	for (int pass = 0; pass < 4; pass++) {
		int startline = lines[pass] * width();

		if (startline > 0)
			startline -= width();

		for (int l = 0; l < ((height() + 7) / 8); l++) {
			cout << "offset: " << offset << endl;
			tmp.insert(tmp.end(), tmp.begin() + offset, tmp.begin() + offset + width());
		}
	}*/

	//tmp.swap(pixel_data);
}

// This decompression algorithm is inspirired by Joshua Davies' tutorial
void GIF::decompress(int code_length,
                const unsigned char *input,
                int input_length,
                unsigned char *out) {
	int i, bit;
	int code, prev = -1;
	dictionary_entry_t *dictionary = nullptr;
	int dict_i = 0;
	unsigned int mask = 0x01;
	int reset_code_length = code_length;
	int clear_code = POW(code_length);
	int stop_code = clear_code + 1;
	int match_len;

	// Allocate dict
	dictionary = (dictionary_entry_t *)
		malloc(sizeof( dictionary_entry_t ) * POW(code_length + 1));

	// Initialize dictionary
	dict_i = initializeDictionary(dictionary, code_length);

	// Process the codes
	while (input_length) {
		code = 0x0;

		// size to read is code_length + 1
		for (i = 0; i < (code_length + 1); i++ ) {
			bit = (*input & mask) ? 1 : 0;
			mask <<= 1;

			if (mask == 0x100) {
				mask = 0x01;
				input++;
				input_length--;
			}
			code = code | (bit << i);
		}

		// Reinitialize the dictionary when there is clear code
		if (code == clear_code) {
			code_length = reset_code_length;
			dictionary = (dictionary_entry_t *) realloc(dictionary,
				sizeof(dictionary_entry_t) * POW(code_length + 1));

			dict_i = initializeDictionary(dictionary, code_length);

			prev = -1;
			continue;
		} else if ( code == stop_code ) {
			if (input_length > 1)
				throw GIFError("Early stop code");
			break;
		}

		// Update the dictionary with {CODE} and {CODE-1}
		if (prev > -1 && code_length < MAX_CODE_LENGTH) {
			// Check if within dictionary (segfault prevention)
			if (code > dict_i) {
				throw GIFError("CODE overflow in dictionary");
			}

			int ptr;

			// Last code for this dictionary
			if (code == dict_i) {
				ptr = prev;
			} else {
				ptr = code;
			}

			while (dictionary[ ptr ].prev != -1) {
				ptr = dictionary[ ptr ].prev;
			}
			dictionary[dict_i].byte = dictionary[ptr].byte;

			dictionary[dict_i].prev = prev;

			dictionary[dict_i].len = dictionary[prev].len + 1;

			dict_i++;

			// GIF89a must stop at 12 bits, otherwise resize the dictionary
			if (dict_i == POW(code_length + 1) && code_length < MAX_CODE_LENGTH-1) {
				code_length++;

				dictionary = (dictionary_entry_t *) realloc(dictionary,
					sizeof(dictionary_entry_t) * POW(code_length + 1));
			}
		}

		prev = code;

		// Copy the dict entry backwards
		match_len = dictionary[code].len;

		while (code != -1) {
			out[dictionary[code].len - 1] = dictionary[code].byte;

			if (dictionary[code].prev == code)
				throw GIFError("Self-reference, that's really bad error");

			code = dictionary[code].prev;
		}

		out += match_len;
	}

	free(dictionary);
}

/**
  * Initialize dictionary to accomodate all of the codes
  * The size is dependent on code_length parameter
  * In case of overflow the dictionary is enlarged.
  */
int GIF::initializeDictionary(dictionary_entry_t *d, int code_length) {
	int i;
	for (i = 0; i < POW(code_length); i++) {
		d[i].byte = i;
		d[i].prev = -1;
		d[i].len = 1;
	}
	// there must be room for CC and EOI
	return(i+2);
}

