///
/// Skeletonise an image.
///
/// Created by Javier Fuchs on 1/1/11.
/// Copyright (C) 2014 Javier Fuchs. All rights reserved.
///
#ifndef __SKELETONISE_H__
#define __SKELETONISE_H__

/// Skeletonise an image.
class SkeletoniseAlgorithm : public Algorithm {
protected:
private:
public:
	SkeletoniseAlgorithm(Area& area);
	void apply(Photo& photo);
	BOOL run(const Photo&);
	BOOL transform(Photo& photo, int x, int y, Pixel& pixel);
};


#endif /* __SKELETONISE_H__ */
