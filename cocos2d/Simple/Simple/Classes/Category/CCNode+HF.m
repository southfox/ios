//
//  CCNode+HF.m
//  
//
//  Created by Javier Fuchs on 1/1/11.
//  Copyright (c) 2014 Hungry and Foolish. All rights reserved.
//

#import "CCNode+HF.h"


/** Helper macro that creates a CGRect
 @return CGRect
 */
static inline CGRect ccr( CGPoint o, CGSize s )
{
	return CGRectMake(o.x - s.width/2, o.y - s.height/2, s.width, s.height);
}

@implementation CCNode (HF)


- (CGPoint)o;
{
    return self.position;
}

- (void)setO:(CGPoint)o;
{
    self.position = o;
}

- (CGFloat)x;
{
    return self.position.x;
}

- (void)setX:(CGFloat)x;
{
    self.position = ccp(x, self.position.y);
}


- (CGFloat)y;
{
    return self.position.y;
}

- (void)setY:(CGFloat)y;
{
    self.position = ccp(self.position.x, y);

}

- (CGSize)s;
{
    return self.contentSize;
}

- (void)setS:(CGSize)s;
{
    self.contentSize = s;
}

- (CGFloat)w;
{
    return self.contentSize.width;
}

- (void)setW:(CGFloat)w;
{
    self.contentSize = CGSizeMake(w, self.contentSize.height);
}

- (CGFloat)h;
{
    return self.contentSize.height;
}

- (void)setH:(CGFloat)h;
{
    self.contentSize = CGSizeMake(self.contentSize.width, h);
}

- (CGRect)r;
{
    return ccr(self.o, self.s);
}

- (BOOL)contains:(CGPoint)p;
{
    return CGRectContainsPoint(self.r, p);
}



@end
