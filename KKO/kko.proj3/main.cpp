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

	cout << "input: " << inputPath << endl;
	cout << "output: " << outputPath << endl;
	cout << "log: " << logPath << endl;

	tGIF2BMP sizeInfo;

	FILE *fp = fopen(inputPath.c_str(), "r+");
	FILE *output = fopen(outputPath.c_str(), "wb+");

	gif2bmp(&sizeInfo, fp, output);

	fclose(fp);
}
