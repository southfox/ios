///
/// Detect RGB Differences.
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
#import "DetectRGBDifferences.h"

/**
 * DetectRGBDifferences nonmutating algorithm.
 */
DetectRGBDifferences::DetectRGBDifferences(Area& area): Algorithm(area)  {
	_threshold = MY_FAVORITE_THRESHOLD;
	memset(&limit, 0, sizeof(FacePoint));
	memset(&tmp, 0, sizeof(FacePoint));
}

DetectRGBDifferences::DetectRGBDifferences(Area& area, int threshold): Algorithm(area)  {
	_threshold = threshold;
	memset(&limit, 0, sizeof(FacePoint));
	memset(&tmp, 0, sizeof(FacePoint));
}


/**
 * Detect RGB Differences.
 * DetectRGBDifferences: Stretch the image brightness so that it takes the range 0-255
 */
void DetectRGBDifferences::apply(Photo& photo) {
	 
	for (int x = begin().x(); x < end().x(); x++) {
		memset(&limit, 0, sizeof(FacePoint));
		memset(&tmp, 0, sizeof(FacePoint));
		for (int y = begin().y(); y < end().y(); y++) {
			static Pixel pixel;
			if (transform(photo, x, y, pixel) == YES) {
				photo.pixel(x, y, pixel);
			}
		}
	}
}


BOOL DetectRGBDifferences::transform(Photo& photo, int x, int y, Pixel& pixel) {
	Pixel* pix = photo.pixel(x,y);
	int a = pix->alpha();
	int r = pix->red();
	int g = pix->green();
	int b = pix->blue();

	tmp.x = x; tmp.y = y; tmp.r = r/_threshold; tmp.g = g/_threshold; tmp.b = b/_threshold; tmp.a = a/_threshold;
	if (tmp.r != limit.r || tmp.g != limit.g || tmp.b != limit.b || tmp.a != limit.a) {
		limit.x = tmp.x; limit.y = tmp.y; limit.r = tmp.r; limit.g = tmp.g; limit.b = tmp.b; limit.a = tmp.a;
		pixel = Pixel(RGB_EDGE);
		return YES;
	}
	return NO;
}

BOOL DetectRGBDifferences::run(const Photo&) { return NO; }
