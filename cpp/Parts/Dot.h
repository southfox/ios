///
/// Dot representation.
///
/// Created by Javier Fuchs on 5/4/09.
/// Copyright(C) 2014 Javier Fuchs. All rights reserved.
///
#ifndef __DOT_H__
#define __DOT_H__

class Dot;
class Area;

/// Simple class for holding an image point.
class Dot {
protected:
	/// x
	short _x;

	/// y
	short _y;

public:

	/// Constructor using short.
	Dot(short x, short y);

	/// Constructor using integer.
	Dot(int x, int y);

	/// Constructor using float.
	Dot(float x, float y);

	/// Copy constructor
	Dot(const Dot&);

	/// Default constructor
	Dot();

	/// Get x
	/// @return x
	int x() const;
	void x(int v);

	/// Get y
	/// @return y
	int y() const;
	void y(int);

	typedef std::vector<Dot> Vector;

#if defined(_DEBUG)
	/// out operators
	friend std::ostream& operator<<(std::ostream&, const Dot&);

	void log(NSString* msg = @"-") const;
#endif

	float distance(const Dot&) const;

	Dot& operator = (const Dot&);

	bool operator == (const Dot&) const;

	void toOpenCV(int width, int height, const Area&);

	CGPoint cgpoint() const;

};

#endif // __DOT_H__
