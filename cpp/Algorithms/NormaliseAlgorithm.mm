///
/// Normalise: Stretch the image brightness so that it takes the range 0-255
/// http://en.wikipedia.org/wiki/Normalization_(image_processing)
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
#import "NormaliseAlgorithm.h"

/**
 * Normalise algorithm.
 */
NormaliseAlgorithm::NormaliseAlgorithm(Area& area) : Algorithm(area)
{
	_min = 255;
	_max = 0;
}


/**
 * Normalise: Stretch the image brightness so that it takes the range 0-255
 */
void NormaliseAlgorithm::apply(Photo& photo) {
	for (int y = begin().y(); y < end().y(); y++) {
		for (int x = begin().x(); x < end().x(); x++) {
			static Pixel pixel;
			transform(photo, x, y, pixel);
			photo.pixel(x, y, pixel);
		}
	}
}

BOOL NormaliseAlgorithm::run(const Photo& photo) {
	for (int y = begin().y(); y < end().y(); y++) {
		for (int x = begin().x(); x < end().x(); x++) {
			uint32_t bwPixel = photo.pixel(x,y)->bw();
			if(bwPixel>_max) _max=bwPixel;
			if(bwPixel<_min) _min=bwPixel;
		}
	}
	return YES;
}

	
BOOL NormaliseAlgorithm::transform(Photo& photo, int x, int y, Pixel& pixel) {
	uint32_t bwPixel = photo.pixel(x,y)->bw();
	pixel = Pixel(255*(bwPixel-_min)/(_max-_min));
	return YES;
}
