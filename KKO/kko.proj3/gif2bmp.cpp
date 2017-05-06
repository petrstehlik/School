#include <iostream>
#include <stdio.h>
#include <cstring>
#include <cmath>

#include <sys/types.h>
#include <unistd.h>

#include "gif2bmp.h"
#include "bmp.h"

using namespace std;

typedef uint8_t byte;

int gif2bmp(tGIF2BMP *gif2bmp, FILE *inputFile, FILE *outputFile)
{
	gifHeader hdr;
	descriptor desc;
	packedField packedF;
	int GCT_length = 0;
	color *GCT = NULL;
	color *LCT = NULL;
	int clearCode, stopCode, code_length;

	try {
		readHeader(inputFile, &hdr);
	} catch ( GIFError &e ) {
		return error(e.what());
	}

	fread(&desc, 1, 7, inputFile);

	parsePackedField(&desc, &packedF);

	/**
	  * If present, parse global color table
	  */
	if (packedF.GCT_flag) {
		GCT_length = POW(packedF.GCT_size + 1);
		code_length = packedF.GCT_size + 1;

		GCT = (color *)malloc(sizeof(color) * GCT_length);

		for (int var = 0; var < GCT_length; ++var) {
			fread(&(GCT[var]), sizeof(color), 1, inputFile);
		}

		cout << "GCT len: " << GCT_length << endl;
		cout << "Global Color Table: OK" << endl;
		if (DEBUG) {
			for (int i = 0; i < GCT_length; i++) {
				cout << i << " (" <<
					(int)GCT[i].r << ", " <<
					(int)GCT[i].g << ", " <<
					(int)GCT[i].b << ")" << endl;
			}
		}
	} else {
		cout << "No GCT found" << endl;
	}

	/**
	  * EXTENSION FLAG parsing
	  */
	uint8_t extension_flag = fgetc(inputFile);

	while (extension_flag == 0x21) {

		printf("Extension flag found!\n");

		uint8_t control_label = fgetc(inputFile);

		printf("control label: %x\n", control_label);

		if (control_label == 0xF9) {
			printf("Control label found!\n");

			GCE ext;

			fread(&ext, sizeof(GCE), 1, inputFile);

			printf("size of extension: %d\n", ext.size);

			if (ext.terminator != 0x00)
				throw GIFError("Graphic Control Extension not terminated correctly");
		} else {
			printf("\n\nDifferent control label:  %x\n\n", control_label);
		}

		extension_flag = fgetc(inputFile);
		printf("extension flag: %x\n", extension_flag);
	}

	imgDescriptor iDesc;

	/**
	  * Check for extension flags
	  */
	if (extension_flag == IMAGE_DESCRIPTOR) {
		cout << "Image descriptor found" << endl;

		imgDescPack p;

		fread(&iDesc, sizeof(uint16_t), 4, inputFile);

		printf("width: %d\n", iDesc.width);
		printf("height: %d\n", iDesc.height);

		parseImgDescPack(&p, fgetc(inputFile));

		iDesc.p = p;

		if ((bool)iDesc.p.LCT_flag) {
			cout << "LCT is present" << endl;
			cout << "LCT size: " << (int)iDesc.p.LCT_size << endl;
			code_length = (int)iDesc.p.LCT_size + 1;

			uint16_t LCT_length = POW((int)iDesc.p.LCT_size + 1);
			cout << "LCT length: " << (int)LCT_length << endl;

			LCT = (color *)malloc(sizeof(color) * LCT_length);

			for (int var = 0; var < LCT_length; ++var) {
				fread(&(LCT[var]), sizeof(color), 1, inputFile);
			}

			if (DEBUG) {
				cout << "--------------LCT TABLE-----------" << endl;
				for (int i = 0; i < LCT_length; i++) {
					cout << i << " (" <<
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
	uint8_t minCodeSize = fgetc(inputFile);

	cout << "Min code size: " << (int)minCodeSize << endl;
	uint8_t subBlockSize = fgetc(inputFile);
	vector<byte> data;

	while (true) {
		if (DEBUG)
			cout << "Sub block size: " << (int)subBlockSize << endl;

		vector<byte> tmp_data((int)subBlockSize);

		for (int i = 0; i < (int)subBlockSize; ++i) {
			tmp_data[i] = fgetc(inputFile);
		}

		data.insert(data.end(), tmp_data.begin(), tmp_data.end());

		// Print the loaded data
		if (DEBUG) {
			for (auto it : tmp_data) {
				//cout << std::hex << (int)it << " " << endl;
				//printf("Color %d: (%d, %d, %d)\n", (int)it, GCT[(int)it].r, GCT[(int)it].g, GCT[(int)it].b);
			}

			// Reset cout to use decimal again
			cout << std::dec << endl;
		}

		// Get next block size
		subBlockSize = fgetc(inputFile);

		// End of data
		if (subBlockSize == 0x00) {
			if (DEBUG)
				cout << "End of data" << endl;
			break;
		}
	}

	// Check the trailer byte
	if ((byte)fgetc(inputFile) != TRAILER) {
		throw GIFError("Trailer byte not found!");
	}

	if (DEBUG)
		cout << "data size: " << data.size() << endl;

	// TODO: Decompress acquired data
	clearCode = POW(code_length);

	uint8_t * out2;
	out2 = (uint8_t *)malloc (sizeof(uint8_t) * iDesc.width * iDesc.height);

	try {
		uncompress(code_length, (uint8_t *)&(data[0]), data.size(), out2);
	} catch (GIFError &e) {
		return error(e.what());
	}

	// Get colours of each pixel
	vector<color> out_color(iDesc.width * iDesc.height);

	if (iDesc.p.LCT_flag) {
		for (int i = 0; i < iDesc.width * iDesc.height; i++) {
				//printf("%x (%d) ", out2[i], out2[i]);
				out_color[i] = LCT[(int)out2[i]];
		}
	} else {
		for (int i = 0; i < iDesc.width * iDesc.height; i++) {
				//printf("%x (%d) ", out2[i], out2[i]);
				out_color[i] = GCT[(int)out2[i]];
		}
	}

	// Store the decoded GIF to BMP file
	BMP::BMP bmp(iDesc.width, iDesc.height);

	bmp.Store(outputFile, &out_color);

	gif2bmp->bmpSize = bmp.StoredSize();

	// Cleanup
	free(GCT);
	free(LCT);

	return 0;
}

/* Read initial header */
void readHeader(FILE *f, gifHeader *h)
{
	fread(h, 3, 2, f);

	if (strncmp((const char *)h->signature, "GIF", 3) == 0)
		cout << "Signature: OK" << endl;
	else
		throw GIFError("Bad signature");

	if (strncmp((const char *)h->version, "87a", 3) == 0)
		throw GIFError("Version 87a is not supported");

	else if (strncmp((const char *)h->version, "89a", 3) == 0)
		cout << "Version: OK" << endl;

	else
		throw GIFError("Unknown version");

	return;
}

void readDescriptor (FILE *f, descriptor *d)
{
	fread(d, 1, 7, f);
}

void parsePackedField (descriptor *d, packedField *p)
{
	p->GCT_flag = (d->packed & 0x80) >> 7;
	p->colorResolution = (d->packed & 0x70) >> 4;
	p->sortFlag = (d->packed & 0x08) >> 3;
	p->GCT_size = (d->packed & 0x07);
}

void parseImgDescPack(imgDescPack *i, char c)
{
	i->LCT_flag = (c & 0x80) >> 7;
	i->interlace_flag = (c & 0x40) >> 6;
	i->sort_flag = (c & 0x20) >> 5;
	i->futureuse = (c & 0x18) >> 3;
	i->LCT_size = (c & 0x07);
}

int error(const char * str) {
	fprintf(stderr, "%s\n", str);
	return -1;
}

int POW(int x) {
	return(1 << x);
}


void getCode(){}

/**
  * Initialize dictionary to accomodate all of the codes
  * The size is dependent on code_length parameter
  * In case of overflow the dictionary is enlarged.
  */
int initializeDictionary(dictionary_entry_t *d, int code_length) {
	int i;
	for (i = 0; i < POW(code_length); i++) {
		d[i].byte = i;
		// XXX this only works because prev is a 32-bit int (> 12 bits)
		d[i].prev = -1;
		d[i].len = 1;
	}
	return(i+2);
}

void uncompress(int code_length,
                const unsigned char *input,
                int input_length,
                unsigned char *out) {
	int i, bit;
	int code, prev = -1;
	dictionary_entry_t *dictionary = nullptr;
	int dictionary_ind = 0;
	unsigned int mask = 0x01;
	int reset_code_length = code_length;
	int clear_code = POW(code_length); // This varies depending on code_length
	int stop_code = clear_code + 1;  // one more than clear code
	int match_len;

	// Create a dictionary large enough to hold "code_length" entries.
	// Once the dictionary overflows, code_length increases
	dictionary = (dictionary_entry_t *)
	malloc(sizeof( dictionary_entry_t ) * POW(code_length + 1));

	// Initialize the first 2^code_len entries of the dictionary with their
	// indices.  The rest of the entries will be built up dynamically.

	// Technically, it shouldn't be necessary to initialize the
	// dictionary.  The spec says that the encoder "should output a
	// clear code as the first code in the image data stream".  It doesn't
	// say must, though...
	dictionary_ind = initializeDictionary(dictionary, code_length);

	// TODO verify that the very last byte is clear_code + 1
	while (input_length) {
		code = 0x0;

		// Always read one more bit than the code length
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


		if (code == clear_code) {
			code_length = reset_code_length;
			dictionary = (dictionary_entry_t *) realloc(dictionary,
				sizeof(dictionary_entry_t) * POW(code_length + 1));

			dictionary_ind = initializeDictionary(dictionary, code_length);

			prev = -1;
			continue;
		} else if ( code == stop_code ) {
			if (input_length > 1)
				throw("Early stop code");
			break;
		}

		// Update the dictionary with this CODE and CODE-1
		if (prev > -1 && code_length < MAX_CODE_LENGTH) {
			// Check if within dictionary
			if (code > dictionary_ind) {
				throw GIFError("CODE overflow in dictionary");
			}

			// Special handling for KwKwK
			if (code == dictionary_ind) {
				int ptr = prev;

				while (dictionary[ ptr ].prev != -1) {
					ptr = dictionary[ ptr ].prev;
				}
				dictionary[ dictionary_ind ].byte = dictionary[ ptr ].byte;
			} else {
				int ptr = code;

				while ( dictionary[ ptr ].prev != -1 ) {
					ptr = dictionary[ ptr ].prev;
				}
				dictionary[ dictionary_ind ].byte = dictionary[ ptr ].byte;
			}

			dictionary[ dictionary_ind ].prev = prev;

			dictionary[ dictionary_ind ].len = dictionary[ prev ].len + 1;

			dictionary_ind++;

			// GIF89a mandates that this stops at 12 bits
			if (dictionary_ind == POW(code_length + 1) && code_length < 11) {
				code_length++;

				dictionary = (dictionary_entry_t *) realloc(dictionary,
					sizeof(dictionary_entry_t) * POW(code_length + 1));
			}
		}

		prev = code;

		// Now copy the dictionary entry backwards into "out"
		match_len = dictionary[code].len;

		while ( code != -1 ) {
			out[ dictionary[ code ].len - 1 ] = dictionary[ code ].byte;

			if ( dictionary[ code ].prev == code )
				throw GIFError("Self-reference, that's really bad error");

			code = dictionary[ code ].prev;
		}

		out += match_len;
	}
}
