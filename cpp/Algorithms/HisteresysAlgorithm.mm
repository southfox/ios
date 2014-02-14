///
/// Histeresys algorithm.
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
#import "HisteresysAlgorithm.h"



/**
 * folow edges.
 * @param edgemapptr
 * @param edgemagptr
 * @param lowval
 * @param w
 */
void HisteresysAlgorithm::follow_edges(Photo& photo, int x, int y)
{
	 
	int             i;
	int             mx[8] = {1, 1, 0, -1, -1, -1, 0, 1},
	                my[8] = {0, 1, 1, 1, 0, -1, -1, -1};

	for (i = 0; i < 8; i++) {
		int x2 = x - my[i];
		int y2 = y + mx[i];
		if (x2 >= width() || y2 >= height()) break;
		int magPixel = photo.pixel(x2, y2)->val();

		if (magPixel == POSSIBLE_EDGE) {
			photo.pixel(x2, y2, EDGE);
			follow_edges(photo, x2, y2);
		}
	}
}
void HisteresysAlgorithm::follow_edges(Photo& photoEdge, Photo& photoMag, int x, int y, short lowval)
{
	 
	int             i;
	int             mx[8] = {1, 1, 0, -1, -1, -1, 0, 1},
	                my[8] = {0, 1, 1, 1, 0, -1, -1, -1};

	for (i = 0; i < 8; i++) {
		int y2 = y - my[i];
		int x2 = x + mx[i];
		int edgePixel = photoEdge.pixel(x2, y2)->val();
		int magPixel = photoMag.pixel(x2, y2)->val();

		if ((edgePixel == POSSIBLE_EDGE) && (magPixel > lowval)) {
			photoEdge.pixel(x2, y2, EDGE);
			follow_edges(photoEdge, photoMag, x2, y2, lowval);
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
 * @param h
 * @param w
 * @param tlow
 * @param thigh
 * @param edge
 */

/**
 * histeresys algorithm
 * http://en.wikipedia.org/wiki/Canny_edge_detector
 * @param tlow
 * @param thigh
 */
HisteresysAlgorithm::HisteresysAlgorithm(Area& area) : Algorithm(area)
{
	_tlow = THRESHOLD_LOW_MAX;
       	_thigh = THRESHOLD_HIGH_MAX;
	int shift = 3;
	width(width() - shift);
	height(height() - shift);
	end(Dot(end().x() - shift, end().y() - shift));
}

HisteresysAlgorithm::HisteresysAlgorithm(Area& area, float tlow, float thigh) : Algorithm(area)
{
	_tlow = tlow;
       	_thigh = thigh;
	int shift = 3;
	width(width() - shift);
	height(height() - shift);
	end(Dot(end().x() - shift, end().y() - shift));
}

/**
 * Run histeresys algorithm
 * http://en.wikipedia.org/wiki/Canny_edge_detector
 * @param photo
 * @param area
 */
void HisteresysAlgorithm::apply(Photo& photo) {
	 

	int             y, x;

	for (y = begin().y(); y < end().y(); y++) {
		photo.pixel(0, y, NOEDGE);
		BOOL yfirst = YES;
		for (x = begin().x(); x < end().x(); x++) {
			if (yfirst == YES) {
				photo.pixel(x, 0, NOEDGE);
				yfirst = NO;
			} else {
				if (photo.pixel(x, y)->val() != POSSIBLE_EDGE) {
					photo.pixel(x, y, NOEDGE);
				}
			}
		}
	}

	/****************************************************************************
	 * This loop looks for pixels above the highthreshold to locate edges and
	 * then calls follow_edges to continue the edge.
	 ****************************************************************************/
	for (y = begin().y(); y < end().y(); y++) {
		for (x = begin().x(); x < end().x(); x++) {
			int magPixel = photo.pixel(x, y)->val();
			if (magPixel == POSSIBLE_EDGE)
			{
				photo.pixel(x, y, EDGE);
				follow_edges(photo, x, y);
			}
		}
	}

	/****************************************************************************
	 * Set all the remaining possible edges to non - edges.
	 ****************************************************************************/
	for (y = begin().y(); y < end().y(); y++) {
		for (x = begin().x(); x < end().x(); x++) {
			int magPixel = photo.pixel(x, y)->val();
			if (magPixel != EDGE) {
				photo.pixel(x, y, NOEDGE);
			}
		}
	}

}


void HisteresysAlgorithm::apply(Photo& photoMag, Photo& photoEdge) {
	 

	int             y, x, pos, numedges, highcount, lowthreshold, highthreshold,
	                hist[32768];
	int             maximum_mag;

	for (y = begin().y(); y < end().y(); y++) {
		photoEdge.pixel(begin().x(), y, NOEDGE);
		BOOL yfirst = YES;
		for (x = begin().x(); x < end().x(); x++, pos++) {
			if (yfirst == YES) {
				photoEdge.pixel(x, begin().y(), NOEDGE);
				yfirst = NO;
			} else {
				if (photoMag.pixel(x, y)->val() == POSSIBLE_EDGE) {
					photoEdge.pixel(x, y, POSSIBLE_EDGE);
				//} else {
					//photoEdge.pixel(x, y, NOEDGE);
				}
			}
		}
	}

	/****************************************************************************
	 * Compute the histogram of the magnitude image. Then use the histogram to
	 * compute hysteresis thresholds.
	 ****************************************************************************/
	for (int h = 0; h < 32768; h++)
		hist[h] = 0;
	for (y = begin().y(), pos = 0; y < end().y(); y++) {
		for (x = begin().x(); x < end().x(); x++, pos++) {
			int edgePixel = photoEdge.pixel(x, y)->val();
			if (edgePixel == POSSIBLE_EDGE) {
				hist[photoMag.pixel(x, y)->val()]++;
			}
		}
	}

	/****************************************************************************
	 * Compute the number of pixels that passed the nonmaximal suppression.
	 ****************************************************************************/
	for (int rr = 1, numedges = 0; rr < 32768; rr++) {
		if (hist[rr] != 0)
			maximum_mag = rr;
		numedges += hist[rr];
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
	int rr = 1;
	numedges = hist[1];
	while ((rr < (maximum_mag - 1)) && (numedges < highcount)) {
		rr++;
		numedges += hist[rr];
	}
	highthreshold = rr;
	lowthreshold = (int) (highthreshold * _tlow + 0.5);
	/****************************************************************************
	 or pixels above the highthreshold to locate edges and
	 * then calls follow_edges to continue the edge.
	 ****************************************************************************/
	for (y = begin().y(), pos = 0; y < end().y(); y++) {
		for (x = begin().x(); x < end().x(); x++, pos++) {
			int edgePixel = photoEdge.pixel(x, y)->val();
			int magPixel = photoMag.pixel(x, y)->val();
			if (edgePixel == POSSIBLE_EDGE && magPixel >= highthreshold) 
			{
				photoEdge.pixel(x, y, EDGE);
				follow_edges(photoEdge, photoMag, x, y, lowthreshold);
			}
		}
	}
}

BOOL HisteresysAlgorithm::transform(Photo& photo, int x, int y, Pixel& pixel) {
	assert(0); // TODO: it's not a per pixel algorithm
	return NO;
}
BOOL HisteresysAlgorithm::run(const Photo&) { return NO; }
