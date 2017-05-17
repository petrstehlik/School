/**
  * BMP class definition. Handles all BMP file operations.
  *
  * Author: Petr Stehlik <xstehl14@stud.fit.vutbr.cz>
  * Date: 2017/05/07
  *
  * file: bmp.h
  */

#pragma once

#include <sys/types.h>
#include <unistd.h>
#include <algorithm>

#include "gif2bmp.h"

class BMP {
private:

	#pragma pack(push, 1)
	/**
	  * FILE HEADER (14 bytes)
	  */
	typedef struct {
		uint8_t type[2];	/* Magic identifier */
		uint32_t size;		/* File size in bytes          */
		uint32_t reserved;
		uint32_t offset;	/* Offset to image data in bytes */
	} bmpHeader_t;

	/**
	  * INFO HEADER (40 bytes)
	  */
	typedef struct {
		uint32_t size;				/* Header size in bytes      */
		uint32_t width;
		uint32_t height;			/* Width and height of image */
		uint16_t planes;			/* Number of colour planes   */
		uint16_t bits;				/* Bits per pixel            */
		uint32_t compression;		/* Compression type          */
		uint32_t imagesize;			/* Image size in bytes       */
		uint32_t xresolution;
		uint32_t yresolution;		/* Pixels per meter          */
		uint32_t ncolours;			/* Number of colours         */
		uint32_t importantcolours;	/* Important colours         */
	} bmpInfoHeader_t;
	#pragma pack(pop)

	/**
	  * dimensions of the image
	  */
	int x;
	int y;

	/**
	  * file header
	  */
	bmpHeader_t header;

	/**
	  * information header
	  */
	bmpInfoHeader_t infoHeader;

protected:
	/**
	  * Initialize file header with default values
	  *
	  * The only thing needed to write afterwards is the size
	  */
	void initHeader();

	/**
	  * Initialize information header with default values
	  */
	void initInfoHeader();

public:
	BMP(int width, int height);
	void Store(FILE *fp, std::vector<color> *data);
};

