///
/// Gaussian Smooth Blur.
///
/// Created by Javier Fuchs on 1/1/11.
/// Copyright(C) 2014 Javier Fuchs. All rights reserved.
///

#include <vector>
#import "Dot.h"
#import "Defines.h"
#import "Area.h"
#import "Pixel.h"
#import "Photo.h"
#import "Algorithm.h"
#import "GaussianSmoothBlurAlgorithm.h"

/**
 * Gaussian Smooth Blur algorithm.
 */
GaussianSmoothBlurAlgorithm::GaussianSmoothBlurAlgorithm(Area& area) : Algorithm (area)
{
	int shift = 5;
	width(width() - shift);
	height(height() - shift);
	end(Dot(end().x() - shift, end().y() - shift));
}

const int GaussianSmoothBlurAlgorithm::blur[5][5] = {
	{ 1,  4,  7,  4, 1},
	{ 4, 16, 26, 16, 4},
	{ 7, 26, 41, 26, 7},
	{ 4, 16, 26, 16, 4},
	{ 1,  4,  7,  4, 1}
};

/**
 * Smooth an image using gaussian blur, required before performing canny edge detection.
 */
void GaussianSmoothBlurAlgorithm::apply(Photo& photo) {
	 

	for (int x = begin().x(); x < end().x(); x++) {
		for (int y = begin().y(); y < end().y(); y++) {
			static Pixel pixel;
			transform(photo, x, y, pixel);
			photo.pixel(x, y, pixel);
		}
	}
}


BOOL GaussianSmoothBlurAlgorithm::transform(Photo& photo, int x, int y, Pixel& pixel) {
	int val = 0;
	for (int dy = 0; dy < 5; dy++) {
		for (int dx = 0; dx < 5; dx++) {
			uint32_t bwPixel = photo.pixel(x + dx,y + dy)->bw();
			val += bwPixel * blur[dy][dx];
		}
	}
	pixel = Pixel(val / 273);
	return YES;
}


BOOL GaussianSmoothBlurAlgorithm::run(const Photo&) { return NO; }
