#include <iostream>
#include <unistd.h>

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

	if (logPath.empty()) {
		logPath = "no loggin";
	}

	cerr << "input: " << inputPath << endl;
	cerr << "output: " << outputPath << endl;
	cerr << "log: " << logPath << endl;

	tGIF2BMP sizeInfo;

	FILE *input = inputPath.empty() ? stdin : fopen(inputPath.c_str(), "r+");
	FILE *output = outputPath.empty() ? stdout : fopen(outputPath.c_str(), "wb+");

	if (gif2bmp(&sizeInfo, input, output) != 0) {
		fprintf(stderr, "Error occured while converting\n");
	}

	cerr << "login = xstehl14" << endl;
	cerr << "uncodedSize = " << sizeInfo.gifSize << endl;
	cerr << "codedSize = " << sizeInfo.bmpSize << endl;

	fclose(input);
	fclose(output);

	return EXIT_SUCCESS;
}
