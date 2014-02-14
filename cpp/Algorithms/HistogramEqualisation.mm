///
/// Histogram equalisation.
/// http://en.wikipedia.org/wiki/Histogram_equalisation
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
#import "HistogramEqualisation.h"

/**
 * HistogramEqualisation an image.
 */
HistogramEqualisation::HistogramEqualisation(Area& area) : Algorithm(area)
{
	pdf = std::vector<int>(256);
	cdf = std::vector<int>(256);
}


/**
 * HistogramEqualisation an image.
 */
void HistogramEqualisation::apply(Photo& photo) {
	// map the pixels to the new values
	for (int y = begin().y(); y < end().y(); y++) {
		for (int x = begin().x(); x < end().x(); x++) {
			static Pixel pixel;
			transform(photo, x, y, pixel);
			photo.pixel(x, y, pixel);
		}
	}
}

BOOL HistogramEqualisation::transform(Photo& photo, int x, int y, Pixel& pixel) {
	uint32_t bwPixel = photo.pixel(x,y)->bw();
	pixel = Pixel(255 * cdf[bwPixel] / cdf[255]);
	return YES;
}

BOOL HistogramEqualisation::run(const Photo& photo) {
	// compute the pdf
	for (int y = begin().y(); y < end().y(); y++) {
		for (int x = begin().x(); x < end().x(); x++) {
			uint32_t bwPixel = photo.pixel(x,y)->bw();
			pdf[bwPixel]++;
		}
	}
	// compute the cdf
	cdf[0]=pdf[0];
	for (int i = 1; i < 256; i++) {
		cdf[i] = cdf[i-1] + pdf[i];
	}
	return TRUE;
}
