#pragma once

#include <sys/types.h>
#include <vector>
#include <string>
#include <cstring>
#include <unistd.h>
#include <iostream>

#include "gif2bmp.h"

#define IMAGE_DESCRIPTOR	0x2C
#define TRAILER				0x3B
#define GRAPHIC_CONTROL		0xF9
#define APPLICATION_EXT		0xFF
#define COMMENT_EXT			0xFE
#define PLAINTEXT_EXT		0x01
#define MAX_CODE_LENGTH		12

#ifndef DEBUG
#define DEBUG false
#endif

class GIF {
private:

	typedef uint8_t byte;

	struct GIFError : public std::exception {
	   std::string s;
	   GIFError(std::string ss) : s(ss) {}
	   ~GIFError() throw () {}
	   const char* what() const throw() { return s.c_str(); }
	};


	#pragma pack(push, 1)
	typedef struct {
		uint8_t signature[3];
		uint8_t version[3];
	} header_t;

	typedef struct {
		uint16_t width;
		uint16_t height;
		uint8_t packed;
		uint8_t bgColorIndex;
		uint8_t aspectRatio;
	} descriptor_t;

	typedef struct {
		uint8_t GCT_flag;
		uint8_t colorResolution;
		uint8_t sortFlag;
		uint8_t GCT_size;
	} packedField;

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

	typedef struct {
		uint8_t byte;
		int32_t prev;
		int len;
	} dictionary_entry_t;


	#pragma pack(pop)


	FILE *input;

	header_t header;
	descriptor_t descriptor;
	imgDescriptor logical_screen_descriptor;

	std::vector<color> pixel_data;

protected:
	void readHeader();
	void parsePackedField (descriptor_t *d, packedField *p);
	void parseImgDescPack(imgDescPack *i, char c);
	int initializeDictionary(dictionary_entry_t *d, int code_length);
	void decompress(int code_length, const unsigned char *input, int input_length,
                unsigned char *out);
public:
	GIF(FILE *fp);
	int Convert();
	std::vector<color> * GetData() {
		return &(this->pixel_data);
	};

	void interlace();

	uint16_t width() {
		return this->logical_screen_descriptor.width;
	}

	uint16_t height() {
		return this->logical_screen_descriptor.height;
	}

	bool has_LCT() {
		return this->logical_screen_descriptor.p.LCT_flag;
	}

	bool has_interlace() {
		return this->logical_screen_descriptor.p.interlace_flag;
	}

	uint8_t LCT_size() {
		return this->logical_screen_descriptor.p.LCT_size;
	}

	int POW(int x) {
		return(1 << x);
	}

	int error(const char * str) {
		fprintf(stderr, "%s\n", str);
		return -1;
	}
};
