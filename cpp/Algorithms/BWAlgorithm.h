///
/// Black and White conversion.
///
/// Created by Javier Fuchs on 1/1/11.
/// Copyright (C) 2014 Javier Fuchs. All rights reserved.
///
#ifndef __BW_H__
#define __BW_H__

/// Implement Black and White conversion.
class BWAlgorithm : public Algorithm {
protected:
private:
public:
	BWAlgorithm(Area&);
	void apply(Photo&);
	BOOL run(const Photo&);
	BOOL transform(Photo&, int x, int y, Pixel&);
};


#endif /* __BW_H__ */
