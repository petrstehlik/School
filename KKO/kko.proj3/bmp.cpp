#include "bmp.h"

using namespace std;

void BMP::initHeader() {
	header.type[0] = 'B';
	header.type[1] = 'M';
	header.size = 54;
	header.reserved = 0;
	header.offset = 54;
}

void BMP::initInfoHeader() {
	infoHeader.size = 40;
	infoHeader.width = this->x;
	infoHeader.height = this->y;
	infoHeader.planes = 1;
	infoHeader.bits = 24;
	infoHeader.compression = 0;
	infoHeader.imagesize = 0;
	infoHeader.xresolution = 0;
	infoHeader.yresolution = 0;
	infoHeader.ncolours = 0;
	infoHeader.importantcolours = 0;
}

BMP::BMP(int width, int height) {
	this->x = width;
	this->y = height;

	initHeader();
	initInfoHeader();
}

void BMP::Store(FILE *fp, vector<color> *data) {
	vector<uint8_t> pad_data;

	// Compute padding
	int padding = 4 - ((this->x * 3) % 4);

	// "decompress" and pad data
	for (unsigned int i = 0; i < data->size(); i++) {
		pad_data.push_back(data->at(i).b);
		pad_data.push_back(data->at(i).g);
		pad_data.push_back(data->at(i).r);

		if (i > 0 && ((i+1) % this->x == 0)) {
			for(int tmp_i = 0; tmp_i < padding; tmp_i++)
				pad_data.push_back(0);
		}
	}

	// Set the header size
	this->header.size = 54 + pad_data.size();

	// Write the headers
	fwrite(&header, 1, sizeof(bmpHeader_t), fp);
	fwrite(&infoHeader, 1, sizeof(bmpInfoHeader_t), fp);

	// Swap lines for output
	int lineWidth = this->x*3 + padding;
	for (int line = pad_data.size()/lineWidth - 1; line >= 0; line--) {
		fwrite(&pad_data[line * lineWidth], lineWidth, 1, fp);
	}
}
