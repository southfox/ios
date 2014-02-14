///
/// Pixel information. Initialy, pixel information is saved in _buffer as argb.
/// argb means Alpha, Red, Green and Blue.
/// Here you can pickup some public methods to get the pixel information in:
/// - alpha value
/// - red value
/// - green value
/// - blue value
/// - Y-Uma value
/// - I-Channel value
/// - Q-Channel value
/// - U-Luma value (or blue Luma)
/// - V-Luma value (or red Luma)
/// - hue value
/// - saturation value
/// - lightness value
///
/// Created by Javier Fuchs on 6/29/09.
/// Copyright 2014 Javier Fuchs. All rights reserved.
///

#import "Defines.h"
#import "Pixel.h"

/**
 * YUV (http://en.wikipedia.org/wiki/YUV) and YIQ (http://en.wikipedia.org/wiki/YIQ) conversions 
 * using this private static matrix. Every vector (or line in this matrix) corresponds to a 
 * channel bandwidth in YUV or YIQ.
 */
const float Pixel::MatrixConversionYIQUV[5][3] = {
	{  0.299,     0.587,     0.114},	// vector conversion to Y-Uma (YUV and YIQ)
	{  0.595716, -0.274453, -0.321263},	// vector conversion to I-channel (YIQ)
	{  0.211456, -0.522591,  0.311135},	// vector conversion to Q-channel (YIQ)
	{ -0.14713,  -0.28886,   0.436},	// vector conversion to U Luma, or blue Luma (YUV)
	{  0.615,    -0.51499,  -0.10001}};	// vector conversion to V Luma, or red Luma (YUV)


/**
 * Pixel default constructor
 */
Pixel::Pixel() {
	_buffer[kAlpha] = 0;
	_buffer[kRed] = 0;
	_buffer[kGreen] = 0;
	_buffer[kBlue] = 0;
}

/**
 * Pixel constructor using the same value for red, green and blue.
 * @param value is the value to set in the pixel.
 */
Pixel::Pixel(int value) {
	_buffer[kAlpha] = 0;
	_buffer[kRed] = value;
	_buffer[kGreen] = value;
	_buffer[kBlue] = value;
}

/**
 * Pixel constructor using a different value for alpha, red, green and blue.
 * @param alpha is the alpha representation
 * @param red is the red representation
 * @param green is the green representation
 * @param blue is the blue representation
 */
Pixel::Pixel(int alpha, int red, int green, int blue) {
	_buffer[kAlpha] = alpha;
	_buffer[kRed] = red;
	_buffer[kGreen] = green;
	_buffer[kBlue] = blue;
}

/**
 * Pixel constructor using a pointer a buffer with different representation for alpha, red, green and blue.
 * @param buffer is the pointer to a buffer with argb representation.
 */
Pixel::Pixel(uint8_t* buffer) {
	_buffer[kAlpha] = buffer[kAlpha];
	_buffer[kRed] = buffer[kRed];
	_buffer[kGreen] = buffer[kGreen];
	_buffer[kBlue] = buffer[kBlue];
}


/**
 * Assignment operator using a pointer a buffer with different representation for alpha, red, green and blue.
 * @param buffer is the pointer to a buffer with argb representation.
 * @return a reference of this instance
 */
Pixel& Pixel::operator = (uint8_t* buffer) {
	_buffer[kAlpha] = buffer[kAlpha];
	_buffer[kRed] = buffer[kRed];
	_buffer[kGreen] = buffer[kGreen];
	_buffer[kBlue] = buffer[kBlue];
	return (*this);
}

/**
 * Assignment operator using a reference to a Pixel.
 * @param Pixel is the reference to a Pixel
 * @return a reference of this instance
 */
Pixel& Pixel::operator = (const Pixel& pix) {
	_buffer[kAlpha] = pix._buffer[kAlpha];
	_buffer[kRed] = pix._buffer[kRed];
	_buffer[kGreen] = pix._buffer[kGreen];
	_buffer[kBlue] = pix._buffer[kBlue];
	return (*this);
}


/**
 * Convertes a RGB Pixel into a black and white representation (Private).
 * @return an integer representing the black and white representation of the pixel.
 */
uint32_t Pixel::toBW(uint32_t rgbPixel) const {
	uint32_t bwPixel = (rgbPixel >> 16) & 255;
	return bwPixel;
}

/**
 * Returns a black and white representation.
 * @return an integer representing the black and white representation of the pixel.
 */
uint32_t Pixel::bw() const {
	uint32_t * rgbPhotograph = (uint32_t*)_buffer;
	uint32_t rgbPixel = *rgbPhotograph;
	return toBW(rgbPixel);
}

/**
 * Returns a the pixel representation (used in different algorithms when the Pixel is already converted to BW or something else).
 * @return an integer representing the actual representation of the pixel.
 */
uint32_t Pixel::val() const {
	//uint32_t * rgbPhotograph = (uint32_t*)_buffer;
	//return *rgbPhotograph;
	return blue();
}


/**
 * Returns the alpha representation of the pixel.
 * @return an integer representing the actual alpha representation of the pixel.
 */
uint32_t Pixel::alpha() const {
	return _buffer[kAlpha];
}

/**
 * Returns the red representation of the pixel.
 * @return an integer representing the actual red representation of the pixel.
 */
uint32_t Pixel::red() const {
	return _buffer[kRed];
}


/**
 * Returns the green representation of the pixel.
 * @return an integer representing the actual green representation of the pixel.
 */
uint32_t Pixel::green() const {
	return _buffer[kGreen];
}


/**
 * Returns the blue representation of the pixel.
 * @return an integer representing the actual blue representation of the pixel.
 */
uint32_t Pixel::blue() const {
	return _buffer[kBlue];
}


/**
 * Returns a conversion of the Y-UMA representation of the pixel.
 * Y represents the overall brightness, or luminance (also called yuma).
 * Y is part of the components YIQ (http://en.wikipedia.org/wiki/YIQ) and YUV (http://en.wikipedia.org/wiki/YUV).
 * @return an integer representing the actual yuma representation of the pixel.
 */
uint32_t Pixel::yuma() const {
	return (MatrixConversionYIQUV[kYUma][0] * red() + 
		MatrixConversionYIQUV[kYUma][1] * green() + 
		MatrixConversionYIQUV[kYUma][2] * blue());
}

/**
 * Returns a conversion of the inphase or I-channel representation of the pixel. 
 * I stands for in-phase and is part of the components YIQ (http://en.wikipedia.org/wiki/YIQ).
 * In YIQ color space I-channel bandwidth is the signal assigned to the bandwidth:
 * 1.3 MHz less than 2 dB down. At 3.6 MHz at least 20 dB down.
 * @return an integer representing the actual i-channel representation of the pixel.
 */
uint32_t Pixel::inphase() const {
	return (MatrixConversionYIQUV[kInPhase][0] * red() + 
		MatrixConversionYIQUV[kInPhase][1] * green() + 
		MatrixConversionYIQUV[kInPhase][2] * blue());
}

/**
 * Returns a conversion of the quadrature or Q-channel representation of the pixel. 
 * Q stands for quadrature and is part of the components YIQ (http://en.wikipedia.org/wiki/YIQ), 
 * referring to the component used in quadrature amplitude modulation.
 * In YIQ color space Q-channel bandwidth is the signal assigned to the bandwidth:
 * At 400 kHz less than 2 dB down. At 500 kHz less than 6 dB down. At 600 kHz at least 6 dB down.
 * @return an integer representing the actual q-channel representation of the pixel.
 */
uint32_t Pixel::quadrature() const {
	return (MatrixConversionYIQUV[kQuadrature][0] * red() + 
		MatrixConversionYIQUV[kQuadrature][1] * green() + 
		MatrixConversionYIQUV[kQuadrature][2] * blue());
}


/**
 * Returns a conversion of the U (blue luma) representation of the pixel.
 * The U representation of chrominance was chosen over, straight R and B signals.
 * U is part of the YUV components.
 * @return an integer representing the actual blue luma representation of the pixel.
 */
uint32_t Pixel::uluma() const {
	return (MatrixConversionYIQUV[kULuma][0] * red() + 
		MatrixConversionYIQUV[kULuma][1] * green() + 
		MatrixConversionYIQUV[kULuma][2] * blue());
}

/**
 * Returns a conversion of the V (red luma) representation of the pixel.
 * The V representation of chrominance was chosen over, straight R and B signals.
 * V is part of the YUV components.
 * @return an integer representing the actual red luma representation of the pixel.
 */
uint32_t Pixel::vluma() const {
	return (MatrixConversionYIQUV[kVLuma][0] * red() + 
		MatrixConversionYIQUV[kVLuma][1] * green() + 
		MatrixConversionYIQUV[kVLuma][2] * blue());
}


/**
 * Returns a conversion of the H (hue) representation of the pixel.
 * The hue is part of HSL or HSV (http://en.wikipedia.org/wiki/HSL_and_HSV).
 * Both HSL and HSV can be thought of as describing colors as points in a cylinder (called a color solid) 
 * whose central axis ranges from black at the bottom to white at the top, with neutral colors between them.
 * The angle around the axis corresponds to "hue".
 * @return an integer representing the actual hue representation of the pixel.
 */
float Pixel::hue() const {
	float H;
	float min, max, delta;
	min = MIN3(red(), green(), blue());
	max = MAX3(red(), green(), blue());
	delta = (float)((float)max - (float)min);

	if (red() == max) {
		H = ((float)((float)green() - (float)blue())) / delta;		// between yellow & magenta
	} else if( green() == max ) {
		H = 2 + ((float)((float)blue() - (float)red())) / delta;	// between cyan & yellow
	} else {
		H = 4 + ((float)((float)red() - (float)green())) / delta;	// between magenta & cyan
	}
	H *= 60;				// degrees
	if (H < 0) {
		H += 360;
	}
	return H;
}

/**
 * Returns a conversion of the S (saturation) representation of the pixel.
 * The saturation is part of HSL or HSV (http://en.wikipedia.org/wiki/HSL_and_HSV).
 * Both HSL and HSV can be thought of as describing colors as points in a cylinder (called a color solid) 
 * whose central axis ranges from black at the bottom to white at the top, with neutral colors between them.
 * The distance from the axis corresponds to "saturation".
 * @return an integer representing the actual saturation representation of the pixel.
 */
float Pixel::saturation() const {
	float min, max, delta;
	min = MIN3(red(), green(), blue());
	max = MAX3(red(), green(), blue());
	delta = max - min;
	return ((max != 0) ? (delta / max) : 0);
}

/**
 * Returns a conversion of the L (lightness) representation of the pixel.
 * The lightness is part of HSL or HSV (http://en.wikipedia.org/wiki/HSL_and_HSV).
 * Both HSL and HSV can be thought of as describing colors as points in a cylinder (called a color solid) 
 * whose central axis ranges from black at the bottom to white at the top, with neutral colors between them.
 * The distance along the axis corresponds to "lightness", "value" or "brightness".
 * @return an integer representing the actual lightness representation of the pixel.
 */
float Pixel::lightness() const {
	return (MAX3(red(), green(), blue()));
}
