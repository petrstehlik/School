typedef struct {
	int64_t bmpSize;
	int64_t gifSize;
} tGIF2BMP;

/*
 * @param gif2bmp zaznam o prevodu
 * @param inputFile vstupni soubor (GIF)
 * @param outputFile vystupni soubor (BMP)
 *
 * @return 0 prevod probehl v poradku
 * @return -1 pri prevodu doslo k chybe, prip. nepodporuje dany format GIF
 */
int gif2bmp(tGIF2BMP *gif2bmp, FILE *inputFile, FILE *outputFile);
