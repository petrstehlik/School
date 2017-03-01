#include <iostream>
#include <unistd.h>

#include "gif2bmp.h"
#include "file.h"

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

	if (inputPath.empty()) {
		inputPath = "stdio";
	}

	if (outputPath.empty()) {
		outputPath = "stdout";
	}

	if (logPath.empty()) {
		logPath = "no loggin";
	}

	cout << "input: " << inputPath << endl;
	cout << "output: " << outputPath << endl;
	cout << "log: " << logPath << endl;

	File inputFile = File(inputPath.c_str());

	inputFile.read();

	for (auto item : inputFile.get()) {
		cout << item;
	}
}
