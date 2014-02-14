///
/// Pixel information. Initialy, pixel information is saved in _buffer as argb.
/// argb means Alpha, Red, Green and Blue (see RGB in http://www.colorschemer.com/online.html)
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
/// Created by Javier Fuchs on 1/1/11.
/// Copyright 2014 Javier Fuchs. All rights reserved.
///

#ifndef __PIXEL_H__
#define __PIXEL_H__

class Pixel {
protected:
	static const float MatrixConversionYIQUV[5][3];

	typedef enum {
		kAlpha=0,
		kRed=1,
		kGreen=2,
		kBlue=3
	} RGBMask;

	typedef enum {
		kHue=1,
		kSaturation=2,
		kLightness=3
	} HSVMask;

	typedef enum {
		kYUma=0,
		kInPhase=1,
		kQuadrature=2,
		kULuma=3,
		kVLuma=4
	} YIQMask;
	
	uint8_t _buffer[4];
private:
	uint32_t toBW() const;
	uint32_t toBW(uint32_t rgbPixel) const;

public:
	/// constructors.
	Pixel();
	Pixel(int value);
	Pixel(int alpha, int red, int green, int blue);
	Pixel(uint8_t* buffer);

	/// assignment operators.
	Pixel& operator = (const Pixel& pix);
	Pixel& operator = (uint8_t* buffer);

	/// automatic pixel conversion
	uint32_t bw() const;
	uint32_t val() const;
	uint32_t alpha() const;
	uint32_t red() const;
	uint32_t green() const;
	uint32_t blue() const;
	uint32_t yuma() const;
	uint32_t inphase() const;
	uint32_t quadrature() const;
	uint32_t uluma() const;
	uint32_t vluma() const;
	float hue() const;
	float saturation() const;
	float lightness() const;
};


#endif /* __PIXEL_H__ */

