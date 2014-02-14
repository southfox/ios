///
/// RGB to YIQ conversion (http://en.wikipedia.org/wiki/YIQ)
/// YIQ is the color space used by the NTSC color TV system, employed mainly in North and Central America, and Japan. 
/// In the U.S., currently federally mandated for analog over-the-air TV broadcasting as shown in this excerpt of 
/// the current FCC rules and regulations part 73 "TV transmission standard":
/// “	The equivalent bandwidth assigned prior to modulation to the color difference signals EQ′ and EI′ are as follows:
/// Q-channel bandwidth: At 400 kHz less than 2 dB down. At 500 kHz less than 6 dB down. At 600 kHz at least 6 dB down.
/// I-channel bandwidth: At 1.3 MHz less than 2 dB down. At 3.6 MHz at least 20 dB down.
/// ”
/// I stands for in-phase, while Q stands for quadrature, referring to the components used in quadrature amplitude modulation. 
/// Some forms of NTSC now use the YUV color space, which is also used by other systems such as PAL.
/// The Y component represents the luma information, and is the only component used by black-and-white television receivers. 
/// I and Q represent the chrominance information. 
/// In YUV, the U and V components can be thought of as X and Y coordinates within the color space. 
/// I and Q can be thought of as a second pair of axes on the same graph, rotated 33°; 
/// therefore IQ and UV represent different coordinate systems on the same plane.
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
#import "YIQAlgorithm.h"

/**
 * RGB to YIQ conversion.
 */
YIQAlgorithm::YIQAlgorithm(Area& area) : Algorithm(area)
{
}


/**
 * RGB to YIQ conversion.
 * http://en.wikipedia.org/wiki/YIQ
 */
void YIQAlgorithm::apply(Photo& photo) {
	for (int x = begin().x(); x < end().x(); x++) {
		for (int y = begin().y(); y < end().y(); y++) {
			static Pixel pixel;
			transform(photo, x, y, pixel);
			photo.pixel(x, y, pixel);
		}
	}
}


BOOL YIQAlgorithm::transform(Photo& photo, int x, int y, Pixel& pixel) {
	Pixel * rgbPixel = photo.pixel(x, y);
	pixel = Pixel(255, rgbPixel->yuma(), rgbPixel->inphase(), rgbPixel->quadrature());
	return YES;
}

BOOL YIQAlgorithm::run(const Photo&) { return NO; }
