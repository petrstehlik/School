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
