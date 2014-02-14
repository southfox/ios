///
/// Binary erosion using a 3x3 square kernal.
/// http://en.wikipedia.org/wiki/Erosion_(morphology)
/// Erosion is one of two fundamental operations (the other being dilation) in Morphological image processing 
/// from which all other morphological operations are based. It was originally defined for binary images, 
/// later being extended to grayscale images, and subsequently to complete lattices.
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
#import "ErosionAlgorithm.h"

/**
 * Erosion algorithm.
 */
ErosionAlgorithm::ErosionAlgorithm(Area& area) : Algorithm(area)
{
}


/**
 * binary erosion using a 3x3 square kernal.
 * http://en.wikipedia.org/wiki/Erosion_(morphology)
 */
void ErosionAlgorithm::apply(Photo& photo) {
	// run erosion kernal over interior pixels using the square dots 
	for (int y = begin().y(); y < end().y(); y++) {
		for (int x = begin().x(); x < end().x(); x++) {
			static Pixel pixel;
			if (transform(photo, x, y, pixel) == YES) {
				photo.pixel(x, y, pixel);
			}
		}
	}
	
}

const Dot ErosionAlgorithm::dots[8] = {
	Dot(-1,-1), Dot(0,-1), Dot(1,-1),
	Dot(-1, 0),            Dot(1, 0),
	Dot(-1, 1), Dot(0, 1), Dot(1, 1)
};

BOOL ErosionAlgorithm::transform(Photo& photo, int x, int y, Pixel& pixel) {
	BOOL ret = NO;
	for (int i=0; i < 8; i++) {
		int dx = ErosionAlgorithm::dots[i].x();
		int dy = ErosionAlgorithm::dots[i].y();
		// Check the B/W neighboring pixel
		if (photo.pixel(x + dx, y + dy)->bw() < 64) 
		{
			pixel = Pixel(255);
			ret = YES;
			break;
		}
	}
	return ret;
}
BOOL ErosionAlgorithm::run(const Photo&) { return NO; }
