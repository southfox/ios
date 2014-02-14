///
/// Handles grey scale and color photograph.
///
/// Created by Javier Fuchs on 4/28/09.
/// Copyright(C) 2014 Javier Fuchs. All rights reserved.
///
#include <vector>
#import "Defines.h"
#import "Pixel.h"
#import "Photo.h"
#include <math.h>



/**
 * Create an empty region of a photograpn using width, height and scale.
 * @param width
 * @param height
 * @param scale
 */
Photo::Photo(int width, int height, int scale)
{
	 
	_buffer = (uint8_t *) malloc(width * height * sizeof(uint32_t));
	_width = width;
	_height = height;
	_scale = scale;
}

/**
 * Constructor using a pointer to a buffer, width and height.
 * @param buffer is the pointer to the buffer to use
 * @param width
 * @param height
 * @param scale
 */
Photo::Photo(uint8_t *buffer, int width, int height, int scale)
{
	 
	_buffer = buffer;
	_width = width;
	_height = height;
	_scale = scale;
}


/**
 * Constructor using a pointer to UIImage and a scale.
 * @param originalUIImage
 * @param width
 * @param height
 * @param scale
 */
Photo::Photo(UIImage * originalUIImage, int scale)
{
	 
	_width = originalUIImage.size.width/scale;
	_height = originalUIImage.size.height/scale;
	_scale = scale;
	// get a colored buffer
	_buffer = (uint8_t *) malloc(_width * _height * 4);
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef    context = CGBitmapContextCreate(_buffer, _width, _height, 8, _width * 4, colorSpace, 
			kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
	CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
	CGContextSetShouldAntialias(context, NO);
	CGContextDrawImage(context, CGRectMake(0, 0, _width, _height),[originalUIImage CGImage]);
	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);
}


/**
 * Destructor.
 */
Photo::~Photo() {
	if (_buffer != nil) free(_buffer);
}


/**
 * Get a pixel of the photograph using x and y coordinates.
 * @param x is the coordinate in the x-axis.
 * @param y is the coordinate in the y-axis.
 * @return a static pointer of a pixel.
 */
Pixel* Photo::pixel(int x, int y) const {
	int i = ((y * _width + x) * 4);
	static Pixel pix;
	pix = _buffer+i;
	return (&pix);
}

/**
 * Set a pixel of the photograph using pre-calculated index coordinate (private method).
 * @param rowIndex is the pre-calculated n-byte in the buffer.
 * @param value is the new value
 */
void Photo::setPixel(int rowIndex, uint32_t value) {
	_buffer[rowIndex] = value;
}

/**
 * Set a pixel of the photograph using x and y coordinates.
 * @param x is the coordinate in the x-axis.
 * @param y is the coordinate in the y-axis.
 * @param value is the new value
 */
void Photo::pixel(int x, int y, uint32_t value) {
	Pixel pix(value);
	pixel(x, y, pix);
}

/**
 * Set a pixel of the photograph using x and y coordinates and the instance of pixel.
 * @param x is the coordinate in the x-axis.
 * @param y is the coordinate in the y-axis.
 * @param pix is an instance of the class Pixel with the new pixel information
 */
void Photo::pixel(int x, int y, const Pixel& pix) {
	pixel(x, y, pix.alpha(), pix.red(), pix.green(), pix.blue());
}

/**
 * Set a pixel of the photograph using x and y coordinates and every rgb value.
 * @param x is the coordinate in the x-axis.
 * @param y is the coordinate in the y-axis.
 * @param alpha is the alpha representation
 * @param red is the red representation
 * @param green is the green representation
 * @param blue is the blue representation
 */
void Photo::pixel(int x, int y, int alpha, int red, int green, int blue) {
	int i = ((y * _width + x) * 4);
	setPixel(i++, alpha);
	setPixel(i++, red);
	setPixel(i++, green);
	setPixel(i++, blue);
}


/**
 * Get width.
 * @return An integer value indicating the width of the photograph.
 */
int Photo::width() const {
	return _width;
}

/**
 * Get height.
 * @return An integer value indicating the height of the photograph.
 */
int Photo::height() const {
	return _height;
}


/**
 * Get Scale.
 * @return An integer value indicating the scale of the photograph.
 */
int Photo::scale() const {
	return _scale;
}



/**
 * Creates and returns an image object that uses the specified image data from the photograph.
 * @return a new image object for the specified image data from the photograph.
 */
UIImage * Photo::imageWithPhoto(BOOL rotate)
{
	 
	UIImage  *resultImage = nil;
	// create a UIImage
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef    context = CGBitmapContextCreate(_buffer, _width, _height, 8, _width * sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);

	// Rotate and stretch: the image is originaly rotated.
	if (rotate == YES) {
		CGContextClipToRect(context, CGRectMake(0.0, 0.0, _width, _height));
		CGContextTranslateCTM (context, 0, _height);
		CGContextScaleCTM(context, 0.75, 1.335);
		CGContextRotateCTM(context, radians(-90.));
	}

	CGImageRef      imageRef = CGBitmapContextCreateImage(context);
	CGContextDrawImage(context, CGRectMake(0.0, 0.0, _width, _height), imageRef);

	CGContextSaveGState(context);
	CGImageRef imageMasked = CGBitmapContextCreateImage(context);

	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);
	resultImage =[UIImage imageWithCGImage:imageMasked];

	CGImageRelease(imageRef);
	CGImageRelease(imageMasked);

	return resultImage;
}



/**
 * Return a scaled copy of the image using an area.
 * @param inImage it's the image to scale
 * @param thumbRect it's the new area of the image.
 * @return an instance of a new UIImage
 */
UIImage * Photo::resizeImage(UIImage *inImage, CGRect thumbRect, BOOL rotate) {
	CGImageRef			imageRef = [inImage CGImage];
	CGImageAlphaInfo	alphaInfo = CGImageGetAlphaInfo(imageRef);
	
	if (alphaInfo == kCGImageAlphaNone)
		alphaInfo = kCGImageAlphaNoneSkipLast;

	// Build a bitmap context that's the size of the thumbRect
	size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
	size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
	size_t Width = CGImageGetWidth(imageRef);
	size_t Height = CGImageGetHeight(imageRef);
	NSLog(@"bpr = %d, bpc = %d, w = %d, h = %d", bytesPerRow, bitsPerComponent, Width, Height);

	CGContextRef bitmap = CGBitmapContextCreate(
				NULL,
				thumbRect.size.width,		// width
				thumbRect.size.height,		// height
				CGImageGetBitsPerComponent(imageRef),	// really needs to always be 8
				4 * thumbRect.size.width,	// rowbytes
				CGImageGetColorSpace(imageRef),
				alphaInfo
		);
	if (rotate == YES) {
		CGContextClipToRect(bitmap, CGRectMake(0.0, 0.0, thumbRect.size.width, thumbRect.size.height));
		CGContextTranslateCTM (bitmap, 0, thumbRect.size.height);
		CGContextScaleCTM(bitmap, 0.75, 1.335);
		CGContextRotateCTM(bitmap, radians(-90.));
	}

	// Draw into the context, this scales the image
	CGContextDrawImage(bitmap, thumbRect, imageRef);

	// Get an image from the context and a UIImage
	CGImageRef	ref = CGBitmapContextCreateImage(bitmap);
	UIImage*	result = [UIImage imageWithCGImage:ref];

	CGContextRelease(bitmap);	// ok if NULL
	CGImageRelease(ref);

	return result;
}

/**
 * Return a scaled copy of the image using a scale.  
 * @param inImage it's the image to scale
 * @param scale it's the new scale of the image.
 * @return an instance of a new UIImage
 */
UIImage * Photo::resizeImage(UIImage *inImage, int scale, BOOL rotate) {
	CGRect thumbRect = CGRectMake(0, 0, inImage.size.width/scale, inImage.size.height/scale);
	return Photo::resizeImage(inImage, thumbRect, rotate);
}

/**
 * Private function to covert degress in radians
 * @param degrees
 * @return radians.
 */
double Photo::radians (double degrees) {return degrees * M_PI/180;}

