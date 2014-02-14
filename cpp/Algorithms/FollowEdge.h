///
/// Follow Edge Algorithm.
///
/// Created by Javier Fuchs on 1/1/11.
/// Copyright (C) 2014 Javier Fuchs. All rights reserved.
///
#ifndef __FOLLOWEDGEALGORITHM_H__
#define __FOLLOWEDGEALGORITHM_H__

/// Implement Non Maximum Suppression Algorithm.
class FollowEdgeAlgorithm : public Algorithm {
protected:
	SobelEdgeDetectionAlgorithm * algoSobel;

public:
	FollowEdgeAlgorithm(Area& area);
	void apply(Photo& photo);
	BOOL run(const Photo&);
	BOOL transform(Photo& photo, int x, int y, Pixel& pixel);
};


#endif /* __FOLLOWEDGEALGORITHM_H__ */

