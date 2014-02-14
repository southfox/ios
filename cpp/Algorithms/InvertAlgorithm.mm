///
/// Invert the image polarity.
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
#import "InvertAlgorithm.h"

/**
 * Invert the image polarity; object pixels become background and background, object.
 */
InvertAlgorithm::InvertAlgorithm(Area& area) : Algorithm(area)
{
}


/**
 * Invert the image polarity; object pixels become background and background, object.
 */
void InvertAlgorithm::apply(Photo& photo) {
	for (int y = begin().y(); y < end().y(); y++) {
		for (int x = begin().x(); x < end().x(); x++) {
			static Pixel pixel;
			transform(photo, x, y, pixel);
			photo.pixel(x, y, pixel);
		}
	}
}


BOOL InvertAlgorithm::transform(Photo& photo, int x, int y, Pixel& pixel) {
	uint32_t bwPixel = photo.pixel(x,y)->bw();
	pixel = Pixel(255 - bwPixel);
	return YES;
}

BOOL InvertAlgorithm::run(const Photo&) { return NO; }
