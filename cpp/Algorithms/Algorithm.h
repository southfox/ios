///
/// Algorithm.h
///
/// Created by Javier Fuchs on 1/1/11.
/// Copyright 2014 Javier Fuchs. All rights reserved.
///

#ifndef __ALGORITHM_H__
#define __ALGORITHM_H__

class Area;
class Photo;

class Algorithm : public Area {
public:
	/// Constructor
	Algorithm(const Area& area) : Area(area) {};
	/// Non mutating algorithm
	virtual BOOL run(const Photo&) = 0;
	/// Mutating algorithm
	virtual void apply(Photo&) = 0;
	/// Change from one pixel into the photograph to another
	virtual BOOL transform(Photo&, int, int, Pixel&) = 0;
};

#endif /* __ALGORITHM_H__ */

