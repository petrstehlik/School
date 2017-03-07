#include <iostream>
#include <stdio.h>
#include <cstring>
#include <cmath>

#include <sys/types.h>
#include <unistd.h>

#include "gif2bmp.h"

using namespace std;

typedef uint8_t byte;

int gif2bmp(tGIF2BMP *gif2bmp, FILE *inputFile, FILE *outputFile)
{
	gifHeader hdr;
	descriptor desc;
	packedField packedF;
	int GCT_length = 0;
	color *GCT = NULL;

	readHeader(inputFile, &hdr);

	fread(&desc, 1, 7, inputFile);

	parsePackedField(&desc, &packedF);

	if (packedF.GCT_flag) {
		GCT_length = pow(2, (int)packedF.GCT_size + 1);

		GCT = (color *)malloc(sizeof(color) * GCT_length);

		for (int var = 0; var < GCT_length; ++var) {
			fread(&(GCT[var]), sizeof(color), 1, inputFile);
			//printf("Color %d: %d %d %d\n",var, GCT[var].r, GCT[var].g, GCT[var].b);
		}

		cout << "Global Color Table: OK" << endl;
	} else {
		cout << "No GCT found" << endl;
	}

	uint8_t extension_flag = fgetc(inputFile);

	while (extension_flag == 0x21) {

		printf("Extension flag found!\n");

		uint8_t control_label = fgetc(inputFile);

		if (control_label == 0xF9) {
			printf("Control label found!\n");

			GCE ext;

			fread(&ext, sizeof(GCE), 1, inputFile);

			printf("size of extension: %d\n", ext.size);

			if (ext.terminator != 0x00)
				throw GIFError("Graphic Control Extension not terminated correctly");
		}

		extension_flag = fgetc(inputFile);
	}

	if (extension_flag == 0x2C) {
		cout << "Image separator found" << endl;

		imgDescriptor iDesc;
		imgDescPack p;

		fread(&iDesc, sizeof(uint16_t), 4, inputFile);

		printf("width: %d\n", iDesc.width);
		printf("height: %d\n", iDesc.height);

		parseImgDescPack(&p, fgetc(inputFile));

		iDesc.p = p;

		if ((bool)iDesc.p.LCT_flag) {
			cout << "LCT is present" << endl;
			cout << "LCT size: " << (int)iDesc.p.LCT_size << endl;

			uint16_t LCT_length = pow(2, (int)iDesc.p.LCT_size + 1);
			cout << "LCT length: " << (int)LCT_length << endl;

			color *LCT = (color *)malloc(sizeof(color) * LCT_length);

			for (int var = 0; var < LCT_length; ++var) {
				fread(&(LCT[var]), sizeof(color), 1, inputFile);
				//printf("Color %d: %d %d %d\n",var, GCT[var].r, GCT[var].g, GCT[var].b);
			}

			free(LCT);

		}
	}

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
			for (auto it : tmp_data)
				cout << std::hex << (int)it << " ";

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
	if ((byte)fgetc(inputFile) != 0x3B) {
		throw GIFError("Trailer byte not found!");
	}

	if (DEBUG)
		cout << "data size: " << data.size() << endl;

	// TODO: Decompress acquired data

	// TODO: Create BMP file

	free(GCT);

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

	if (strncmp((const char *)h->version, "87a", 3) == 0 ||
			strncmp((const char *)h->version, "89a", 3) == 0)
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
