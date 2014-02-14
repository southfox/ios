///
/// Invert the image polarity.
///
/// Created by Javier Fuchs on 1/1/11.
/// Copyright (C) 2014 Javier Fuchs. All rights reserved.
///
#ifndef __INVERT_H__
#define __INVERT_H__

/// Implement Canny Edge Algorithm
class InvertAlgorithm : public Algorithm {
protected:
private:
public:
	InvertAlgorithm(Area& area);
	void apply(Photo& photo);
	BOOL run(const Photo&);
	BOOL transform(Photo& photo, int x, int y, Pixel& pixel);
};


#endif /* __INVERT_H__ */
