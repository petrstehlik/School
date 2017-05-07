#include <iostream>
#include <unistd.h>

#include "gif2bmp.h"
#include "bmp.h"
//#include "file.h"

using namespace std;

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
				cout << "Should print help" << endl;
				break;
			default:
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

	if (!inputPath.empty())
		fclose(input);

	if (!outputPath.empty())
		fclose(output);

	return 0;
}
