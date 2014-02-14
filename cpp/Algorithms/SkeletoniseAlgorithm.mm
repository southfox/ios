///
/// Skeletonise an image.
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
#import "SkeletoniseAlgorithm.h"

/**
 * Skeletonise an image.
 */
SkeletoniseAlgorithm::SkeletoniseAlgorithm(Area& area) : Algorithm(area)
{
}


/**
 * Skeletonise an image.
 */
void SkeletoniseAlgorithm::apply(Photo& photo) {
	for(int y=begin().y(); y<end().y(); y++) {
		for(int x=begin().x(); x<end().x(); x++) {
			static Pixel pixel;
			if (transform(photo, x, y, pixel) == YES) {
				photo.pixel(x, y, pixel);
			}
		}
	}
}


BOOL SkeletoniseAlgorithm::transform(Photo& photo, int x, int y, Pixel& pixel) {
	BOOL ret = NO;
	if (photo.pixel(x,y)->bw() != 0) {
		bool val[8];
		val[0]=photo.pixel(x-1, y-1)->bw()!=0;
		val[1]=photo.pixel(x, y-1)->bw()!=0;
		val[2]=photo.pixel(x+1, y-1)->bw()!=0;
		val[3]=photo.pixel(x+1, y)->bw()!=0;
		val[4]=photo.pixel(x+1, y+1)->bw()!=0;
		val[5]=photo.pixel(x, y+1)->bw()!=0;
		val[6]=photo.pixel(x-1, y+1)->bw()!=0;
		val[7]=photo.pixel(x-1, y)->bw()!=0;
		
		bool change = false;
		for(int i=0; i<7 && !change;i++) {
			change = (val[(0+i)%8] && val[(1+i)%8] && val[(7+i)%8] && val[(6+i)%8] && val[(5+i)%8] && !(val[(2+i)%8] || val[(3+i)%8] || val[(4+i)%8]))
			|| (val[(0+i)%8] && val[(1+i)%8] && val[(7+i)%8] && !(val[(3+i)%8] || val[(6+i)%8] || val[(5+i)%8] || val[(4+i)%8])) ||
			!(val[(0+i)%8] || val[(1+i)%8] || val[(2+i)%8]  || val[(3+i)%8]  || val[(4+i)%8]  || val[(5+i)%8]  || val[(6+i)%8] || val[(7+i)%8]);
		}
		if (change) {
			pixel = Pixel(0);
			ret = YES;
		}
	}
	return ret;
}

BOOL SkeletoniseAlgorithm::run(const Photo&) { return NO; }
