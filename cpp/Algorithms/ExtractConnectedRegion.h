///
/// Extract connected regions.
///
/// Created by Javier Fuchs on 1/1/11.
/// Copyright (C) 2014 Javier Fuchs. All rights reserved.
///
#ifndef __EXTRACTCONNECTEDREGION_H__
#define __EXTRACTCONNECTEDREGION_H__

/// Extract connected regions.
class ExtractConnectedRegion {
protected:
	int _x;
	int _y;
	Dot::Vector *_points;
private:
public:
	ExtractConnectedRegion(int x, int y, Dot::Vector& points);
	void apply(Photo& photo, Area& area);
};


#endif /* __EXTRACTCONNECTEDREGION_H__ */
