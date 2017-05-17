/**
  * gif2bmp base header and GIFError exception.
  *
  * Author: Petr Stehlik <xstehl14@stud.fit.vutbr.cz>
  * Date: 2017/05/07
  *
  * file: gif2bmp.h
  */


#pragma once

#include <sys/types.h>
#include <vector>
#include <string>

struct color {
	uint8_t r;
	uint8_t g;
	uint8_t b;
};

typedef struct {
	int64_t bmpSize;
	int64_t gifSize;
} tGIF2BMP;


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
