///
/// Histeresys algorithm.
///
/// Created by Javier Fuchs on 1/1/11.
/// Copyright (C) 2014 Javier Fuchs. All rights reserved.
///
#ifndef __HISTERESYSALGORITHM_H__
#define __HISTERESYSALGORITHM_H__

/// Implement Histeresys algorithm.
class HisteresysAlgorithm : public Algorithm {
protected:
	float _tlow;
	float _thigh;
private:
	void follow_edges(Photo& photo, int x, int y);
	void follow_edges(Photo& photo, Photo& photoMag, int x, int y, short lowval);
public:
	HisteresysAlgorithm(Area& area);
	HisteresysAlgorithm(Area& area, float tlow, float thigh);
	void apply(Photo& photo);
	void apply(Photo& photoMag, Photo& photoNMS);
	BOOL run(const Photo&);
	BOOL transform(Photo& photo, int x, int y, Pixel& pixel);
};


#endif /* __HISTERESYSALGORITHM_H__ */
