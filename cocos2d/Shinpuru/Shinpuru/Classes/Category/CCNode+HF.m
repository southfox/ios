//
//  CCNode+HF.m
//  
//
//  Created by Javier Fuchs on 1/1/11.
//  Copyright (c) 2014 Hungry and Foolish. All rights reserved.
//

#import "CCNode+HF.h"


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

- (CGPoint)c;
{
    return (CGPoint){self.x + self.s.width/2, self.o.y + self.s.height/2};
}

- (void)setC:(CGPoint)c;
{
    self.o = (CGPoint){self.x + self.s.width/2, self.o.y + self.s.height/2};
}

- (CGRect)r;
{
    return (CGRect){self.c, self.s};
}

- (CGRect)b;
{
    return (CGRect){CGPointZero, self.s};
}

- (BOOL)contains:(CGPoint)p;
{
    return CGRectContainsPoint(self.r, p);
}



@end
