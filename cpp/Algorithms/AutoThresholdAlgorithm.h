///
/// Calculate threshold using the average value of the entire image intensity.
///
/// Created by Javier Fuchs on 1/1/11.
/// Copyright (C) 2014 Javier Fuchs. All rights reserved.
///
#ifndef __AUTOTHRESHOLD_H__
#define __AUTOTHRESHOLD_H__

/// AutoThreshold an image.
class AutoThresholdAlgorithm : public Algorithm {
protected:
	int _total;
	int _count;
	int _white;
	int _black;
	float _threshold;	
private:
public:
	AutoThresholdAlgorithm(Area&);
	BOOL run(const Photo&);
	BOOL stat(const Photo&, int x, int y);
	BOOL stat0(const Photo&, int x, int y);
	BOOL isWhite(const Photo&, int x, int y);

	void apply(Photo&);
	BOOL transform(Photo&, int x, int y, Pixel& pixel);

	void threshold(float threshold);
	float threshold();
	void white(int white);
	int white();
	void black(int black);
	int black();

};


#endif /* __AUTOTHRESHOLD_H__ */
