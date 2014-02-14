///
/// RGB to HSV conversion (http://en.wikipedia.org/wiki/HSL_and_HSV).
/// HSL and HSV are two related representations of points in an RGB color model that 
/// attempt to describe perceptual color relationships more accurately than RGB, 
/// while remaining computationally simple. 
/// HSL stands for hue, saturation and lightness, while HSV stands for hue, saturation and value.
/// Both HSL and HSV can be thought of as describing colors as points in a cylinder (called a color solid) 
/// whose central axis ranges from black at the bottom to white at the top, with neutral colors between them.
/// The angle around the axis corresponds to "hue".
/// The distance from the axis corresponds to "saturation".
/// The distance along the axis corresponds to "lightness", "value" or "brightness".
///
/// Created by Javier Fuchs on 1/1/11.
/// Copyright (C) 2014 Javier Fuchs. All rights reserved.
///
#ifndef __HSV_H__
#define __HSV_H__

/// Implement RGB to HSV conversion.
class HSVAlgorithm : public Algorithm {
protected:
private:
public:
	HSVAlgorithm(Area& area);
	void apply(Photo& photo);
	BOOL run(const Photo&);
	BOOL transform(Photo& photo, int x, int y, Pixel& pixel);
};


#endif /* __HSV_H__ */
