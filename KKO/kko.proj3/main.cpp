#include <iostream>
#include <unistd.h>
#define __STDC_FORMAT_MACROS
#include <inttypes.h>

#include "gif2bmp.h"
#include "bmp.h"
//#include "file.h"

using namespace std;

void printHelp() {
	cout << "GIF to BMP converter (KKO project version 2)" << endl
		<< "Author: Petr Stehlik <xstehl14@stud.fit.vutbr.cz> (c)2017" << endl
		<< "Usage:" << endl
		<< "\t-i Path to input file [default: stdin]" << endl
		<< "\t-o Path to output file [default: stdout]" << endl
		<< "\t-l Path to log file [default: stderr]" << endl
		<< "\t-h Print this help" << endl;
}

int main(int argc, char **argv) {
	string inputPath, outputPath, logPath;
	char c;

	while ((c = getopt (argc, argv, "i:o:l:h")) != -1) {
		switch (c) {
			case 'i':
				inputPath = string(optarg);
				break;
			case 'o':
				outputPath = string(optarg);
				break;
			case 'l':
				logPath = optarg;
				break;
			case 'h':
				printHelp();
				return EXIT_SUCCESS;
			default:
				cerr << "Unsupported argument"<< endl;
				printHelp();
				return EXIT_FAILURE;
		}
	}

	tGIF2BMP sizeInfo;

	FILE *input = inputPath.empty() ? stdin : fopen(inputPath.c_str(), "r+");
	FILE *output = outputPath.empty() ? stdout : fopen(outputPath.c_str(), "wb+");

	if (output == NULL) {
		cerr << "Failed to open output file" << endl;
		return EXIT_FAILURE;
	}

	if (input == NULL) {
		cerr << "Failed to open input file" << endl;
		return EXIT_FAILURE;
	}
	if (gif2bmp(&sizeInfo, input, output) != 0) {
		fprintf(stderr, "Error occured while converting\n");
	}

	// Print the conversion info
	if (!logPath.empty()) {

		FILE *l = fopen(logPath.c_str(), "w+");

		if (l == NULL) {
			cerr << "failed to open log file" << endl;
			return EXIT_FAILURE;
		}
		fprintf(l, "login = xstehl14\n"
			"uncodedSize = %" PRId64 "\n"
			"codedSize = %" PRId64 "\n", sizeInfo.gifSize, sizeInfo.bmpSize);
	}

	fclose(input);
	fclose(output);

	return EXIT_SUCCESS;
}
