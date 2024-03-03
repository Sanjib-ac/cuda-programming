#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <iostream>
#include <string>
#include <filesystem>

#include <fstream>
#include <iostream>
#include <string>
#include <array>
#include <vector>
#include <iterator>

using namespace std;
//using fs = std::filesystem;

__global__
void ImageFilter(int* w, int* h, int* out, int n)
{
	int i = blockDim.x * blockIdx.x + threadIdx.x;
	if (i < n)
	{
		out[i] = w[i] + h[i];
	}
}
void ReadImages();

unsigned char* readBMP_v1(char* filename)
{
	int i;
	FILE* f = fopen(filename, "rb");
	unsigned char info[54];
	fread(info, sizeof(unsigned char), 54, f); // read the 54-byte header

	// extract image height and width from header
	int width, height;
	memcpy(&width, info + 18, sizeof(int));
	memcpy(&height, info + 22, sizeof(int));

	int heightSign = 1;
	if (height < 0) {
		heightSign = -1;
	}

	int size = 3 * width * abs(height);
	unsigned char* data = new unsigned char[size]; // allocate 3 bytes per pixel
	fread(data, sizeof(unsigned char), size, f); // read the rest of the data at once
	fclose(f);

	if (heightSign == 1) {
		for (i = 0; i < size; i += 3)
		{
			//code to flip the image data here....
		}
	}
	return data;
}
std::vector<char> readBMP(const std::string& file)
{
	static constexpr size_t HEADER_SIZE = 54;

	std::ifstream bmp(file, std::ios::binary);

	std::array<char, HEADER_SIZE> header;
	bmp.read(header.data(), header.size());
	if (header[0] != 'B' || header[1] != 'M')
	{
		std::cout << "File is not a BMP image file" << std::endl;
		exit(0);
	}
	else
	{
		std::cout << "It's a BMP file." << endl;
	}
	auto fileSize = *reinterpret_cast<uint32_t*>(&header[2]);
	auto dataOffset = *reinterpret_cast<uint32_t*>(&header[10]);
	auto width = *reinterpret_cast<uint32_t*>(&header[18]);
	auto height = *reinterpret_cast<uint32_t*>(&header[22]);
	auto planes = *reinterpret_cast<uint16_t*>(&header[26]);
	auto depth = *reinterpret_cast<uint16_t*>(&header[28]);
	auto compression = *reinterpret_cast<uint32_t*>(&header[30]);
	auto size = *reinterpret_cast<uint32_t*>(&header[34]);
	auto h_resolution = *reinterpret_cast<uint32_t*>(&header[38]);
	auto v_resolution = *reinterpret_cast<uint32_t*>(&header[42]);
	auto num_colors = *reinterpret_cast<uint32_t*>(&header[46]);

	std::cout << "fileSize: " << fileSize << std::endl;
	std::cout << "dataOffset: " << dataOffset << std::endl;
	std::cout << "width: " << width << std::endl;
	std::cout << "height: " << height << std::endl;
	std::cout << "depth: " << depth << "-bit" << std::endl;
	std::cout << "Compresion: " << compression << std::endl;
	std::cout << "NO of planes: " << planes << std::endl;
	std::cout << "Size: " << size << std::endl;
	std::cout << "Num of colors: " << num_colors << std::endl;
	std::cout << "Horizontal resolution: " << h_resolution << std::endl;
	std::cout << "Vertical resolution: " << v_resolution << std::endl;

	// Get the current file pointer location
	std::cout << "File pointer = " << bmp.tellg() << endl;
	// Seek to data offset position
	bmp.seekg(static_cast<std::basic_istream<char, std::char_traits<char>>::off_type>(int(dataOffset)) + 20, bmp.beg);

	std::cout << "File pointer = " << bmp.tellg() << endl;


	std::vector<char> img(size);
	bmp.read(img.data(), img.size());

	char temp = 0;
	const int w = width;
	const int h = height;
	//int mat[w][h]

	for (int i = 0; i <= 10; i++)
	{
		std::cout << int(img[i] & 0xff) << endl;
	}
	//img = 

	/*
	std::vector<char> img(dataOffset - HEADER_SIZE);
	bmp.read(img.data(), img.size());

	auto dataSize = ((width * 3 + 3) & (~3)) * height;
	cout << "DataSize= " << dataSize;
	img.resize(dataSize);
	bmp.read(img.data(), img.size());

	
	char temp = 0;

	for (auto i = dataSize - 4; i >= 0; i -= 3)
	{
		temp = img[i];
		img[i] = img[i + 2];
		img[i + 2] = temp;

		std::cout << "R: " << int(img[i] & 0xff) << " G: " << int(img[i + 1] & 0xff) << " B: " << int(img[i + 2] & 0xff) << std::endl;
	}*/
	bmp.close();
	return img;
}




int main(void)
{
	int* w;
	int size = 4000;
	cudaMallocManaged(&w, size);
	cudaMallocManaged(&w, size);
	cudaMallocManaged(&w, size);

	// call cuda kernel
	// ImageFilter <<< 1, 1>>> (w,h, out, n)
	
	// Sync
	//cudaDeviceSynchronize();

	//Free memory
	//cudaFree(w);
	ReadImages();
	//cout<< "Cplusplus: " << __cplusplus;
}

void ReadImages()
{
	string default_path = __FILE__;
	string img;
	img = "C:\\Users\\Sanjib\\Documents\\CudaProgramming\\cuda-programming\\cuda-image\\images\\image2.bmp";
	readBMP(img);
	

	struct BMap
	{
		int width;
		int height;
		int bitDepth;
	}bmp1;

}




