///
/// Break down face algorithm.
///
/// Created by Javier Fuchs on 1/1/11.
/// Copyright (C) 2014 Javier Fuchs. All rights reserved.
///
#ifndef __BREAKDOWN_H__
#define __BREAKDOWN_H__

/// BreakDown an image.
class BreakDownAlgorithm : public Algorithm  {
protected:
	float _minWidth, _minHeight;
	Face * _face;
private:
public:
	BreakDownAlgorithm(Area& area);
	BreakDownAlgorithm(Area& area, float minWidth, float minHeight);
	void apply(Photo& photo);
	BOOL run(const Photo& photo);
	BOOL run(const Photo& photo, Area& area);
	BOOL run(const Photo& photo, Face& face);
	BOOL transform(Photo& photo, int x, int y, Pixel& pixel);
};


#endif /* __BREAKDOWN_H__ */
