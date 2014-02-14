///
/// AutoThreshold an image.
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
#import "AutoThresholdAlgorithm.h"


/**
 * AutoThreshold an image.
 */

AutoThresholdAlgorithm::AutoThresholdAlgorithm(Area& area) : Algorithm(area)
{
	_total = 0;
	_count = 0;
	_white = 0;
	_black = 0;
}


/**
 * AutoThreshold an image.
 */
void AutoThresholdAlgorithm::apply(Photo& photo) {

	for (int y = begin().y(); y < end().y(); y++) {
		for (int x = begin().x(); x < end().x(); x++) {
			static Pixel pixel;
			if (transform(photo, x, y, pixel)) {
				photo.pixel(x, y, pixel);
			}
		}
	}
}

BOOL AutoThresholdAlgorithm::transform(Photo& photo, int x, int y, Pixel& pixel) {
	if (isWhite(photo, x, y) == YES) {
		pixel = Pixel(255);
		return YES;
	} else {
		pixel = Pixel(0);
		return NO;
	}
}



/**
 * Calculate the threshold using the average value of the entire image intensity.
 */

BOOL AutoThresholdAlgorithm::run(const Photo& photo) {
	for (int y = begin().y(); y < end().y(); y++) {
		for (int x = begin().x();  x < end().x(); x++) {
			stat(photo, x, y);
		}
	}
	threshold(_total/_count * 0.9);
#if defined(_DEBUG)
	NSLog(@"Threshold Detected: %f", threshold());
#endif
	return YES;
}

BOOL AutoThresholdAlgorithm::stat(const Photo& photo, int x, int y) {
	return stat0(photo, x, y);
}

BOOL AutoThresholdAlgorithm::stat0(const Photo& photo, int x, int y) {
	_total += photo.pixel(x,y)->bw();
	_count++;
	return YES;
}

BOOL AutoThresholdAlgorithm::isWhite(const Photo& photo, int x, int y) {
	if (photo.pixel(x,y)->bw() > _threshold) {
		_black++;
		return YES;
	} else {
		_white++;
		return NO;
	}
}

void AutoThresholdAlgorithm::threshold(float threshold) {
	_threshold = threshold;
}

float AutoThresholdAlgorithm::threshold() {
	return _threshold;
}
	
void AutoThresholdAlgorithm::white(int white) {
	_white = white;
}

int AutoThresholdAlgorithm::white() {
	return _white;
}

void AutoThresholdAlgorithm::black(int black) {
	_black = black;
}

int AutoThresholdAlgorithm::black() {
	return _black;
}
