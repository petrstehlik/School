/**
  * gif2bmp implementation, only uses GIF and BMP classes and computes the
  * file sizes for tGIF2BMP struct.
  *
  * Author: Petr Stehlik <xstehl14@stud.fit.vutbr.cz>
  * Date: 2017/05/07
  *
  * file: gif2bmp.cpp
  */

#include "gif2bmp.h"
#include "bmp.h"
#include "gif.h"

int gif2bmp(tGIF2BMP *gif2bmp, FILE *inputFile, FILE *outputFile) {
	GIF gif(inputFile);

	if (gif.Convert() != 0) {
		return -1;
	}

	// Store the decoded GIF to BMP file
	BMP bmp(gif.width(), gif.height());

	bmp.Store(outputFile, gif.GetData());

	gif2bmp->bmpSize = ftell(outputFile);
	gif2bmp->gifSize = ftell(inputFile);

	return 0;
}
