///
/// Histogram equalisation.
/// http://en.wikipedia.org/wiki/Histogram_equalisation
///
/// Created by Javier Fuchs on 1/1/11.
/// Copyright (C) 2014 Javier Fuchs. All rights reserved.
///
#ifndef __HISTOGRAMEQUALISATION_H__
#define __HISTOGRAMEQUALISATION_H__

/// HistogramEqualisation an image.
class HistogramEqualisation : public Algorithm {
protected:
	std::vector<int> pdf;
	std::vector<int> cdf;
private:
public:
	HistogramEqualisation(Area& area);
	void apply(Photo& photo);
	BOOL run(const Photo& photo);
	BOOL run(const Photo& photo, CGRect& area);
	BOOL transform(Photo& photo, int x, int y, Pixel& pixel);
};


#endif /* __HISTOGRAMEQUALISATION_H__ */
