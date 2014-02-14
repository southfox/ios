///
/// RGB to YUV conversion (http://en.wikipedia.org/wiki/YUV)
/// YUV is a color space typically used as part of a color image pipeline. 
/// It encodes a color image or video taking human perception into account, allowing reduced bandwidth for chrominance components, 
/// thereby typically enabling transmission errors or compression artifacts to be more efficiently masked by the human perception 
/// than using a "direct" RGB-representation.
/// Y: represents the overall brightness, or luminance (also called yuma).
/// U (blue luma) and V (red luma) are the chrominance (color) components
///
/// Created by Javier Fuchs on 1/1/11.
/// Copyright (C) 2014 Javier Fuchs. All rights reserved.
///
#ifndef __YUV_H__
#define __YUV_H__

/// Implement RGB to YUV conversion.
class YUVAlgorithm : public Algorithm {
protected:
private:
public:
	YUVAlgorithm(Area& area);
	void apply(Photo& photo);
	BOOL run(const Photo&);
	BOOL transform(Photo& photo, int x, int y, Pixel& pixel);
};


#endif /* __YUV_H__ */
