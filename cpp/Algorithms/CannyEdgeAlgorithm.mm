///
/// Algorithm Canny Edge.
///
/// Created by Javier Fuchs on 1/1/11.
/// Copyright(C) 2014 Javier Fuchs. All rights reserved.
///

#include <vector>
#import "Dot.h"
#import "Defines.h"
#import "Area.h"
#import "Pixel.h"
#import "Algorithm.h"
#import "Photo.h"
#import "CannyEdgeAlgorithm.h"


/**
 * Non-maximum suppression.
 * Given estimates of the image gradients, a search is then carried out to determine if the gradient magnitude assumes a 
 * local maximum in the gradient direction. So, for example,
 * - if the rounded angle is zero degrees the point will be considered to be on the edge if its intensity is greater 
 *   than the intensities in the north and south directions,
 * - if the rounded angle is 90 degrees the point will be considered to be on the edge if its intensity is greater 
 *   than the intensities in the west and east directions,
 * - if the rounded angle is 135 degrees the point will be considered to be on the edge if its intensity is greater 
 *   than the intensities in the north east and south west directions,
 * - if the rounded angle is 45 degrees the point will be considered to be on the edge if its intensity is greater 
 *   than the intensities in the north west and south east directions.
 * This is worked out by passing a 3x3 grid over the intensity map.
 * From this stage referred to as non-maximum suppression, a set of edge points, in the form of a binary image, is obtained. 
 * These are sometimes referred to as "thin edges".
 * 
 * This code is copied from 
 * http://www.cc.gatech.edu/~kihwan23/KMosaic/Report/20051016/report20051016.htm
 * and http://www-users.cs.york.ac.uk/~bernat/pwcet/canny.c
 * @param mag
 * @param gradx
 * @param grady
 * @param nrows
 * @param ncols
 * @param result
 */

void CannyEdgeAlgorithm::non_max_supp(int *mag, int *gradx, int *grady, uint8_t* result)
{
	int nrows = height();
	int ncols = width();
	 
	int             rowcount, colcount, count;
	int            *magrowptr, *magptr;
	int            *gxrowptr, *gxptr;
	int            *gyrowptr, *gyptr, z1, z2;
	int             m00, gx, gy;
	float           mag1, mag2, xperp, yperp;
	uint8_t        *resultrowptr, *resultptr;

int bwPixelK = 0;

	/****************************************************************************
	 * Zero the edges of the result image.
	 ****************************************************************************/
	for (count = 0, resultrowptr = result, resultptr = result + ncols * (nrows - 1);
	     count < ncols; resultptr++, resultrowptr++, count++) {
		*resultrowptr = *resultptr = (unsigned char) 0;
	}

	for (count = 0, resultptr = result, resultrowptr = result + ncols - 1;
	count < nrows; count++, resultptr += ncols, resultrowptr += ncols) {
		*resultptr = *resultrowptr = (unsigned char) 0;
	}

	/****************************************************************************
	 * Suppress non - maximum points.
	 ****************************************************************************/
	for (rowcount = 1, magrowptr = mag + ncols + 1, gxrowptr = gradx + ncols + 1,
	     gyrowptr = grady + ncols + 1, resultrowptr = result + ncols + 1;
	     rowcount < nrows - 2;
	rowcount++, magrowptr += ncols, gyrowptr += ncols, gxrowptr += ncols,
	     resultrowptr += ncols) {
		for (colcount = 1, magptr = magrowptr, gxptr = gxrowptr, gyptr = gyrowptr,
		     resultptr = resultrowptr; colcount < ncols - 2;
		     colcount++, magptr++, gxptr++, gyptr++, resultptr++) {
			m00 = *magptr;
			if (m00 == 0) {
				*resultptr = (unsigned char) NOEDGE;
			} else {
				xperp = -(gx = *gxptr) / ((float) m00);
				yperp = (gy = *gyptr) / ((float) m00);
			}

			if (gx >= 0) {
				if (gy >= 0) {
					if (gx >= gy) {
						/* 111 */
						/* Left point */
						z1 = *(magptr - 1);
						z2 = *(magptr - ncols - 1);

						mag1 = (m00 - z1) * xperp + (z2 - z1) * yperp;

						/* Right point */
						z1 = *(magptr + 1);
						z2 = *(magptr + ncols + 1);

						mag2 = (m00 - z1) * xperp + (z2 - z1) * yperp;
					} else {
						/* 110 */
						/* Left point */
						z1 = *(magptr - ncols);
						z2 = *(magptr - ncols - 1);

						mag1 = (z1 - z2) * xperp + (z1 - m00) * yperp;

						/* Right point */
						z1 = *(magptr + ncols);
						z2 = *(magptr + ncols + 1);

						mag2 = (z1 - z2) * xperp + (z1 - m00) * yperp;
					}
				} else {
					if (gx >= -gy) {
						/* 101 */
						/* Left point */
						z1 = *(magptr - 1);
						z2 = *(magptr + ncols - 1);

						mag1 = (m00 - z1) * xperp + (z1 - z2) * yperp;

						/* Right point */
						z1 = *(magptr + 1);
						z2 = *(magptr - ncols + 1);

						mag2 = (m00 - z1) * xperp + (z1 - z2) * yperp;
					} else {
						/* 100 */
						/* Left point */
						z1 = *(magptr + ncols);
						z2 = *(magptr + ncols - 1);

						mag1 = (z1 - z2) * xperp + (m00 - z1) * yperp;

						/* Right point */
						z1 = *(magptr - ncols);
						z2 = *(magptr - ncols + 1);

						mag2 = (z1 - z2) * xperp + (m00 - z1) * yperp;
					}
				}
			} else {
				if ((gy = *gyptr) >= 0) {
					if (-gx >= gy) {
						/* 011 */
						/* Left point */
						z1 = *(magptr + 1);
						z2 = *(magptr - ncols + 1);

						mag1 = (z1 - m00) * xperp + (z2 - z1) * yperp;

						/* Right point */
						z1 = *(magptr - 1);
						z2 = *(magptr + ncols - 1);

						mag2 = (z1 - m00) * xperp + (z2 - z1) * yperp;
					} else {
						/* 010 */
						/* Left point */
						z1 = *(magptr - ncols);
						z2 = *(magptr - ncols + 1);

						mag1 = (z2 - z1) * xperp + (z1 - m00) * yperp;

						/* Right point */
						z1 = *(magptr + ncols);
						z2 = *(magptr + ncols - 1);

						mag2 = (z2 - z1) * xperp + (z1 - m00) * yperp;
					}
				} else {
					if (-gx > -gy) {
						/* 001 */
						/* Left point */
						z1 = *(magptr + 1);
						z2 = *(magptr + ncols + 1);

						mag1 = (z1 - m00) * xperp + (z1 - z2) * yperp;

						/* Right point */
						z1 = *(magptr - 1);
						z2 = *(magptr - ncols - 1);

						mag2 = (z1 - m00) * xperp + (z1 - z2) * yperp;
					} else {
						/* 000 */
						/* Left point */
						z1 = *(magptr + ncols);
						z2 = *(magptr + ncols + 1);

						mag1 = (z2 - z1) * xperp + (m00 - z1) * yperp;

						/* Right point */
						z1 = *(magptr - ncols);
						z2 = *(magptr - ncols - 1);

						mag2 = (z2 - z1) * xperp + (m00 - z1) * yperp;
					}
				}
			}

			/*
			 * Now determine if the current point is a maximum
			 * point
			 */

			if ((mag1 > 0.0) || (mag2 > 0.0)) {
				*resultptr = (unsigned char) NOEDGE;
			} else {
				if (mag2 == 0.0) {
					*resultptr = (unsigned char) NOEDGE;
				} else {
					bwPixelK++;
					*resultptr = (unsigned char) POSSIBLE_EDGE;
				}	
			}
		}
	}
	NSLog(@"bwPixelK = %d", bwPixelK);
}

/**
 * folow edges.
 * @param edgemapptr
 * @param edgemagptr
 * @param lowval
 * @param cols
 */
void CannyEdgeAlgorithm::follow_edges(uint8_t* edgemapptr, int* edgemagptr, short lowval, int cols)
{
	 
	int            *tempmagptr;
	uint8_t        *tempmapptr;
	int             i;
	int             x[8] = {1, 1, 0, -1, -1, -1, 0, 1},
	                y[8] = {0, 1, 1, 1, 0, -1, -1, -1};

	for (i = 0; i < 8; i++) {
		tempmapptr = edgemapptr - y[i] * cols + x[i];
		tempmagptr = edgemagptr - y[i] * cols + x[i];

		if ((*tempmapptr == POSSIBLE_EDGE) && (*tempmagptr > lowval)) {
			*tempmapptr = (unsigned char) EDGE;
			follow_edges(tempmapptr, tempmagptr, lowval, cols);
		}
	}
}

/**
 * apply hysteresis.
 * Tracing edges through the image and hysteresis thresholding.
 * Intensity gradients which are large are more likely to correspond to edges than if they are small. 
 * It is in most cases impossible to specify a threshold at which a given intensity gradient switches from corresponding 
 * to an edge into not doing so. Therefore Canny uses thresholding with hysteresis.
 * Thresholding with hysteresis requires two thresholds - high and low. 
 * Making the assumption that important edges should be along continuous curves in the image allows us to follow a faint 
 * section of a given line and to discard a few noisy pixels that do not constitute a line but have produced large gradients. 
 * Therefore we begin by applying a high threshold. This marks out the edges we can be fairly sure are genuine. 
 * Starting from these, using the directional information derived earlier, edges can be traced through the image. 
 * While tracing an edge, we apply the lower threshold, allowing us to trace faint sections of edges as long as we find a starting point.
 * Once this process is complete we have a binary image where each pixel is marked as either an edge pixel or a non-edge pixel. 
 * From complementary output from the edge tracing step, the binary edge map obtained in this way can also be treated as a set of 
 * edge curves, which after further processing can be represented as polygons in the image domain.
 * 
 * @param mag
 * @param nms
 * @param rows
 * @param cols
 * @param tlow
 * @param thigh
 * @param edge
 */
void CannyEdgeAlgorithm::apply_hysteresis(Photo& photo, int *mag, uint8_t * nms, uint8_t * edge)
{
	int rows = height();
	int cols = width();
	 
	int             r, c, pos, numedges, highcount, lowthreshold, highthreshold,
	                hist[32768];
	int             maximum_mag;

	/****************************************************************************
	 * Initialize the edge map to possible edges everywhere the non - maximal
	 * suppression suggested there could be an edge except for the border. At
	 * the border we say there can not be an edge because it makes the
	 * follow_edges algorithm more efficient to not worry about tracking an
	 * edge off the side of the image.
	 ****************************************************************************/
	for (r = 0, pos = 0; r < rows; r++) {
		for (c = 0; c < cols; c++, pos++) {
			if (nms[pos] == POSSIBLE_EDGE)
				edge[pos] = POSSIBLE_EDGE;
			else
				edge[pos] = NOEDGE;
		}
	}
#if 0
	for (int y = y0; y < y1; y++) {
		for (int x = x0; x < x1; x++) {
			int tmpy = (y-y0);
			int tmpx = (x-x0);
			if (edge[tmpy * w + tmpx] == POSSIBLE_EDGE) {
				photo.pixel(x, y, EDGE);
			}
		}
	}
#endif

	for (r = 0, pos = 0; r < rows; r++, pos += cols) {
		edge[pos] = NOEDGE;
		edge[pos + cols - 1] = NOEDGE;
	}
	pos = (rows - 1) * cols;
	for (c = 0; c < cols; c++, pos++) {
		edge[c] = NOEDGE;
		edge[pos] = NOEDGE;
	}

	/****************************************************************************
	 * Compute the histogram of the magnitude image. Then use the histogram to
	 * compute hysteresis thresholds.
	 ****************************************************************************/
	for (r = 0; r < 32768; r++)
		hist[r] = 0;
	for (r = 0, pos = 0; r < rows; r++) {
		for (c = 0; c < cols; c++, pos++) {
			if (edge[pos] == POSSIBLE_EDGE)
				hist[mag[pos]]++;
		}
	}

	/****************************************************************************
	 * Compute the number of pixels that passed the nonmaximal suppression.
	 ****************************************************************************/
	for (r = 1, numedges = 0; r < 32768; r++) {
		if (hist[r] != 0)
			maximum_mag = r;
		numedges += hist[r];
	}

	highcount = (int) (numedges * _thigh + 0.5);
	NSLog(@"numedges = %d - highcount = %d", numedges, highcount);

	/****************************************************************************
	 * Compute the high threshold value as the (100 * thigh) percentage point
	 * in the magnitude of the gradient histogram of all the pixels that passes
	 * non - maximal suppression. Then calculate the low threshold as a fraction
	 * of the computed high threshold value. John Canny said in his paper
	 * "A Computational Approach to Edge Detection" that "The ratio of the
	 * high to low threshold in the implementation is in the range two or three
	 * to one." That means that in terms of this implementation, we should
	 * choose tlow ~ =  0.5 or 0.33333.
	 ****************************************************************************/
	r = 1;
	numedges = hist[1];
	while ((r < (maximum_mag - 1)) && (numedges < highcount)) {
		r++;
		numedges += hist[r];
	}
	highthreshold = r;
	lowthreshold = (int) (highthreshold * _tlow + 0.5);
	/****************************************************************************
	 * This loop looks for pixels above the highthreshold to locate edges and
	 * then calls follow_edges to continue the edge.
	 ****************************************************************************/
	for (r = 0, pos = 0; r < rows; r++) {
		for (c = 0; c < cols; c++, pos++) {
			if ((edge[pos] == POSSIBLE_EDGE) && (mag[pos] >= highthreshold)) {
				edge[pos] = EDGE;
				follow_edges((edge + pos), (mag + pos), lowthreshold, cols);
			}
		}
	}

	/****************************************************************************
	 * Set all the remaining possible edges to non - edges.
	 ****************************************************************************/
	for (r = 0, pos = 0; r < rows; r++) {
		for (c = 0; c < cols; c++, pos++)
			if (edge[pos] != EDGE)
				edge[pos] = NOEDGE;
	}
}

/**
 * Canny edge detection.
 * http://en.wikipedia.org/wiki/Canny_edge_detector
 * @param tlow
 * @param thigh
 */
CannyEdgeAlgorithm::CannyEdgeAlgorithm(Area& area) : Algorithm(area)
{
	_tlow = THRESHOLD_LOW_MAX;
	_thigh = THRESHOLD_HIGH_MAX;

	int shift = 3;
	width(width() - shift);
	height(height() - shift);
	end(Dot(end().x() - shift, end().y() - shift));
}

CannyEdgeAlgorithm::CannyEdgeAlgorithm(Area& area, float tlow, float thigh) : Algorithm(area)
{
	_tlow = tlow;
       	_thigh = thigh;

	int shift = 3;
	width(width() - shift);
	height(height() - shift);
	end(Dot(end().x() - shift, end().y() - shift));
}

/**
 * Run Canny edge Algorithm.
 * http://en.wikipedia.org/wiki/Canny_edge_detector
 * @param photo
 * @param area
 */
void CannyEdgeAlgorithm::apply(Photo& photo)
{
	 
	// masks for sobel edge detection
	int gx[3][3] = {
		{ -1,  0,  1},
		{ -2,  0,  2},
		{ -1,  0,  1}};
	int gy[3][3] = {
		{  1,  2,  1},
		{  0,  0,  0},
		{ -1, -2, -1}};


	int lenInt = sizeof(int) * height() * width();
	int *diffx = (int *) malloc(lenInt);
	int *diffy = (int *) malloc(lenInt);
	int *mag = (int *) malloc(lenInt);
	memset(diffx, 0, lenInt);
	memset(diffy, 0, lenInt);
	memset(mag, 0, lenInt);

	// compute the magnitute and the x and y differences in the image
	for (int y = begin().y(); y < end().y(); y++) {
		for (int x = begin().x(); x < end().x(); x++) {
			int resultX = 0;
			int resultY = 0;
			for (int dy = 0; dy < 3; dy++) {
				for (int dx = 0; dx < 3; dx++) {
					uint32_t bwPixel = photo.pixel(x + dx,y + dy)->bw();
					resultX += bwPixel * gx[dy][dx];
					resultY += bwPixel * gy[dy][dx];
				}
			}
			int tmpy = (y-begin().y());
			int tmpx = (x-begin().x());
			mag[tmpy * width() + tmpx] = abs(resultX) + abs(resultY);
			diffx[tmpy * width() + tmpx] = resultX;
			diffy[tmpy * width() + tmpx] = resultY;
		}
	}
	int lenUInt8 = sizeof(uint8_t) * height() * width();
	uint8_t *nms = (uint8_t *) malloc(lenUInt8);
	memset(nms, 0, lenUInt8);
	non_max_supp(mag, diffx, diffy, nms);

	free(diffx);
	free(diffy);

	// apply hysteresis
	uint8_t *edge = (uint8_t *) malloc(lenUInt8);
	memset(edge, 0, lenUInt8);
	apply_hysteresis(photo, mag, nms, edge);

	free(nms);
	free(mag);

	// draw edges in the buffers (Color and black and white) 
	for (int y = begin().y(); y < end().y(); y++) {
		for (int x = begin().x(); x < end().x(); x++) {
			int tmpy = (y-begin().y());
			int tmpx = (x-begin().x());
			if (edge[tmpy * width() + tmpx] == EDGE) {
				photo.pixel(x, y, EDGE);
			}
		}
	}
	free(edge);
}

BOOL CannyEdgeAlgorithm::transform(Photo& photo, int x, int y, Pixel& pixel) {
	assert(0); // TODO: it's not a per pixel algorithm
	return NO;
}
BOOL CannyEdgeAlgorithm::run(const Photo& photo) {
	assert(0); // TODO: it's not a per pixel algorithm
	return NO;
}
