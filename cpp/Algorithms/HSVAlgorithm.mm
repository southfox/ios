///
/// RGB to HSV conversion (http://en.wikipedia.org/wiki/HSL_and_HSV).
/// HSL and HSV are two related representations of points in an RGB color model that 
/// attempt to describe perceptual color relationships more accurately than RGB, 
/// while remaining computationally simple. 
/// HSL stands for hue, saturation and lightness, while HSV stands for hue, saturation and value.
/// Both HSL and HSV can be thought of as describing colors as points in a cylinder (called a color solid) 
/// whose central axis ranges from black at the bottom to white at the top, with neutral colors between them.
/// The angle around the axis corresponds to "hue".
/// The distance from the axis corresponds to "saturation".
/// The distance along the axis corresponds to "lightness", "value" or "brightness".
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
#import "HSVAlgorithm.h"

/**
 * RGB to HSV conversion.
 */
HSVAlgorithm::HSVAlgorithm(Area& area) : Algorithm(area)
{
}


/**
 * RGB to HSV or HSL conversion.
 * http://en.wikipedia.org/wiki/HSL_and_HSV
 */
void HSVAlgorithm::apply(Photo& photo) {
	for (int x = begin().x(); x < end().x(); x++) {
		for (int y = begin().y(); y < end().y(); y++) {
			static Pixel pixel;
			if (transform(photo, x, y, pixel) == YES) {
				photo.pixel(x, y, pixel);
			}
		}
	}
}

BOOL HSVAlgorithm::transform(Photo& photo, int x, int y, Pixel& pixel) {
	Pixel * rgbPixel = photo.pixel(x, y);
	//NSLog(@"%.1f, %.1f, %.1f", rgbPixel->hue(), rgbPixel->saturation(), rgbPixel->lightness());
	//if (rgbPixel->lightness() > 100.0)  // SCLERA!!!
	//if (rgbPixel->lightness() > 100.0f && rgbPixel->saturation() < 0.3f)// && rgbPixel->hue() > 60.0f)
	//{
		pixel = Pixel(255, (int)rgbPixel->hue(), (int)rgbPixel->saturation(), (int)rgbPixel->lightness());
		return YES;
	//}
	/*
	if (rgbPixel->lightness() < 60.0)  // PUPIL and part of the IRIS
	{
		pixel = Pixel(255, (int)rgbPixel->hue(), (int)rgbPixel->saturation(), (int)rgbPixel->lightness());
		return YES;
	}
	*/
	return NO;
}

BOOL HSVAlgorithm::run(const Photo&) { return NO; }
