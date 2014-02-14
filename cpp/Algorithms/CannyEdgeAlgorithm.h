///
/// Algorithm Canny Edge.
///
/// Created by Javier Fuchs on 1/1/11.
/// Copyright (C) 2014 Javier Fuchs. All rights reserved.
///
#ifndef __CANNYEDGEALGORITHM_H__
#define __CANNYEDGEALGORITHM_H__

/// Implement Canny Edge Algorithm
class CannyEdgeAlgorithm : public Algorithm {
protected:
	float _tlow;
	float _thigh;
private:
	void non_max_supp(int *mag, int *gradx, int *grady, uint8_t* result);
	void follow_edges(uint8_t* edgemapptr, int* edgemagptr, short lowval, int cols);
	void apply_hysteresis(Photo& photo, int *mag, uint8_t* nms, uint8_t* edge);
public:
	CannyEdgeAlgorithm(Area& area);
	CannyEdgeAlgorithm(Area& area, float tlow = THRESHOLD_LOW_MAX, float thigh = THRESHOLD_HIGH_MAX);
	void apply(Photo& photo);
	BOOL run(const Photo& photo);
	BOOL transform(Photo& photo, int x, int y, Pixel& pixel);
};


#endif /* __CANNYEDGEALGORITHM_H__ */
