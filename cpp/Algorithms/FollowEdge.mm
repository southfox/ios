///
/// Follow Edge Algorithm.
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
#import "FollowEdge.h"


/**
 * Follow Edge algorithm.
 * @param tlow
 * @param thigh
 */
FollowEdgeAlgorithm::FollowEdgeAlgorithm(Area& area): Algorithm(area)
{
	int shift = 3;
	width(width() - shift);
	height(height() - shift);
	end(Dot(end().x() - shift, end().y() - shift));
	algoSobel = new SobelEdgeDetectionAlgorithm(area);
}




/**
 * Apply Follow Edge algorithm.
 * @param photo
 * @param area
 */

void FollowEdgeAlgorithm::apply(Photo& photo) {
	 

	/****************************************************************************
	 * Suppress non - maximum points.
	 ****************************************************************************/
	/* begin 1st for */
	for (int x = begin().x() + 1; x < end().x() - 2; x++) {
		for (int y = begin().y() + 1; y < end().y() - 2; y++) { 
			static Pixel pixel;
			if (transform(photo, x, y, pixel) == YES) {
				photo.pixel(x, y, pixel);
			}
		}
	}
}

BOOL FollowEdgeAlgorithm::transform(Photo& photo, int x, int y, Pixel& pixel) {
	// compute the magnitute and the x and y differences in the image
	int   gx, gy;
	int   z1, z2;

	float mag1, mag2, xperp, yperp;

	Pixel pixelSobel;
	algoSobel->transform(photo, x, y, pixelSobel);
	int resultX = algoSobel->getResultX();
	int resultY = algoSobel->getResultY();

	int pixelSobelValue = pixelSobel.val();

	if (pixelSobelValue != 0) {
		xperp = -(gx = resultX) / ((float) pixelSobelValue);
		yperp = (gy = resultY) / ((float) pixelSobelValue);
	}

	if (gx >= 0) {
		if (gy >= 0) {
			if (gx >= gy) {
				/* Left point */
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
	if ((mag1 < 0.0) && (mag2 < 0.0)) {
		pixel = Pixel(EDGE);
		return YES;
	}
	return NO;
}

BOOL FollowEdgeAlgorithm::run(const Photo&) { return NO; }
