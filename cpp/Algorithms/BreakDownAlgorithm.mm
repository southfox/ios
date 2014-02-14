///
/// Break down face algorithm.
///
/// Created by Javier Fuchs on 1/1/11.
/// Copyright(C) 2014 Javier Fuchs. All rights reserved.
///

#include <vector>
#import "Dot.h"
#import "Defines.h"
#import "Area.h"
#import "Eye.h"
#import "Nose.h"
#import "Mouth.h"
#import "Chin.h"
#import "Eyebrow.h"
#import "Photo.h"
#import "Algorithm.h"
#import "Face.h"
#import "BreakDownAlgorithm.h"

/**
 * BreakDown an image.
 */
BreakDownAlgorithm::BreakDownAlgorithm(Area& area) : Algorithm(area)
{
	_minWidth =  ROI_MIN_WIDTH_DEFAULT;
	_minHeight = ROI_MIN_HEIGHT_DEFAULT;
	_face = nil;
}

BreakDownAlgorithm::BreakDownAlgorithm(Area& area, float minWidth, float minHeight) : Algorithm(area)
{
	_minWidth =  minWidth;
	_minHeight = minHeight;
	_face = nil;
}



/// See: http://en.wikipedia.org/wiki/Interval_(mathematics)
#define BOUNDED_INTERVAL(a,n1,n2)	(a >= n1/photo.scale() && a < n2/photo.scale())

/**
 * Break down face algorithm.
 * @param area
 * @param scale
 */
BOOL BreakDownAlgorithm::run(const Photo& photo) {
	Area area(begin().x(), begin().y(), width(), height());
	return run(photo, area);
}
BOOL BreakDownAlgorithm::run(const Photo& photo, Area& area) {
	int x = area.begin().x();
	int y = area.begin().y();
	int w = area.width();
	int h = area.height();
	if ((w*photo.scale() > _minWidth) && (h*photo.scale() > _minHeight)) {
		Area one(x, y, w/2, h/2);
		Area two(x + w/2, y, w/2, h/2);
		Area three(x, y + h/2, w/2, h/2);
		Area four(x + w/2, y + h/2, w/2, h/2);
		run(photo, one);
		run(photo, two);
		run(photo, three);
		run(photo, four);

	} else {

		// NOSE
		if (BOUNDED_INTERVAL(x, 450, 750) && BOUNDED_INTERVAL(y, 600, 1000)) {
			_face->_nose.area(area + _face->_nose.area());
		}
#if 0
		// EYEBROW: LEFT
		if (BOUNDED_INTERVAL(x, 300, 600) && BOUNDED_INTERVAL(y, 200, 800)) {
			Eyebrow* eyebrow = new Eyebrow(area);
			_face->_leftEyebrow.push_back(eyebrow);
		}
		// EYEBROW: RIGHT
		if (BOUNDED_INTERVAL(x, 300, 600) && BOUNDED_INTERVAL(y, 800, 1400)) {
			Eyebrow* eyebrow = new Eyebrow(area);
			_face->_rightEyebrow.push_back(eyebrow);
		}
#endif
		// EYE: LEFT
		if (BOUNDED_INTERVAL(x, 450, 750) && BOUNDED_INTERVAL(y, 400, 800)) {
			_face->_leftEye.area(area + _face->_leftEye.area());
		}
		// EYE: RIGHT
		if (BOUNDED_INTERVAL(x, 450, 750) && BOUNDED_INTERVAL(y, 800, 1200)) {
			_face->_rightEye.area(area + _face->_rightEye.area());
		}
#if 0
		// CHIN
		if (BOUNDED_INTERVAL(x, 900, 1050) && BOUNDED_INTERVAL(y, 600, 1000)) {
			Chin* chin = new Chin(area);
			_face->_chin.push_back(chin);
		}
#endif
		// MOUTH
		if (BOUNDED_INTERVAL(x, 650, 900) && BOUNDED_INTERVAL(y, 550, 1100)) {
			_face->_mouth.area(area + _face->_mouth.area());
		}
	}
	return YES;
}

BOOL BreakDownAlgorithm::run(const Photo& photo, Face& face) {
	_face = &face;
	return run(photo);
}


void BreakDownAlgorithm::apply(Photo& photo) { return; }

BOOL BreakDownAlgorithm::transform(Photo& photo, int x, int y, Pixel& pixel) { return NO; }
