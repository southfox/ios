///
/// Dot representation.
///
/// Created by Javier Fuchs on 7/16/09.
/// Copyright(C) 2014 Javier Fuchs. All rights reserved.
///

#include <vector>
#import "Defines.h"
#import "Dot.h"
#import "Area.h"
#include <math.h>
#if defined(_DEBUG)
#undef __DEPRECATED
#include <strstream>
#include <iostream>
#endif

/// Constructor using short.
Dot::Dot(short x, short y) {
	_x = x;
	_y = y;
}

/// Constructor using integer.
Dot::Dot(int x, int y) {
	_x = x;
	_y = y;
}

/// Constructor using float.
Dot::Dot(float x, float y) {
	_x = x;
	_y = y;
}

/// Copy constructor
Dot::Dot(const Dot &other) {
	_x = other._x;
	_y = other._y;
}

/// Default constructor
Dot::Dot() {
	_x = 0;
	_y = 0;
}

/// Get x
/// @return x
int Dot::x() const { return _x; }
void Dot::x(int v) { _x = v; }

/// Get y
/// @return y
int Dot::y() const { return _y; }
void Dot::y(int v) { _y = v; }

#if defined(_DEBUG)
/// out operators
std::ostream& operator<<(std::ostream& out, const Dot& d) {
	out << "(" << d.x() << "," << d.y() << ")";
	return out;
}

/**
 * Log class properties.
 * @param msg is a customized message to print with the properties.
 */
void Dot::log(NSString * msg) const {
	std::strstream s;
	s << [msg cStringUsingEncoding:NSASCIIStringEncoding] << " " << (*this) << '\0';
	NSLog(@"%s", s.str());
}
#endif


/**
 * Distance in Cartesian coordinates.
 * http://en.wikipedia.org/wiki/Pythagorean_theorem#Distance_in_Cartesian_coordinates
 * @return a long value with the distance
 */
float Dot::distance(const Dot& p) const {
	signed int a = p.y() - y();
	signed int b = p.x() - x();
	return (sqrt((float)(a*a + b*b)));
}


/**
 * Operator: =, assignment.
 * @param d is a dot
 */
Dot& Dot::operator = (const Dot& d) {
	_x = d.x();
	_y = d.y();
	return (*this);
}


/**
 * Operator: ==, comparisson.
 * @param d is a dot
 */
bool Dot::operator == (const Dot& d) const {
	return (x() == d.x() && y() == d.y());
}

/**
 * Conversion from OpenCVDot to FaceItDot
 * y			d in areaOCV ----> d" in areaFaceIt
 * |			(x,y)			(x",y")
 * |  d.                 w,h                     w",h"
 * +------> x
 */
void Dot::toOpenCV(int width, int height, const Area& area) {
	//log(@" [-] ");

	// Traslation 
	// w"
	float w = (float)area.height() / FACTOR1;
	// x"
	float x2 = (height - y() - area.height())/FACTOR1 + w;

	// y"
	float y2 = (width - x() - area.width()*3)/FACTOR2;

	// Simetry using horizontal axis
	float by = (width - area.end().x() - area.width()*2)/FACTOR2;
	float d = fabs(y2 - by);

	_x = x2;
	_y = (y2 + 2*d);

	//log(@" [+] ");
}


/**
 * Convert a the Dot instance to CGPoint iphone SDK point.
 * @return a cgpoint
 */
CGPoint Dot::cgpoint() const {
	CGPoint p = CGPointMake(x(), y());
	return (p);
}
