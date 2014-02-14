///
/// Miscelaneous algorithms.
///
/// Created by Javier Fuchs on 1/1/11.
/// Copyright (C) 2014 Javier Fuchs. All rights reserved.
///
#ifndef __MISC_H__
#define __MISC_H__

/// Implement Misc Algorithm
class MiscAlgorithm : public Algorithm {
protected:
	Pixel *_pixel;
	int _l;
	int _k;
private:
public:
	MiscAlgorithm(const Area& area);
	~MiscAlgorithm();
	void apply(Photo& photo);
	BOOL run(const Photo&);
	/// draw functions
	void draw(Photo& photo, int r = 0, int g = 0, int b = 0, int l = 0, int k = 0);
	void draw(Photo& photo, Face& face);
	void crux(Photo& photo, const Dot& p, int r = 0, int g = 0, int b = 0, int l = 0, int k = 0);
	void dot(Photo& photo, const Dot& p, int r = 0, int g = 0, int b = 0);
	void crux(Photo& photo, Dot::Vector& p, int r = 0, int g = 0, int b = 0, int l = 0, int k = 0);
	BOOL transform(Photo& photo, int x, int y, Pixel& pixel);
};


#endif /* __MISC_H__ */
