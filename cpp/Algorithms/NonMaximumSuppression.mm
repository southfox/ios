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
#import "NonMaximumSuppression.h"


/**
 */
NonMaximumSuppressionAlgorithm::NonMaximumSuppressionAlgorithm(Area& area) : Algorithm(area)
{
	int shift = 3;
	width(width() - shift);
	height(height() - shift);
	end(Dot(end().x() - shift, end().y() - shift));
	algoSobel = new SobelEdgeDetectionAlgorithm(area);
}




/**
 * @param photo
 * @param area
 */
void NonMaximumSuppressionAlgorithm::apply_(Photo& photo) {
	 
	// compute the magnitute and the x and y differences in the image
	int   y, x, gx, gy;
	int   z1, z2;
	float mag1, mag2, xperp, yperp;

	int *mag = (int *) malloc(sizeof(int) * height() * width());
	memset(mag, 0, sizeof(int) * height() * width());
	// compute the magnitute and the x and y differences in the image

	for (int x = begin().x(); x < end().x(); x++) { // from x0, to x1
		for (int y = begin().y(); y < end().y(); y++) { // from y0, to y1
			int tmpy = (y-begin().y());
			int tmpx = (x-begin().x());
			static Pixel pixelSobel;
			algoSobel->transform(photo, x, y, pixelSobel);
			mag[tmpy * width() + tmpx] = pixelSobel.val();
		}
	}

	/****************************************************************************
	 * Suppress non - maximum points.
	 ****************************************************************************/
	/* begin 1st for */
	for (x = begin().x() + 1; x < end().x() - 2; x++) {
		for (y = begin().y() + 1; y < end().y() - 2; y++) { 
		/* begin 2nd for */

			Pixel pixelSobel;
			algoSobel->transform(photo, x, y, pixelSobel);
			int resultX = algoSobel->getResultX();
			int resultY = algoSobel->getResultY();

			if (pixelSobel.val() == 0) {
				photo.pixel(x, y, NOEDGE);
			} else {
				xperp = -(gx = resultX) / ((float) pixelSobel.val());
				yperp = (gy = resultY) / ((float) pixelSobel.val());
			}

			int tmpy = (y-begin().y());
			int tmpx = (x-begin().x());

			if (gx >= 0) {
				if (gy >= 0) {
					if (gx >= gy) {
						/* Left point */
//     .....
// y   .   .
// |   . * .
// x---.   .
//     .....
						z1 = mag[(tmpx-1) + (tmpy  ) * width()];
						z2 = mag[(tmpx-1) + (tmpy-1) * width()];

						mag1 = (pixelSobel.val() - z1) * xperp + (z2 - z1) * yperp;

						/* Right point */
						z1 = mag[(tmpx+1) + (tmpy  ) * width()];
						z2 = mag[(tmpx+1) + (tmpy+1) * width()];

						mag2 = (pixelSobel.val() - z1) * xperp + (z2 - z1) * yperp;
					} else {
						/* Left point */
						z1 = mag[(tmpx-1) + (tmpy  ) * width()];
						z2 = mag[(tmpx-1) + (tmpy-1) * width()];

						mag1 = (z1 - z2) * xperp + (z1 - pixelSobel.val()) * yperp;

						/* Right point */
						z1 = mag[(tmpx+1) + (tmpy  ) * width()];
						z2 = mag[(tmpx+1) + (tmpy+1) * width()];

						mag2 = (z1 - z2) * xperp + (z1 - pixelSobel.val()) * yperp;
					}
				} else {
					if (gx >= -gy) {
						/* Left point */
						z1 = mag[(tmpx  ) + (tmpy-1) * width()];
						z2 = mag[(tmpx+1) + (tmpy-1) * width()];

						mag1 = (pixelSobel.val() - z1) * xperp + (z1 - z2) * yperp;

						/* Right point */
						z1 = mag[(tmpx  ) + (tmpy+1) * width()];
						z2 = mag[(tmpx-1) + (tmpy+1) * width()];

						mag2 = (pixelSobel.val() - z1) * xperp + (z1 - z2) * yperp;
					} else {
						/* Left point */
						z1 = mag[(tmpx+1) + (tmpy  ) * width()];
						z2 = mag[(tmpx+1) + (tmpy-1) * width()];

						mag1 = (z1 - z2) * xperp + (pixelSobel.val() - z1) * yperp;

						/* Right point */
						z1 = mag[(tmpx-1) + (tmpy  ) * width()];
						z2 = mag[(tmpx-1) + (tmpy+1) * width()];

						mag2 = (z1 - z2) * xperp + (pixelSobel.val() - z1) * yperp;
					}
				}
			} else {
				if ((gy = resultY) >= 0) {
					if (-gx >= gy) {
						/* Left point */
						z1 = mag[(tmpx+1) + (tmpy  ) * width()];
						z2 = mag[(tmpx+1) + (tmpy-1) * width()];

						mag1 = (z1 - pixelSobel.val()) * xperp + (z2 - z1) * yperp;

						/* Right point */
						z1 = mag[(tmpx  ) + (tmpy-1) * width()];
						z2 = mag[(tmpx+1) + (tmpy-1) * width()];

						mag2 = (z1 - pixelSobel.val()) * xperp + (z2 - z1) * yperp;
					} else {
						/* Left point */
						z1 = mag[(tmpx-1) + (tmpy  ) * width()];
						z2 = mag[(tmpx-1) + (tmpy+1) * width()];

						mag1 = (z2 - z1) * xperp + (z1 - pixelSobel.val()) * yperp;

						/* Right point */
						z1 = mag[(tmpx+1) + (tmpy  ) * width()];
						z2 = mag[(tmpx+1) + (tmpy-1) * width()];

						mag2 = (z2 - z1) * xperp + (z1 - pixelSobel.val()) * yperp;
					}
				} else {
					if (-gx > -gy) {
						/* Left point */
						z1 = mag[(tmpx  ) + (tmpy+1) * width()];
						z2 = mag[(tmpx+1) + (tmpy+1) * width()];

						mag1 = (z1 - pixelSobel.val()) * xperp + (z1 - z2) * yperp;

						/* Right point */
						z1 = mag[(tmpx  ) + (tmpy-1) * width()];
						z2 = mag[(tmpx-1) + (tmpy-1) * width()];

						mag2 = (z1 - pixelSobel.val()) * xperp + (z1 - z2) * yperp;
					} else {
						/* Left point */
						z1 = mag[(tmpx+1) + (tmpy  ) * width()];
						z2 = mag[(tmpx+1) + (tmpy+1) * width()];

						mag1 = (z2 - z1) * xperp + (pixelSobel.val() - z1) * yperp;

						/* Right point */
						z1 = mag[(tmpx-1) + (tmpy  ) * width()];
						z2 = mag[(tmpx-1) + (tmpy-1) * width()];

						mag2 = (z2 - z1) * xperp + (pixelSobel.val() - z1) * yperp;
					}
				}
			}

			/*
			 * Now determine if the current point is a maximum
			 * point
			 */
			photo.pixel(x, y, ((mag1 > 0.0) || (mag2 > 0.0)) ? NOEDGE 
							: (mag2 == 0.0) ? NOEDGE 
							: POSSIBLE_EDGE);
		} /* end 2nd for */
	} /* end 1st for */
	free(mag);
}

void NonMaximumSuppressionAlgorithm::apply(Photo& photo) {
	 
	for (int x = begin().x() + 1; x < end().x() - 2; x++) {
		for (int y = begin().y() + 1; y < end().y() - 2; y++) { 
			static Pixel pixel;
			if (transform(photo, x, y, pixel) == YES)
				photo.pixel(x, y, pixel);
		}
	}
}

BOOL NonMaximumSuppressionAlgorithm::transform(Photo& photo, int x, int y, Pixel& pixel) {
	int   gx, gy;
	int   z1, z2;
	float mag1, mag2, xperp, yperp;

	BOOL ret = NO;
	Pixel pixelSobel;
	algoSobel->transform(photo, x, y, pixelSobel);
	int resultX = algoSobel->getResultX();
	int resultY = algoSobel->getResultY();

	int pixelSobelValue = pixelSobel.val();

	if (pixelSobelValue == 0) {
		pixel = Pixel(NOEDGE);
		ret = NO;
	} else {
		xperp = -(gx = resultX) / ((float) pixelSobelValue);
		yperp = (gy = resultY) / ((float) pixelSobelValue);
	}

	if (gx >= 0) {
		if (gy >= 0) {
			if (gx >= gy) {
				/* Left point */
//     .....
// y   .   .
// |   . * .
// x---.   .
//     .....
				z1 = photo.pixel(x-1, y  )->val();
				z2 = photo.pixel(x-1, y-1)->val();

				mag1 = (pixelSobelValue - z1) * xperp + (z2 - z1) * yperp;

				/* Right point */
				z1 = photo.pixel(x+1, y  )->val();
				z2 = photo.pixel(x+1, y+1)->val();

				mag2 = (pixelSobelValue - z1) * xperp + (z2 - z1) * yperp;
			} else {
				/* Left point */
				z1 = photo.pixel(x-1, y  )->val();
				z2 = photo.pixel(x-1, y-1)->val();

				mag1 = (z1 - z2) * xperp + (z1 - pixelSobelValue) * yperp;

				/* Right point */
				z1 = photo.pixel(x+1, y  )->val();
				z2 = photo.pixel(x+1, y+1)->val();

				mag2 = (z1 - z2) * xperp + (z1 - pixelSobelValue) * yperp;
			}
		} else {
			if (gx >= -gy) {
				/* Left point */
				z1 = photo.pixel(x  , y-1)->val();
				z2 = photo.pixel(x+1, y-1)->val();

				mag1 = (pixelSobelValue - z1) * xperp + (z1 - z2) * yperp;

				/* Right point */
				z1 = photo.pixel(x  , y+1)->val();
				z2 = photo.pixel(x-1, y+1)->val();

				mag2 = (pixelSobelValue - z1) * xperp + (z1 - z2) * yperp;
			} else {
				/* Left point */
				z1 = photo.pixel(x+1, y  )->val();
				z2 = photo.pixel(x+1, y-1)->val();

				mag1 = (z1 - z2) * xperp + (pixelSobelValue - z1) * yperp;

				/* Right point */
				z1 = photo.pixel(x-1, y  )->val();
				z2 = photo.pixel(x-1, y+1)->val();

				mag2 = (z1 - z2) * xperp + (pixelSobelValue - z1) * yperp;
			}
		}
	} else {
		if ((gy = resultY) >= 0) {
			if (-gx >= gy) {
				/* Left point */
				z1 = photo.pixel(x+1, y  )->val();
				z2 = photo.pixel(x+1, y-1)->val();

				mag1 = (z1 - pixelSobelValue) * xperp + (z2 - z1) * yperp;

				/* Right point */
				z1 = photo.pixel(x  , y-1)->val();
				z2 = photo.pixel(x+1, y-1)->val();

				mag2 = (z1 - pixelSobelValue) * xperp + (z2 - z1) * yperp;
			} else {
				/* Left point */
				z1 = photo.pixel(x-1, y  )->val();
				z2 = photo.pixel(x-1, y+1)->val();

				mag1 = (z2 - z1) * xperp + (z1 - pixelSobelValue) * yperp;

				/* Right point */
				z1 = photo.pixel(x+1, y  )->val();
				z2 = photo.pixel(x+1, y-1)->val();

				mag2 = (z2 - z1) * xperp + (z1 - pixelSobelValue) * yperp;
			}
		} else {
			if (-gx > -gy) {
				/* Left point */
				z1 = photo.pixel(x  , y+1)->val();
				z2 = photo.pixel(x+1, y+1)->val();

				mag1 = (z1 - pixelSobelValue) * xperp + (z1 - z2) * yperp;

				/* Right point */
				z1 = photo.pixel(x  , y-1)->val();
				z2 = photo.pixel(x-1, y-1)->val();

				mag2 = (z1 - pixelSobelValue) * xperp + (z1 - z2) * yperp;
			} else {
				/* Left point */
				z1 = photo.pixel(x+1, y  )->val();
				z2 = photo.pixel(x+1, y+1)->val();

				mag1 = (z2 - z1) * xperp + (pixelSobelValue - z1) * yperp;

				/* Right point */
				z1 = photo.pixel(x-1, y  )->val();
				z2 = photo.pixel(x-1, y-1)->val();

				mag2 = (z2 - z1) * xperp + (pixelSobelValue - z1) * yperp;
			}
		}
	}

	/*
	 * Now determine if the current point is a maximum
	 * point
	 */
	if ((mag1 > 0.0) || (mag2 > 0.0)) {
		pixel = Pixel(NOEDGE);
		ret = NO;
	} else {
		if (mag2 == 0.0) {
			pixel = Pixel(NOEDGE);
			ret = NO;
		} else {
			pixel = Pixel(POSSIBLE_EDGE);
			ret = YES;
		}
	}
	return ret;
}
BOOL NonMaximumSuppressionAlgorithm::run(const Photo&) { return NO; }
