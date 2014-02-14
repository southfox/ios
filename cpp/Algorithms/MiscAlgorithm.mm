///
/// Misc: Stretch the image brightness so that it takes the range 0-255
/// http://en.wikipedia.org/wiki/Normalization_(image_processing)
///
/// Created by Javier Fuchs on 1/1/11.
/// Copyright(C) 2014 Javier Fuchs. All rights reserved.
///

#include <vector>
#import "Dot.h"
#import "Defines.h"
#import "Pixel.h"
#import "Area.h"
#import "Eye.h"
#import "Nose.h"
#import "Mouth.h"
#import "Chin.h"
#import "Eyebrow.h"
#import "Photo.h"
#import "Algorithm.h"
#import "Face.h"
#import "MiscAlgorithm.h"

/**
 * Misc algorithm.
 */
MiscAlgorithm::MiscAlgorithm(const Area& area) : Algorithm(area)
{
	_pixel = new Pixel();
	_l = 0;
	_k = 0;
}
/**
 * Misc algorithm destructor
 */
MiscAlgorithm::~MiscAlgorithm()
{
	if (_pixel != NULL) delete _pixel;
}



/**
 * Misc: Stretch the image brightness so that it takes the range 0-255
 */
void MiscAlgorithm::apply(Photo& photo) {
	static Pixel pixel;
	transform(photo, 0, 0, pixel);

	int y2 = MIN(begin().y() - _l, photo.height());
	int y3 = MIN(end().y() - _k, photo.height());
	for (int x = begin().x(); x < MIN(end().x(), photo.width()); x++) {
		photo.pixel(x, y2, pixel);
		photo.pixel(x, y3, pixel);
	}
	int x2 = MIN(begin().x() - _l, photo.width()); 
	int x3 = MIN(end().x() - _k, photo.width());
	for (int y = begin().y(); y < MIN(end().y(), photo.height()); y++) {
		photo.pixel(x2, y, pixel);
		photo.pixel(x3, y, pixel);
	}
}

BOOL MiscAlgorithm::transform(Photo& photo, int x, int y, Pixel& pixel) {
	pixel = (*_pixel);
	return TRUE;
}

void MiscAlgorithm::draw(Photo& photo, int r, int g, int b, int l, int k) {
	(*_pixel) = Pixel(255, r, g, b);
	_l = l;
	_k = k;
	apply(photo);
}


void MiscAlgorithm::draw(Photo& photo, Face& face) {
	area(face._nose.area());
	draw(photo, 0, 0, 0); // black

	area(face._leftEyebrow.area());
	draw(photo, 128, 128, 128); // Nickel

	area(face._rightEyebrow.area());
	draw(photo, 128, 0, 64); // Maroon

	area(face._leftEye.area());
	draw(photo, 255, 128, 0); // Tangerine

	area(face._rightEye.area());
	draw(photo, 255, 128, 0); // Tangerine

	area(face._chin.area());
	draw(photo, 255, 0, 255); // Magenta

	area(face._mouth.area());
	draw(photo, 0, 46, 184); // blue

	area(face.area());
	draw(photo, 0, 0, 0); // blue
}
	

/**
 * Draw a crux center in a point.
 * @param p it is the point.
 * @param r it is Red.
 * @param g it is Green.
 * @param b it is Blue.
 * @param l it is a shift in y axis.
 * @param k it is a shift in x axis.
 */
void MiscAlgorithm::crux(Photo& photo, const Dot& p, int r, int g, int b, int l, int k) {

	int x = p.x()+5;
	int y = p.y()+5;
	//int x = p.x();
	//int y = p.y();

	int x0 = MAX(0.0,x-10.0); 
	int y0 = MAX(0.0,y-10.0); 
	int w = 10.0;
	int h = 10.0;
	int x1 = MIN(x0 + w, photo.width());
	int y1 = MIN(y0 + h, photo.height());

	(*_pixel) = Pixel(255, r, g, b);

	int j = y - h/2 - l; 
	int i = 0;
	assert(x0 < photo.width());
	assert(y0 < photo.height());
	for (i = x0; i < x1; i++) {
		photo.pixel(i, j, (*_pixel));
	}
	i = x - w/2 - l; 
	for (j = y0; j < y1; j++) {
		photo.pixel(i, j, (*_pixel));
	}
}
void MiscAlgorithm::dot(Photo& photo, const Dot& p, int r, int g, int b) {
	(*_pixel) = Pixel(255, r, g, b);
	photo.pixel(p.x(), p.y(), (*_pixel));
}


/**
 * Draw a crux center in every point of the vector.
 * @param p it is the vector of points.
 * @param r it is Red.
 * @param g it is Green.
 * @param b it is Blue.
 * @param l it is a shift in y axis.
 * @param k it is a shift in x axis.
 */
void MiscAlgorithm::crux(Photo& photo, Dot::Vector& p, int r, int g, int b, int l, int k) {
	// Draw the points
	for (Dot::Vector::iterator it = p.begin();
	     it < p.end();
	     it++) {
		crux(photo, (*it), r, g, b, l, k);
	}
}


BOOL MiscAlgorithm::run(const Photo&) { return NO; }
