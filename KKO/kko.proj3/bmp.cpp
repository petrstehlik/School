#include <sys/types.h>
#include <iostream>
#include <stdio.h>
#include <cstring>
#include <cmath>
#include <vector>

#include <unistd.h>


#include "bmp.h"
#include "gif2bmp.h"

using namespace std;

void initHeader(bmpHeader_t *h) {
	h->type[0] = 'B';
	h->type[1] = 'M';
	h->reserved = 0;
	h->offset = 54;
}

void initInfoHeader(bmpInfoHeader_t *h) {
	h->size = 40;
	h->width = 0;
	h->height = 0;
	h->planes = 1;
	h->bits = 24;
	h->compression = 0;
	h->imagesize = 0;
	h->xresolution = 0;
	h->yresolution = 0;
	h->ncolours = 0;
	h->importantcolours = 0;
}

vector<color> swapLines(vector<color> *data, uint32_t x) {
	vector<color> tmp;

	for(int i = 0; i < data->size(); i++) {
		//cout << "I: " <<  << endl;
		tmp.insert(tmp.end(), data->end() - (i*3 - x*3), data->end() - (i*3));
	}

	return tmp;
}

void writeFile(FILE *fp, uint32_t x, uint32_t y, vector<color> *data) {
	bmpHeader_t header;
	bmpInfoHeader_t infoHeader;

	vector<uint8_t> pad_data;

	int padding = 4 - ((x * 3) % 4);

	for (uint32_t i = 0; i < data->size(); i++) {
		pad_data.push_back(data->at(i).b);
		pad_data.push_back(data->at(i).g);
		pad_data.push_back(data->at(i).r);

		if (i > 0 && ((i+1) % x == 0)) {
			for(int tmp_i = 0; tmp_i < padding; tmp_i++) {
				pad_data.push_back(0);
			}
		}
	}

	initHeader(&header);
	header.size = 14 + 40 + (pad_data.size());

	initInfoHeader(&infoHeader);
	infoHeader.width = x;
	infoHeader.height = y;

	fwrite(&header, 1, sizeof(bmpHeader_t), fp);
	fwrite(&infoHeader, 1, sizeof(bmpInfoHeader_t), fp);


	// Swap lines for output
	int lineWidth = x*3 + padding;
	for (int y = pad_data.size()/lineWidth - 1; y >= 0; y--) {
		fwrite(&pad_data[y * lineWidth], lineWidth, 1, fp);
	}
}
