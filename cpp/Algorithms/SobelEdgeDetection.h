///
/// Sobel Edge Algorithm (http://en.wikipedia.org/wiki/Sobel_operator)
/// The Sobel operator is used in image processing, particularly within edge detection algorithms. 
/// Technically, it is a discrete differentiation operator, computing an approximation of the gradient 
/// of the image intensity function. At each point in the image, the result of the Sobel operator is 
/// either the corresponding gradient vector or the norm of this vector. The Sobel operator is based on 
/// convolving the image with a small, separable, and integer valued filter in horizontal and vertical 
/// direction and is therefore relatively inexpensive in terms of computations. 
/// On the other hand, the gradient approximation which it produces is relatively crude, in particular 
/// for high frequency variations in the image.
/// The operator uses two 3×3 kernels which are convolved with the original image to calculate approximations 
/// of the derivatives - one for horizontal changes, and one for vertical. 
/// Gx and Gy are two images which at each point contain the horizontal and vertical derivative approximations
///
/// Created by Javier Fuchs on 1/1/11.
/// Copyright (C) 2014 Javier Fuchs. All rights reserved.
///
#ifndef __SOBELEDGEDETECTIONALGORITHM_H__
#define __SOBELEDGEDETECTIONALGORITHM_H__

/// Implement Sobel Edge Algorithm
class SobelEdgeDetectionAlgorithm : public Algorithm {
protected:
	static const int MatrixGx[3][3];
	static const int MatrixGy[3][3];
	int _resultX;
	int _resultY;
public:
	SobelEdgeDetectionAlgorithm(Area& area);
	void apply(Photo& photo);
	BOOL run(const Photo&);

	BOOL transform(Photo& photo, int x, int y, Pixel& pixel);
	int getResultX() const;
	int getResultY() const;
};


#endif /* __SOBELEDGEDETECTIONALGORITHM_H__ */
