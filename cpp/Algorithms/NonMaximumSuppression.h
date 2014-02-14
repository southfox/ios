///
/// Non-maximum suppression.
/// Given estimates of the image gradients, a search is then carried out to determine if the gradient magnitude assumes a 
/// local maximum in the gradient direction. So, for example,
/// - if the rounded angle is zero degrees the point will be considered to be on the edge if its intensity is greater 
///   than the intensities in the north and south directions,
/// - if the rounded angle is 90 degrees the point will be considered to be on the edge if its intensity is greater 
///   than the intensities in the west and east directions,
/// - if the rounded angle is 135 degrees the point will be considered to be on the edge if its intensity is greater 
///   than the intensities in the north east and south west directions,
/// - if the rounded angle is 45 degrees the point will be considered to be on the edge if its intensity is greater 
///   than the intensities in the north west and south east directions.
/// This is worked out by passing a 3x3 grid over the intensity map.
/// From this stage referred to as non-maximum suppression, a set of edge points, in the form of a binary image, is obtained. 
/// These are sometimes referred to as "thin edges".
///
/// Created by Javier Fuchs on 1/1/11.
/// Copyright (C) 2014 Javier Fuchs. All rights reserved.
///
#ifndef __NONMAXIMUMSUPPRESSIONALGORITHM_H__
#define __NONMAXIMUMSUPPRESSIONALGORITHM_H__

/// Implement Non Maximum Suppression Algorithm.
class NonMaximumSuppressionAlgorithm : public Algorithm {
protected:
	SobelEdgeDetectionAlgorithm * algoSobel;

public:
	NonMaximumSuppressionAlgorithm(Area& area);
	void apply_(Photo& photo);
	void apply(Photo& photo);
	BOOL run(const Photo&);
	BOOL transform(Photo& photo, int x, int y, Pixel& pixel);
};


#endif /* __NONMAXIMUMSUPPRESSIONALGORITHM_H__ */

