#include <iostream>
#include <stdio.h>
#include <cstring>
#include <cmath>

#include "gif2bmp.h"

using namespace std;

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

		fread(&iDesc, sizeof(imgDescriptor), 1, inputFile);

		printf("width: %d\n", iDesc.width);
		printf("height: %d\n", iDesc.height);

		parseImgDescPack(&(iDesc.p), fgetc(inputFile));
	}

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

	return;
}
