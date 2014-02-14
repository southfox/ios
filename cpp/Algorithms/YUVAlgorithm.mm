///
/// RGB to YUV conversion (http://en.wikipedia.org/wiki/YUV)
/// YUV is a color space typically used as part of a color image pipeline. 
/// It encodes a color image or video taking human perception into account, allowing reduced bandwidth for chrominance components, 
/// thereby typically enabling transmission errors or compression artifacts to be more efficiently masked by the human perception 
/// than using a "direct" RGB-representation.
/// Y: represents the overall brightness, or luminance (also called yuma).
/// U (blue luma) and V (red luma) are the chrominance (color) components
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
#import "YUVAlgorithm.h"

/**
 * RGB to YUV conversion.
 */
YUVAlgorithm::YUVAlgorithm(Area& area) : Algorithm(area)
{
}


/**
 * RGB to YUV conversion.
 * http://en.wikipedia.org/wiki/YUV
 */
void YUVAlgorithm::apply(Photo& photo) {
	for (int x = begin().x(); x < end().x(); x++) {
		for (int y = begin().y(); y < end().y(); y++) {
			static Pixel pixel;
			transform(photo, x, y, pixel);
			photo.pixel(x, y, pixel);
		}
	}
}


BOOL YUVAlgorithm::transform(Photo& photo, int x, int y, Pixel& pixel) {
	Pixel * rgbPixel = photo.pixel(x, y);
	pixel = Pixel(255, rgbPixel->yuma(), rgbPixel->uluma(), rgbPixel->vluma());
	return YES;
}

BOOL YUVAlgorithm::run(const Photo&) { return NO; }
