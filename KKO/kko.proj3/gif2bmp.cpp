#include <iostream>
#include <stdio.h>
#include <cstring>
#include <cmath>

#include <sys/types.h>
#include <unistd.h>

#include "gif2bmp.h"
#include "bmp.h"

using namespace std;

typedef uint8_t byte;

int gif2bmp(tGIF2BMP *gif2bmp, FILE *inputFile, FILE *outputFile)
{
	gifHeader hdr;
	descriptor desc;
	packedField packedF;
	int GCT_length = 0;
	color *GCT = NULL;
	int clearCode, stopCode, code_length;

	readHeader(inputFile, &hdr);

	fread(&desc, 1, 7, inputFile);

	parsePackedField(&desc, &packedF);

	/**
	  * If present, parse global color table
	  */
	if (packedF.GCT_flag) {
		GCT_length = pow(2, (int)packedF.GCT_size + 1);
		code_length = packedF.GCT_size + 1;
		clearCode = GCT_length;
		stopCode = GCT_length+1;

		GCT = (color *)malloc(sizeof(color) * GCT_length);

		for (int var = 0; var < GCT_length; ++var) {
			fread(&(GCT[var]), sizeof(color), 1, inputFile);
			//printf("Color %d: %d %d %d\n",var, GCT[var].r, GCT[var].g, GCT[var].b);
		}

		cout << "GCT len: " << GCT_length << endl;
		cout << "Global Color Table: OK" << endl;
		for (int i = 0; i < GCT_length; i++) {
			cout << i << " (" << (int)GCT[i].r << ", " << (int)GCT[i].g << ", " << (int)GCT[i].b << ")" << endl;
		}
	} else {
		cout << "No GCT found" << endl;
	}

	/**
	  * EXTENSION FLAG parsing
	  */
	uint8_t extension_flag = fgetc(inputFile);

	while (extension_flag == 0x21) {

		printf("Extension flag found!\n");

		uint8_t control_label = fgetc(inputFile);

		if (control_label == 0xF9) {
			printf("Control label found!\n");

			GCE ext;

			fread(&ext, sizeof(GCE), 1, inputFile);

			printf("size of extension: %d\n", ext.size);

			if (ext.terminator != 0x00)
				throw GIFError("Graphic Control Extension not terminated correctly");
		}

		extension_flag = fgetc(inputFile);
	}

	imgDescriptor iDesc;

	/**
	  * Check for extension flags
	  */
	if (extension_flag == IMAGE_DESCRIPTOR) {
		cout << "Image descriptor found" << endl;

		imgDescPack p;

		fread(&iDesc, sizeof(uint16_t), 4, inputFile);

		printf("width: %d\n", iDesc.width);
		printf("height: %d\n", iDesc.height);

		parseImgDescPack(&p, fgetc(inputFile));

		iDesc.p = p;

		if ((bool)iDesc.p.LCT_flag) {
			cout << "LCT is present" << endl;
			cout << "LCT size: " << (int)iDesc.p.LCT_size << endl;

			uint16_t LCT_length = pow(2, (int)iDesc.p.LCT_size + 1);
			cout << "LCT length: " << (int)LCT_length << endl;

			color *LCT = (color *)malloc(sizeof(color) * LCT_length);

			for (int var = 0; var < LCT_length; ++var) {
				fread(&(LCT[var]), sizeof(color), 1, inputFile);
				//printf("Color %d: %d %d %d\n",var, GCT[var].r, GCT[var].g, GCT[var].b);
			}

			free(LCT);

		}
	}

	/**
	  * Acquire data from the file
	  */
	// Now we are going to parse data
	uint8_t minCodeSize = fgetc(inputFile);

	cout << "Min code size: " << (int)minCodeSize << endl;
	uint8_t subBlockSize = fgetc(inputFile);
	vector<byte> data;

	while (true) {
		if (DEBUG)
			cout << "Sub block size: " << (int)subBlockSize << endl;

		vector<byte> tmp_data((int)subBlockSize);

		for (int i = 0; i < (int)subBlockSize; ++i) {
			tmp_data[i] = fgetc(inputFile);
		}

		data.insert(data.end(), tmp_data.begin(), tmp_data.end());

		// Print the loaded data
		if (DEBUG) {
			for (auto it : tmp_data) {
				//cout << std::dec << endl;
				//cout << "color index: " << (int)it << "\t" << std::hex << (int)it << endl;
				cout << std::hex << (int)it << " " << endl;
				//printf("Color %d: (%d, %d, %d)\n", (int)it, GCT[(int)it].r, GCT[(int)it].g, GCT[(int)it].b);
			}

			// Reset cout to use decimal again
			cout << std::dec << endl;
		}

		// Get next block size
		subBlockSize = fgetc(inputFile);

		// End of data
		if (subBlockSize == 0x00) {
			if (DEBUG)
				cout << "End of data" << endl;
			break;
		}
	}

	// Check the trailer byte
	if ((byte)fgetc(inputFile) != TRAILER) {
		throw GIFError("Trailer byte not found!");
	}

	if (DEBUG)
		cout << "data size: " << data.size() << endl;

	// TODO: Decompress acquired data

	// Dictionary to hold decompressed data
	int dict_i = 0;
	dictionary_entry_t *dictionary;
	// Create a dictionary large enough to hold "GCT_length" entries.
	// Once the dictionary overflows, GCT_length increases
	dictionary = (dictionary_entry_t *)
		malloc(sizeof(dictionary_entry_t) * ( 1 << ( code_length + 1 ) ));

	for (dict_i = 0; dict_i < (1 << code_length); dict_i++ )
	{
		dictionary[dict_i].byte = dict_i;
		// XXX this only works because prev is a 32-bit int (> 12 bits)
		dictionary[dict_i].prev = -1;
		dictionary[dict_i].len = 1;
	}

	//int32_t code;
	//uint32_t bit;
	//uint32_t mask = 0x01;
	//uint8_t *input = (uint8_t *)&(data[0]);
	//int input_len = data.size();
	//int reset_code_length = code_length;
	//int prev = -1;
	//uint8_t *output;
	//int match_len;

	//output = (uint8_t *) malloc(iDesc.width * iDesc.height);

	clearCode = (1 << (code_length));

	//for (int i = 0; i < input_len; i++) {
	//	printf("input: %x\n", input[i]);
	//}

	uint8_t * out2;
	out2 = (uint8_t *)malloc (sizeof(uint8_t) * iDesc.width * iDesc.height);

	uncompress(code_length, (uint8_t *)&(data[0]), data.size(), out2);

	// Get colours of each pixel
	vector<color> out_color(iDesc.width * iDesc.height);

	for (int i = 0; i < iDesc.width * iDesc.height; i++) {
			//printf("%x (%d) ", out2[i], out2[i]);
			out_color[i] = GCT[(int)out2[i]];
	}


	// TODO: Create BMP file

	writeFile(outputFile, iDesc.width, iDesc.height, &out_color);

	free(GCT);
	free(dictionary);

	return 0;
}

/* Read initial header */
void readHeader(FILE *f, gifHeader *h)
{
	fread(h, 3, 2, f);

	if (strncmp((const char *)h->signature, "GIF", 3) == 0)
		cout << "Signature: OK" << endl;
	else
		throw GIFError("Bad signature");

	if (strncmp((const char *)h->version, "87a", 3) == 0 ||
			strncmp((const char *)h->version, "89a", 3) == 0)
		cout << "Version: OK" << endl;
	else
		throw GIFError("Unknown version");

	return;
}

void readDescriptor (FILE *f, descriptor *d)
{
	fread(d, 1, 7, f);
}

void parsePackedField (descriptor *d, packedField *p)
{
	p->GCT_flag = (d->packed & 0x80) >> 7;
	p->colorResolution = (d->packed & 0x70) >> 4;
	p->sortFlag = (d->packed & 0x08) >> 3;
	p->GCT_size = (d->packed & 0x07);
}

void parseImgDescPack(imgDescPack *i, char c)
{
	i->LCT_flag = (c & 0x80) >> 7;
	i->interlace_flag = (c & 0x40) >> 6;
	i->sort_flag = (c & 0x20) >> 5;
	i->futureuse = (c & 0x18) >> 3;
	i->LCT_size = (c & 0x07);
}














void uncompress( int code_length,
                const unsigned char *input,
                int input_length,
                unsigned char *out )
{
  //int maxbits;
  int i, bit;
  int code, prev = -1;
  dictionary_entry_t *dictionary;
  int dictionary_ind;
  unsigned int mask = 0x01;
  int reset_code_length;
  int clear_code; // This varies depending on code_length
  int stop_code;  // one more than clear code
  int match_len;

  clear_code = 1 << ( code_length );

  printf("CC: %d, CL: %d\n", clear_code, 1 << ( code_length + 1 ));
  stop_code = clear_code + 1;
  // To handle clear codes
  reset_code_length = code_length;

  // Create a dictionary large enough to hold "code_length" entries.
  // Once the dictionary overflows, code_length increases
  dictionary = ( dictionary_entry_t * ) 
    malloc( sizeof( dictionary_entry_t ) * ( 1 << ( code_length + 1 ) ) );

  // Initialize the first 2^code_len entries of the dictionary with their
  // indices.  The rest of the entries will be built up dynamically.

  // Technically, it shouldn't be necessary to initialize the
  // dictionary.  The spec says that the encoder "should output a
  // clear code as the first code in the image data stream".  It doesn't
  // say must, though...
  for ( dictionary_ind = 0; 
        dictionary_ind < ( 1 << code_length ); 
        dictionary_ind++ )
  {
    dictionary[ dictionary_ind ].byte = dictionary_ind;
    // XXX this only works because prev is a 32-bit int (> 12 bits)
    dictionary[ dictionary_ind ].prev = -1;
    dictionary[ dictionary_ind ].len = 1;
  }

  // 2^code_len + 1 is the special "end" code; don't give it an entry here
  dictionary_ind++;
  dictionary_ind++;


  for (int i = 0; i < input_length; i++) {
	printf("input: %x\n", input[i]);
  }
  
  // TODO verify that the very last byte is clear_code + 1
  while ( input_length )
  {
    code = 0x0;
    // Always read one more bit than the code length
    for ( i = 0; i < ( code_length + 1 ); i++ )
    {
      // This is different than in the file read example; that 
      // was a call to "next_bit"
      bit = ( *input & mask ) ? 1 : 0;
      mask <<= 1;

      if ( mask == 0x100 )
      {
        mask = 0x01;
        input++;
        input_length--;
      }

      code = code | ( bit << i );
    }
    //printf("code: %x\n", code);


    if ( code == clear_code )
    {
      code_length = reset_code_length;
      dictionary = ( dictionary_entry_t * ) realloc( dictionary,
        sizeof( dictionary_entry_t ) * ( 1 << ( code_length + 1 ) ) );

      for ( dictionary_ind = 0; 
            dictionary_ind < ( 1 << code_length ); 
            dictionary_ind++ )
      {
        dictionary[ dictionary_ind ].byte = dictionary_ind;
        // XXX this only works because prev is a 32-bit int (> 12 bits)
        dictionary[ dictionary_ind ].prev = -1;
        dictionary[ dictionary_ind ].len = 1;
      }
      dictionary_ind++;
      dictionary_ind++;
      prev = -1;
      continue;
    }
    else if ( code == stop_code )
    {
      if ( input_length > 1 )
      {
        fprintf( stderr, "Malformed GIF (early stop code)\n" );
        exit( 0 );
      }
      break;
    }

    // Update the dictionary with this character plus the _entry_
    // (character or string) that came before it
    if ( ( prev > -1 ) && ( code_length < 12 ) )
    {
      if ( code > dictionary_ind )
      {
        fprintf( stderr, "code = %.02x, but dictionary_ind = %.02x\n",
          code, dictionary_ind );
        exit( 0 );
      }

      // Special handling for KwKwK
      if ( code == dictionary_ind )
      {
        int ptr = prev;

        while ( dictionary[ ptr ].prev != -1 )
        {
          ptr = dictionary[ ptr ].prev;
        }
        dictionary[ dictionary_ind ].byte = dictionary[ ptr ].byte;
      }
      else
      {
        int ptr = code;
        while ( dictionary[ ptr ].prev != -1 )
        {
          ptr = dictionary[ ptr ].prev;
        }
        dictionary[ dictionary_ind ].byte = dictionary[ ptr ].byte;
      }

      dictionary[ dictionary_ind ].prev = prev;

      dictionary[ dictionary_ind ].len = dictionary[ prev ].len + 1;

      dictionary_ind++;

      // GIF89a mandates that this stops at 12 bits
      if ( ( dictionary_ind == ( 1 << ( code_length + 1 ) ) ) &&
           ( code_length < 11 ) )
      {
        code_length++;

        dictionary = ( dictionary_entry_t * ) realloc( dictionary,
          sizeof( dictionary_entry_t ) * ( 1 << ( code_length + 1 ) ) );
      }
    }

    prev = code;

    // Now copy the dictionary entry backwards into "out"
    match_len = dictionary[ code ].len;
    while ( code != -1 )
    {
      out[ dictionary[ code ].len - 1 ] = dictionary[ code ].byte;

      //printf("byte: %d\n", dictionary[ code ].byte);
      if ( dictionary[ code ].prev == code )
      {
        fprintf( stderr, "Internal error; self-reference." );
        exit( 0 );
      }
      code = dictionary[ code ].prev;
    }

    out += match_len;
  }
}

