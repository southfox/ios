///
/// Black and White conversion.
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
#import "BWAlgorithm.h"

/**
 * Black and White conversion.
 */
BWAlgorithm::BWAlgorithm(Area& area) : Algorithm(area)
{
}


/**
 * Convert to Black and White.
 */
void BWAlgorithm::apply(Photo& photo) {

	for (int y = begin().y(); y < end().y(); y++) {
		for (int x = begin().x(); x < end().x(); x++) {
			static Pixel pixel;
			transform(photo, x, y, pixel);
			photo.pixel(x, y, pixel);
		}
	}
}

BOOL BWAlgorithm::transform(Photo& photo, int x, int y, Pixel& pixel) {
	pixel = photo.pixel(x,y)->bw();
	return YES;
}

BOOL BWAlgorithm::run(const Photo&) { return NO; }
