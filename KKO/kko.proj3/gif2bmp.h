// GCT

#ifndef DEBUG
#define DEBUG false
#endif

#pragma once

#include <sys/types.h>
#include <vector>


#define IMAGE_DESCRIPTOR	0x2C
#define TRAILER				0x3B
#define GRAPHIC_CONTROL		0xF9
#define APPLICATION_EXT		0xFF
#define COMMENT_EXT			0xFE
#define PLAINTEXT_EXT		0x01
#define MAX_CODE_LENGTH		12

typedef struct {
	int64_t bmpSize;
	int64_t gifSize;
} tGIF2BMP;

#pragma pack(push, 1)
typedef struct {
	uint8_t signature[3];
	uint8_t version[3];
} gifHeader;

typedef struct {
	uint16_t width;
	uint16_t height;
	uint8_t packed;
	uint8_t bgColorIndex;
	uint8_t aspectRatio;
} descriptor;

typedef struct {
	uint8_t GCT_flag;
	uint8_t colorResolution;
	uint8_t sortFlag;
	uint8_t GCT_size;
} packedField;

struct color {
	uint8_t r;
	uint8_t g;
	uint8_t b;
};

typedef struct {
	uint8_t size;
	uint8_t packed;
	uint16_t delay;
	uint8_t transparentColorIdx;
	uint8_t terminator;
} GCE;

typedef struct {
	bool LCT_flag;
	bool interlace_flag;
	bool sort_flag;
	uint8_t futureuse;
	uint8_t LCT_size;
} imgDescPack;

typedef struct {
	uint16_t pos_left;
	uint16_t pos_top;
	uint16_t width;
	uint16_t height;
	imgDescPack p;
} imgDescriptor;

#pragma pack(pop)

typedef struct {
	uint8_t byte;
	int32_t prev;
	int len;
} dictionary_entry_t;


struct GIFError : public std::exception
{
   std::string s;
   GIFError(std::string ss) : s(ss) {}
   ~GIFError() throw () {} // Updated
   const char* what() const throw() { return s.c_str(); }
};

/*
 * @param gif2bmp zaznam o prevodu
 * @param inputFile vstupni soubor (GIF)
 * @param outputFile vystupni soubor (BMP)
 *
 * @return 0 prevod probehl v poradku
 * @return -1 pri prevodu doslo k chybe, prip. nepodporuje dany format GIF
 */
int gif2bmp(tGIF2BMP *gif2bmp, FILE *inputFile, FILE *outputFile);

void readHeader(FILE *f, gifHeader *h);
void readDescriptor (FILE *f, descriptor *d);
void parsePackedField(descriptor *d, packedField *p);
void parseImgDescPack(imgDescPack *i, char c);


/** Parse color table
  *
  * The color table can be global or local, it doesn't matter
  *
  * @param FILE * inFile input file
  */
//void parseColorTable(FILE *inFile, colorTable_t *table);


void uncompress( int code_length,
                const unsigned char *input,
                int input_length,
                unsigned char *out );

