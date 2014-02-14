///
/// Area
///
/// Created by Javier Fuchs on 1/1/11.
/// Copyright 2014 Javier Fuchs. All rights reserved.
///

#include <vector>
#import "Dot.h"
#import "Defines.h"
#import "Area.h"
#if defined(_DEBUG)
#undef __DEPRECATED
#include <strstream>
#include <iostream>
#include <iomanip.h>
#endif

static inline double radians (double degrees) {return degrees * M_PI/180;}

/// AREA
/// ----
/// Every area is defined as a CGRect with the following members:
/// 	CGPoing origin { float x, float y }
/// 	CGPoing size   { float width, float height }
///                  (x2,y2)
///                     |
///         ............+
///         .           .
///         .           .
///         .   Area    .
///         .           .
///         +............
///         |
///      (x1,y1) 
///     

Area::Area() {
	_k = 0;
	_type = ROI_UNDEF;
	_begin = Dot(0,0);
	_end = Dot(0,0);
	_width = 1;
	_height = 1;

}
Area::Area(const Area& area) {
	(*this) = area;
}

Area::Area(int x, int y, int w, int h) {
	_k = 0;
	_type = ROI_UNDEF;
	_begin = Dot(x,y);
	_end = Dot(x+w,y+h);
	_width = w;
	_height = h;
}

Area::Area(const Dot& begin, const Dot& end) {
	_k = 0;
	_type = ROI_UNDEF;
	_begin = begin;
	_end = end;
	_width = abs(end.x() - begin.x());
	_height = abs(end.y() - begin.y());
}

const Dot& Area::begin() const { return _begin; }
const Dot& Area::end() const { return _end; }
int Area::width() const { return _width; }
int Area::height() const { return _height; }

void Area::begin(const Dot& dot) { _begin = dot; }
void Area::end(const Dot& dot) { _end = dot; }
void Area::width(int v)  { _width = v; }
void Area::height(int v)  { _height = v; }

CGRect Area::cgrect() const {
	return CGRectMake((*this).begin().x(), (*this).begin().y(), (*this).width(), (*this).height());
}



//
//                  (end)              (begin.x(), end.y())=pC         pD=(end.x(), end.y())
//         --------+                                          +-------+
//         |       |                                          |       | 
// y       |       |                                          |       | 
// +       |       |                                          |       | 
// |       +--------                                          +-------+
// |    (begin)                      (begin.x(), begin.y())=pA         pB=(end.x(), begin.y())
// |    
// .------+ x
//
float Area::distance(const Dot& d) const {
	float delta = 0.0f;
	do {
		Dot pA(begin());
		Dot pB(end().x(), begin().y());
		Dot pC(begin().x(), end().y());
		Dot pD(end());

		if (d == pA || d == pB || d == pC || d == pD) {
			delta = 0.0f;
			break;
		}

		//  C        D
		//   +--.d--+
		//   |      | 
		//  .d      .d
		//   |      | 
		//   +--.d--+
		//  A        B
		if ((d.x() == pA.x() && d.y() >= pA.y() && d.y() <= pC.y()) ||
		    (d.x() == pB.x() && d.y() >= pB.y() && d.y() <= pD.y()) ||
		    (d.y() == pA.y() && d.x() >= pA.x() && d.x() <= pB.x()) ||
		    (d.y() == pC.y() && d.x() >= pC.x() && d.x() <= pD.x())) {
			delta = 0.0f;
			break;
		}



		// the point is outside

		// 
		// case 1:      +--+
		//              |  | 
		//              +--+
		//           .d 
		if (d.x() <= pA.x() && d.y() <= pA.y()) {
			delta = d.distance(pA);
			break;
		}

		// 
		// case 2:   +--+
		//           |  | 
		//           +--+
		//            .d 
		if (d.x() >= pA.x() && d.x() <= pB.x() && d.y() <= pA.y()) {
			delta = d.distance(Dot(d.x(), pA.y()));
			break;
		}

		// 
		// case 3:   +--+
		//           |  | 
		//           +--+
		//                .d 
		if (d.x() >= pB.x() && d.y() <= pB.y()) {
			delta = d.distance(pB);
			break;
		}

		// 
		// case 4:      +--+
		//          .d  |  | 
		//              +--+
		//
		if (d.x() <= pA.x() && d.y() <= pC.y() && d.y() >= pA.y()) {
			delta = d.distance(Dot(pA.x(), d.y()));
			break;
		}


		// 
		// case 5:  .d  
		//              +--+ 
		//              |  |
		//              +--+
		if (d.x() <= pC.x() && d.y() >= pC.y()) {
			delta = d.distance(pC);
			break;
		}

		// 
		// case 6:   .d
		//          +--+      
		//          |  |
		//          +--+      
		//
		if (d.x() >= pC.x() && d.x() <= pD.x() && d.y() >= pC.y()) {
			delta = d.distance(Dot(d.x(), pD.y()));
			break;
		}

		// 
		// case 7:  +--+      
		//          |  |  .d  
		//          +--+      
		//
		if (d.x() >= pB.x() && d.y() <= pD.y() && d.y() >= pB.y()) {
			delta = d.distance(Dot(pB.x(), d.y()));
			break;
		}

		// 
		// case 8:        .d
		//          +--+      
		//          |  |
		//          +--+      
		//
		if (d.x() >= pD.x() && d.y() >= pD.y()) {
			delta = d.distance(pD);
			break;
		}

	} while(0);
	return delta;
}

//  C        D
//   +--.d--+
//   |      | 
//  .d      .d
//   |      | 
//   +--.d--+
//  A        B
BOOL Area::isAlignedH(const Area& a) const {
	// (*this).log(@"this");
	// a.log(@"a");
	BOOL ret = NO;

	Dot tA(begin());
	Dot tB(end().x(), begin().y());
	Dot tC(begin().x(), end().y());
	Dot tD(end());

	Dot qA(a.begin());
	Dot qB(a.end().x(), a.begin().y());
	Dot qC(a.begin().x(), a.end().y());
	Dot qD(a.end());

	do {
		// 
		// case 0:
		//          .--.      +--+
		//          |  |      | a|
		//          .--.      +--+
		//
		if (qA.x() == tA.x() || qC.x() == tC.x()) {
			ret = YES;
			break;
		}

		// 
		// case 1:
		//          .--.      
		//          |  |      
		//          .--.      +--+
		//                    | a|
		//                    +--+
		if (qC.x() == tA.x()) {
			ret = YES;
			break;
		}

		// 
		// case 2:             +--+
		//                     | a|     
		//          .--.       +--+     
		//          |  | 
		//          .--.     
		//              
		if (qA.x() == tC.x()) {
			ret = YES;
			break;
		}

		// 
		// case 3:             +--+
		//          .--.       | a|     
		//          |  |       +--+     
		//          .--.
		//              
		//              
		if (qA.x() >= tA.x() && qA.x() <= tB.x()) {
			ret = YES;
			break;
		}

		// 
		// case 4:             .--.
		//          +--+       |  |     
		//          | a|       .--.     
		//          +--+
		//              
		//              
		if (tB.x() >= qA.x() && tB.x() <= qB.x()) {
			ret = YES;
			break;
		}


	} while(0);
	return ret;
}

float Area::distance(const Area& a) const {
	Dot qA(a.begin());
	Dot qB(a.end().x(), a.begin().y());
	Dot qC(a.begin().x(), a.end().y());
	Dot qD(a.end());

	float deltaA = distance(qA);
	float deltaB = distance(qB);
	float deltaC = distance(qC);
	float deltaD = distance(qD);

	return (MIN(MIN(deltaA, deltaB), MIN(deltaC, deltaD)));
}


float Area::ratio() const {
	return ((float)width()/(float)height());
}

float Area::absoluteRatio() const {
	float min = MIN(width(), height());
	float max = MAX(width(), height());
	return (max/min);
}

BOOL Area::isRounded() const {
	// (*this).log(@"Round:");
	BOOL ret = NO;

	do {
		if (width() == 0.0f || height() == 0.0f) {
			ret = NO;
			break;
		}

		if (width() == height()) { 
			// almost impossible
			ret = YES; 
			break; 
		}

		float simpleRatio = ratio();

		if (simpleRatio >= 0.5f && simpleRatio <= 1.5f) {
			ret = YES;
			break;
		}

		ret = NO;
	} while(0);
	return ret;
}

BOOL Area::isOval() const {
	BOOL ret = NO;

	do {
		if (width() == 0.0f || height() == 0.0f) {
			ret = NO;
			break;
		}

		float simpleRatio = ratio();

		if (simpleRatio >= 0.2f && simpleRatio <= 4.0f) {
			ret = YES;
			break;
		}

		ret = NO;
	} while(0);
	return ret;
}




/**
 * operator +, union (R + S).
 * R + S returns the union of areas R and S which is the set of points that appear in R or S.
 * (R Union S) R + S returns the union of area R and S, which are the regions 
 * of the photograph that appear in R or S. 
 * E.g. if R = { (150,200) (150,200) } and S = { (150,400) (150,200) }, then R + S = { (150,200) (150,600) }.
 *
 *       + (y)                                    + (y)
 *       |(0,1600)                                |(0,1600)
 *       |                                        |
 *       |                                        |
 *   600 -    ........                        600 -    
 *       |    .      .                            |    
 *       |    .  S   .                            |    
 *   400 -    ........                        400 -    ...............
 *       |    .      .                            |    .      .      .
 *       |    .  R   .                            |    .  R   .  S   .
 *   200 -    ........                        200 -    ...............
 *       |                                        |
 *       |                                        |
 *       -----|------|-----------+ x              -----|------|------|-----------+ x
 *  (0,0)    150    300       (1200,0)       (0,0)    150    300    450       (1200,0)
 *
 * @param S a read only reference to other ROI
 * @return a new instance of Area with the union of ROIs R and S
 * @see: http://en.wikipedia.org/wiki/Union_(set_theory)
 */
Area Area::operator + (const Area& S) const {
	Area R(*this);
	if (R.begin().x() == 0) {
		R = S;
	} else if (S.begin().x() != 0) {
		R = CGRectUnion(cgrect(), S.cgrect());
	}
	return (R);
}
Area Area::operator + (const Dot& d) const {
	Area R(*this);
	R = CGRectUnion(cgrect(), CGRectMake(d.x(), d.y(), 1.0, 1.0));
	return (R);
}


/**
 * Operator *, intersection (R * S).
 * R * S returns the intersection of areas R and S,   
 *        which is the set of points that appear in R and S  
 *        E.g. if R = { (300,200) (300,1200) }               
 *                S = { (300,600) (600,400) }                
 *             then R * S = { (300,600) (300,400) }
 *                .....+-----+.....
 *                .    | R*S |    .
 *                .  R |     |S   .
 *                .....+-----+.....
 *
 * @see: http://en.wikipedia.org/wiki/Intersection_(set_theory)
 * @param S a read only reference to other ROI
 * @return a new instance of Area with the intersection of ROIs R and S
 */
Area Area::operator * (const Area& S) const {
	Area T; // T = R * S
	T = CGRectIntersection(cgrect(), S.cgrect());
	return (T);
}



/**
 * Operator -, difference (R - S)
 * R - S returns the area of difference between areas R and S, which is the 
 *           set of points that appear in R but not in S. 
 *           E.g. 
 * @param S a read only reference to other ROI
 * @return a new instance of Area with the difference of areas R and S
 */
Area  Area::operator - (const Area& S) const {
	Area R(*this);
	Area T = (R + (R * S));
	return T;
}



/**
 * Operator: ^, symetric difference (R ^ S).
 * R^S returns the symmetric difference of area R and S, which is 
 *           the set of points that appear in R or S, but not both. 
 *           I.e. it's the same as (R - S) + (S - R). 
 *           It's also the same as (R + S) - (R * S). 
 *           E.g. 
 * @param S a read only reference to other ROI
 * @return a new instance of Area with the symetric difference of areas R and S
 */
Area Area::operator ^ (const Area& S) const {
	return (((*this) - S) + (S - (*this)));
}


/**
 * Operator: =, assignment.
 * @param area
 */
Area& Area::operator = (const Area& S) {
	_begin = S.begin();
	_end = S.end();
	_height = S.height();
	_width = S.width();
	_threshold = S._threshold;
	_autoThresholdWhite = S._autoThresholdWhite;
	_autoThresholdBlack = S._autoThresholdBlack;
	_k = S._k;
	if (S._type != ROI_UNDEF) _type = S._type;
	return (*this);
}
Area& Area::operator = (const Area* S) {
	return ((*this) = *S);
}
Area& Area::operator = (const CGRect& area) {
	_begin = Dot(area.origin.x, area.origin.y);
	_width = area.size.width;
	_height = area.size.height;
	_end = Dot(area.origin.x + _width, area.origin.y + _height);
	return (*this);
}
Area& Area::operator = (const Dot& d) {
	_begin = _end = d;
	_height = _width = 1;
	return (*this);
}
Area& Area::operator += (const Dot& d) {
	(*this) = CGRectUnion(cgrect(), CGRectMake(d.x(), d.y(), 1.0, 1.0));
	return (*this);
}

Area& Area::operator += (const Area& r) {
	(*this) = CGRectUnion(cgrect(), r.cgrect());
	_k += r._k;
	return (*this);
}





/**
 * Operator %, inclusion.
 * T % R returns true if area S is in area R and false otherwise.
 *       .........
 *       .   R   .
 *       . ..... .
 *       . . S . .
 *       . ..... .
 *       .........
 * @param S a read only reference to other ROI
 * @return true / false
 */
bool Area::operator % (const Area& S) const {
	return CGRectContainsRect(cgrect(), S.cgrect());
}



/**
 * Operator %, inclusion                      
 * R % p returns true if point p is in area R and false otherwise.    
 *  .........
 *  .   R   .
 *  .       .
 *  . .p    .
 *  .........
 * @param point a read only reference to a point
 * @return: true / false
 */
bool Area::operator % (const Dot& dot) const {
	return CGRectContainsPoint(cgrect(), dot.cgpoint());
}





/**
 * Operator !, empty or not.
 * ! R returns true if set R is empty and false otherwise.
 * @return: true or false
 */
bool Area::operator ! (void) const {
	return CGRectIsEmpty(cgrect());
}


/**
 * Operator R==S.
 * Overloaded comparisson operators.
 * @param S a read only reference to other ROI
 * @return: true or false
 */
bool Area::operator == (const Area& S) const {
	return CGRectEqualToRect(cgrect(), S.cgrect());
}

/**
 * Operator R!=S.
 * Overloaded comparisson operators.
 * @param S a read only reference to other ROI
 * @return: true or false
 */
bool Area::operator != (const Area& S) const {
	return (!((*this) == S));
}

/**
 * Operator R<S. 
 * Overloaded comparisson operators.
 * @param S a read only reference to other ROI
 * @return: true or false
 */
bool Area::operator <  (const Area& S) const {
#if 0
	if ((_autoThresholdWhite && _autoThresholdWhite < S._autoThresholdWhite) &&
	    (_autoThresholdBlack && _autoThresholdBlack < S._autoThresholdBlack) &&
	    (_threshold && _threshold < S._threshold) &&
	    (_k && _k < S._k))
#else
	if (_k < S._k)
#endif
		return true;

	return false;
}

/**
 * Operator R>S. 
 * Overloaded comparisson operators.
 * @param S a read only reference to other ROI
 * @return: true or false
 */
bool Area::operator >  (const Area& S) const {
	return (S < (*this));
}

/**
 * Operator R<=S. 
 * Overloaded comparisson operators.
 * @param S a read only reference to other ROI
 * @return: true or false
 */
bool Area::operator <= (const Area& S) const {
   return ((*this) < S) || ((*this) == S);
}



/**
 * Operator R>=S. 
 * Overloaded comparisson operators.
 * @param S a read only reference to other ROI
 * @return: true or false
 */
bool Area::operator >= (const Area& S) const {
   return ((*this) > S) || ((*this) == S);
}



#if defined(_DEBUG)
/**
 * Operator << ostream.
 * @param R a const reference to a ROI
 */
std::ostream& operator<<(std::ostream& out, const Area* R) {
	out << (*R);
	return out;
}
std::ostream& operator<<(std::ostream& out, const Area& R) {
	out << "{ ";
	do {
		if (R.type() == ROI_LEFT_EYEBROW) { out << "Left Eyebrow"; break; }
		if (R.type() == ROI_RIGHT_EYEBROW) { out << "Right Eyebrow"; break; }
		if (R.type() == ROI_LEFT_EYE) { out << "Left Eye"; break; }
		if (R.type() == ROI_RIGHT_EYE) { out << "Right Eye"; break; }
		if (R.type() == ROI_MOUTH) { out << "Mouth"; break; }
		if (R.type() == ROI_NOSE) { out << "Nose"; break; }
		if (R.type() == ROI_CHIN) { out << "Chin"; break; }
		if (R.type() == ROI_PUPIL) { out << "Pupil"; break; }
		if (R.type() == ROI_IRIS) { out << "Iris"; break; }
		if (R.type() == ROI_SCLERA) { out << "Sclera"; break; }
		out << " - ";
	} while(0);
	if (R.begin().x()) {
		Dot A(R.begin());
		Dot B(R.end().x(), R.begin().y());
		Dot C(R.begin().x(), R.end().y());
		Dot D(R.end());
		out << " (" << A << "|" << B << "|" << C << "|" << D << ")" 
		    << ", w=" << R.width() 
		    << ", h=" << R.height()
		    << ", k=" << R.k()
		    << ", r= " << std::setw(2) << std::setprecision(2) << R.ratio();
	}
        out << " }";
	return out;
}

/**
 * Log class properties.
 * @param msg is a customized message to print with the properties.
 */
void Area::log(NSString * msg) const {
	std::strstream s;
	s << [msg cStringUsingEncoding:NSASCIIStringEncoding] << " " << (*this) << '\0';
	NSLog(@"%s", s.str());
}
#endif

const Area& Area::area() const { return (*this); }
void Area::area(const Area& area) { (*this) = area; }
void Area::area(const CGRect& rect) { (*this) = rect; }

/// number of points detected
const int Area::k() const { return _k; }
void Area::k(int v) { _k = v; }
const enum RoiEnum Area::type() const { return _type; }
void Area::type(enum RoiEnum v) { if (v != ROI_UNDEF) _type = v; }

/// threshold by area
int Area::threshold() { return _threshold; }
void Area::threshold(int v) { _threshold = v; }
long Area::autoThresholdWhite() { return _autoThresholdWhite; }
void Area::autoThresholdWhite(long v) { _autoThresholdWhite = v; }
long Area::autoThresholdBlack() { return _autoThresholdBlack; }
void Area::autoThresholdBlack(long v) { _autoThresholdBlack = v; }



/**
 * Conversion from OpenCVDot to FaceItDot
 * y			d in areaOCV ----> d" in areaFaceIt
 * |			(x,y)			(x",y")
 * |  d.                 w,h                     w",h"
 * +------> x
 */
void Area::toFaceIt(int photoWidth, int photoHeight) {
	float x = (float)end().y() * FACTOR2;
	float y = (float)begin().x() * FACTOR1;
	float w = (float)height() * FACTOR2;
	float h = (float)width() * FACTOR1;
	(*this) = Area(photoWidth - x - w*2, photoHeight - y - h, w, h);
}

/**
 * Conversion from FaceItDot to OpeCVDot
 * y			d in areaOCV ----> d" in areaFaceIt
 * |			(x,y)			(x",y")
 * |  d.                 w,h                     w",h"
 * +------> x
 */
void Area::toOpenCV(int photoWidth, int photoHeight) {
	// w"
	float w = (float)height() / FACTOR1;
	// h"
	float h = ((int)((float)width() / FACTOR2) + 1);
	// y"
	float y = (photoWidth - begin().x() - width()*3)/FACTOR2;
	// x"
	float x = (photoHeight - begin().y() - height())/FACTOR1;
	(*this) = Area(x, y, w, h);
}

