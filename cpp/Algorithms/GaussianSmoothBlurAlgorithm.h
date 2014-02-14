///
/// Gaussian Smooth Blur.
///
/// Created by Javier Fuchs on 1/1/11.
/// Copyright (C) 2014 Javier Fuchs. All rights reserved.
///
#ifndef __GAUSSIANSMOOTHBLUR_H__
#define __GAUSSIANSMOOTHBLUR_H__

/// Implement Gaussian Smooth Blur Algorithm
class GaussianSmoothBlurAlgorithm : public Algorithm {
protected:
	static const int blur[5][5];
private:
public:
	GaussianSmoothBlurAlgorithm(Area& area);
	void apply(Photo& photo);
	BOOL run(const Photo&);
	BOOL transform(Photo& photo, int x, int y, Pixel& pixel);
};


#endif /* __GAUSSIANSMOOTHBLUR_H__ */
