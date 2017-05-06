#pragma once

#include <sys/types.h>
#include <iostream>
#include <stdio.h>
#include <cstring>
#include <cmath>

#include <unistd.h>

#include <algorithm>

#include "gif2bmp.h"

class BMP {
private:

	#pragma pack(push, 1)
	typedef struct {
		uint8_t type[2];		/* Magic identified */
		uint32_t size;		/* File size in bytes          */
		uint32_t reserved;
		uint32_t offset;                     /* Offset to image data, bytes */
	} bmpHeader_t;

	/* INFO HEADER 40 bytes */
	typedef struct {
		uint32_t size;               /* Header size in bytes      */
		uint32_t width;
		uint32_t height;                /* Width and height of image */
		uint16_t planes;       /* Number of colour planes   */
		uint16_t bits;         /* Bits per pixel            */
		uint32_t compression;        /* Compression type          */
		uint32_t imagesize;          /* Image size in bytes       */
		uint32_t xresolution;
		uint32_t yresolution;     /* Pixels per meter          */
		uint32_t ncolours;           /* Number of colours         */
		uint32_t importantcolours;   /* Important colours         */
	} bmpInfoHeader_t;
	#pragma pack(pop)

	int size;
	int x;
	int y;

	bmpHeader_t header;
	bmpInfoHeader_t infoHeader;

protected:
	void initHeader();
	void initInfoHeader();

public:
	BMP(int width, int height);
	void Store(FILE *fp, std::vector<color> *data);

	/**
	  * @return number of bytes written (file size)
	  */
	int StoredSize();
};

