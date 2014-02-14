///
/// Binary erosion using a 3x3 square kernal.
/// http://en.wikipedia.org/wiki/Erosion_(morphology)
/// Erosion is one of two fundamental operations (the other being dilation) in Morphological image processing 
/// from which all other morphological operations are based. It was originally defined for binary images, 
/// later being extended to grayscale images, and subsequently to complete lattices.
///
/// Created by Javier Fuchs on 1/1/11.
/// Copyright (C) 2014 Javier Fuchs. All rights reserved.
///
#ifndef __EROSION_H__
#define __EROSION_H__

/// Implement Erosion algorithm
class ErosionAlgorithm : public Algorithm {
protected:
	static const Dot dots[8];
private:
public:
	ErosionAlgorithm(Area& area);
	void apply(Photo& photo);
	BOOL run(const Photo&);
	BOOL transform(Photo& photo, int x, int y, Pixel& pixel);
};


#endif /* __EROSION_H__ */
