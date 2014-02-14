///
/// Area
///
/// Created by Javier Fuchs on 1/1/11.
/// Copyright 2014 Javier Fuchs. All rights reserved.
///

#ifndef __AREA_H__
#define __AREA_H__

/**
 * ROI: Region of Interest 
 */
enum RoiEnum {
	ROI_UNDEF = 0,
	ROI_LEFT_EYE,
	ROI_RIGHT_EYE,
	ROI_LEFT_EYEBROW,
	ROI_RIGHT_EYEBROW,
	ROI_NOSE,
	ROI_MOUTH,
	ROI_CHIN,
	ROI_PUPIL,
	ROI_SCLERA,
	ROI_IRIS,
	ROI_ALL
};


/// Common methods and attributes to every Area
class Area {
protected:
	//
	// How to interpret Coordinates:
	// (BEGIN.x,BEGIN.y) is the lower left point of the area
	// (END.x,BEGIN.y) is the lower right point of the area
	// (BEGIN.x,END.y) is the upper left point of the area
	// (END.x,END.y) is the upper right point of the area
	//
	// BEGIN.x,END.y   +---------+ END.x,END.y     +
	//                 |         |                 |
	//                 |         |                 | (height)
	//                 |         |                 |
	// BEGIN.x,BEGIN.y +---------+ END.x,BEGIN.y   +
        //                     
	//                 +---------+
	//                   (width)
	//
	Dot _begin;
	Dot _end;
	int _width;
	int _height;

	/// type of Roi
	enum RoiEnum _type;

	/// number of points detected
	int _k;

	/// threshold by roi
	int _threshold;
	long _autoThresholdWhite;
	long _autoThresholdBlack;

public:
	Area();
	Area(const Area&);
	Area(int x, int y, int w, int h);
	Area(const Dot& begin, const Dot& end);

	const Dot& begin() const;
	const Dot& end() const;
	int width() const;
	int height() const;
	CGRect cgrect() const;

	void begin(const Dot&);
	void end(const Dot&);
	void width(int w);
	void height(int h);

	float distance(const Dot&) const;
	float distance(const Area&) const;

	float ratio() const;
	float absoluteRatio() const;

	BOOL isRounded() const;
	BOOL isOval() const;

	BOOL isAlignedH(const Area&) const;

	/// Overloaded operator +, union
	Area operator + (const Area&) const;
	Area operator + (const Dot&) const;
	Area& operator += (const Dot&);
	Area& operator += (const Area&);
	/// Overloaded operator *, intersection
	Area operator * (const Area&) const;
	/// Overloaded operator -, difference
	Area operator - (const Area&) const;
	/// Overloaded operator ^, symetric difference
	Area operator ^ (const Area&) const;

	/// Overloaded operator =, assignment
	Area& operator = (const Area&);
	Area& operator = (const Area*);
	Area& operator = (const CGRect&);
	Area& operator = (const Dot&);

	/// Overloaded operator %, inclusion
	bool operator % (const Area&) const;
	bool operator % (const Dot&) const;

	/// Overloaded operator !, empty or not
	bool operator ! (void) const;

	/// Overloaded comparisson operators
	/// A==B
	bool operator == (const Area&) const;
	/// A!=B
	bool operator != (const Area&) const;
	/// A<B
	bool operator <  (const Area&) const;
	/// A>B
	bool operator >  (const Area&) const;
	/// A<=B
	bool operator <= (const Area&) const;
	/// A>=B
	bool operator >= (const Area&) const;

#if defined(_DEBUG)
	/// out operators
	friend std::ostream& operator<<(std::ostream& out, const Area*);
	friend std::ostream& operator<<(std::ostream&, const Area&);
	void log(NSString* msg = @"-") const;
#endif

	const Area& area() const;
	void area(const Area&);
	void area(const CGRect&);

	/// number of points detected
	const int k() const;
	void k(int);

	const enum RoiEnum type() const;
	void type(enum RoiEnum);

	/// threshold by roi
	int threshold();
	void threshold(int);

	/// TODO: put this in AutoThresholdAlgorithm?
	long autoThresholdWhite();
	void autoThresholdWhite(long);
	long autoThresholdBlack();
	void autoThresholdBlack(long);
	void toFaceIt(int photoWidth, int photoHeight);
	void toOpenCV(int photoWidth, int photoHeight);

};
#endif /* __AREA_H__ */

