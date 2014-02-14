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
/// Copyright(C) 2014 Javier Fuchs. All rights reserved.
///

#include <vector>
#import "Dot.h"
#import "Defines.h"
#import "Area.h"
#import "Pixel.h"
#import "Photo.h"
#import "Algorithm.h"
#import "SobelEdgeDetection.h"


/**
 * Constructor
 */
SobelEdgeDetectionAlgorithm::SobelEdgeDetectionAlgorithm(Area& area) : Algorithm(area)
{
}




/**
 * Run Sobel edge Algorithm.
 * http://en.wikipedia.org/wiki/Sobel_operator
 * @param photo
 * @param area
 */
void SobelEdgeDetectionAlgorithm::apply(Photo& photo) {
	 
	int shift = 3;
	width(width() - shift);
	height(height() - shift);
	end(Dot(end().x() - shift, end().y() - shift));
	// compute the magnitute and the x and y differences in the image
	for (int y = begin().y(); y < end().y(); y++) { // from y0, to y1
		for (int x = begin().x(); x < end().x(); x++) { // from x0, to x1
			static Pixel pixel;
			transform(photo, x, y, pixel);
			photo.pixel(x, y, pixel);
		}
	}
}


/// Gx and Gy are two images which at each point contain the horizontal and vertical derivative approximations
const int SobelEdgeDetectionAlgorithm::MatrixGx[3][3] = {
		{ -1,  0,  1},
		{ -2,  0,  2},
		{ -1,  0,  1}};
/// Gx and Gy are two images which at each point contain the horizontal and vertical derivative approximations
const int SobelEdgeDetectionAlgorithm::MatrixGy[3][3] = {
		{  1,  2,  1},
		{  0,  0,  0},
		{ -1, -2, -1}};


BOOL SobelEdgeDetectionAlgorithm::transform(Photo& photo, int x, int y, Pixel& pixel) {
	_resultX = 0;
	_resultY = 0;
	for (int dy = 0; dy < 3; dy++) {
		for (int dx = 0; dx < 3; dx++) {
			int bwPixel = photo.pixel(x + dx, y + dy)->bw();
			_resultX += bwPixel * MatrixGx[dy][dx];
			_resultY += bwPixel * MatrixGy[dy][dx];
		}
	}
	pixel = Pixel(abs(_resultX) + abs(_resultY));
	return TRUE;
}


int SobelEdgeDetectionAlgorithm::getResultX() const { return _resultX; }
int SobelEdgeDetectionAlgorithm::getResultY() const { return _resultY; }
BOOL SobelEdgeDetectionAlgorithm::run(const Photo&) { return NO; }
