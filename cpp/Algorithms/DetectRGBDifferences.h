///
/// Detect RGB Differences.
///
/// Created by Javier Fuchs on 1/1/11.
/// Copyright (C) 2014 Javier Fuchs. All rights reserved.
///
#ifndef __DETECTRGBDIFFERENCES_H__
#define __DETECTRGBDIFFERENCES_H__

#define RGB_EDGE 1


/*
enum StatEnum {
	STAT_MIN = 1,
	STAT_MID,
	STAT_MAX
};
*/


/* 
 * CUADRANTS
 *  II  |  I 
 * -----------
 *  III | IV 
*/
enum QuadrantEnum {
	QUAD_I = 1,
	QUAD_II,
	QUAD_III,
	QUAD_IV
};

/* TODO: this could be the attributes of this class in the future
         maybe a change from a static message or method to a non static
	 will come */
typedef struct {
	int x;
	int y;
	int r;
	int g;
	int b;
	int a;
	enum QuadrantEnum quadrant;
	enum RoiEnum roi;
//	enum StatEnum stat;
} FacePoint;


/// Implement DetectRGBDifferences Algorithm
class DetectRGBDifferences: public Algorithm {
protected:
	int _threshold;
	FacePoint limit;
	FacePoint tmp;
private:
public:
	DetectRGBDifferences(Area& area);
	DetectRGBDifferences(Area& area, int threshold);
	void apply(Photo& photo);
	BOOL run(const Photo&);
	BOOL transform(Photo& photo, int x, int y, Pixel& pixel);
};


#endif /* __DETECTRGBDIFFERENCES_H__ */
