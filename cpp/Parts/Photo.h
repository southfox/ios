///
/// Handles grey scale and color photograph.
///
/// Created by Javier Fuchs on 4/28/09.
/// Copyright (C) 2014 Javier Fuchs. All rights reserved.
///
#ifndef __PHOTOGRAPH_H__
#define __PHOTOGRAPH_H__

#import <UIKit/UIImage.h>

class Pixel;

/// Handles grey scale and color photograph.
class Photo {
protected:

	/// pointer to the image data
	uint8_t *_buffer;

	/// width of the image
	int _width;

	/// height of the image
	int _height;

	/// scale of the image
	int _scale;

private:
	static double radians(double degrees);
	void setPixel(int rowIndex, uint32_t pix);

public:
	/// constructor using width, height
	Photo(int width, int height, int scale = 1);

	/// constructor using a pointer to a buffer, width and height.
	Photo(uint8_t *buffer, int width, int height, int scale = 1);

	/// constructor using a pointer to UIImage, width and height.
	Photo(UIImage *uiimage, int scale = 1);

	/// destructor
	~Photo();

	/// access pixels
	Pixel* pixel(int x, int y) const;
	void pixel(int x, int y, uint32_t value);
	void pixel(int x, int y, const Pixel& pix);
	void pixel(int x, int y, int alpha, int red, int green, int blue);

	/// access more photograph properties
	int width() const;
	int height() const;
	int scale() const;

	/// convert back to a UIImage for display
	UIImage *imageWithPhoto(BOOL rotate = YES);

	/// Return a scaled down copy of the image.  
	static UIImage* resizeImage(UIImage *inImage, CGRect thumbRect, BOOL rotate = YES);
	static UIImage* resizeImage(UIImage *inImage, int scale = 1, BOOL rotate = YES);
};


#endif /* __PHOTOGRAPH_H__ */
