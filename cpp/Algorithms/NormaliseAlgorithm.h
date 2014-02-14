///
/// Normalise: Stretch the image brightness so that it takes the range 0-255
/// http://en.wikipedia.org/wiki/Normalization_(image_processing)
///
/// Created by Javier Fuchs on 1/1/11.
/// Copyright (C) 2014 Javier Fuchs. All rights reserved.
///
#ifndef __NORMALISE_H__
#define __NORMALISE_H__

/// Implement Normalise Algorithm
class NormaliseAlgorithm : public Algorithm {
protected:
	int _min;
	int _max;
private:
public:
	NormaliseAlgorithm(Area& area);
	void apply(Photo& photo);
	BOOL run(const Photo& photo);
	BOOL transform(Photo& photo, int x, int y, Pixel& pixel);
};


#endif /* __NORMALISE_H__ */
