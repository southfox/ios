//
//  CALayer+Category.m
//  Tasks
//
//  Created by Javier Fuchs on 5/16/13.
//  Copyright (c) 2013 Hungry And Foolish. All rights reserved.
//

#import "CALayer+Category.h"
#import <QuartzCore/QuartzCore.h>

@implementation CALayer (Category)

- (void)dealloc
{
    [self removeAllAnimations];
    [super dealloc];
}


- (void)rotate:(CGFloat)duration
{
    CATransform3D rotationTransform = CATransform3DMakeRotation(M_PI/2, 0.0f, 0.0f, 1.0f);
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    rotationAnimation.toValue = [NSValue valueWithCATransform3D:rotationTransform];
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    [rotationAnimation setDuration:duration];
    NSString* key = [NSString stringWithFormat:@"rotationAnimation %@ %@", [NSDate date], self];
    [self addAnimation:rotationAnimation forKey:key];
}

- (void)rotateAroundPoint:(CGPoint)rotationPoint duration:(NSTimeInterval)duration
{
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    [rotationAnimation setDuration:duration];
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VAL;
    
    CGPoint anchorPoint = CGPointMake((rotationPoint.x - CGRectGetMinX(self.frame))/CGRectGetWidth(self.bounds),
                                      (rotationPoint.y - CGRectGetMinY(self.frame))/CGRectGetHeight(self.bounds));
    
    [self setAnchorPoint:anchorPoint];
    [self setPosition:rotationPoint]; 
    
    CATransform3D rotationTransform1 = CATransform3DMakeRotation(M_PI/2, 0, 0, 1);
    
    [rotationAnimation setToValue:[NSValue valueWithCATransform3D:rotationTransform1]];
    
    NSString* key = [NSString stringWithFormat:@"rotateAroundAnchorPoint %@ %@", [NSDate date], self];
    [self addAnimation:rotationAnimation forKey:key];
}


- (void)resize:(CGSize)size duration:(CGFloat)duration
{
    CGRect bounds = self.bounds;
    bounds.size = size;
    CABasicAnimation* resizeAnimation = [CABasicAnimation animationWithKeyPath:@"bounds"];
    
    resizeAnimation.duration = duration;
    resizeAnimation.removedOnCompletion = NO;
    resizeAnimation.cumulative = YES;
    resizeAnimation.repeatCount = HUGE_VAL;
    
    resizeAnimation.fromValue = [NSValue valueWithCGRect:self.bounds];
    resizeAnimation.toValue = [NSValue valueWithCGRect:bounds];

    resizeAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    NSString* key = [NSString stringWithFormat:@"resizeAnimation %@ %@", [NSDate date], self];
    [self addAnimation:resizeAnimation forKey:key];
    self.bounds = bounds;
}

- (void)move:(CGPoint)position duration:(CGFloat)duration
{
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];

    moveAnimation.duration = duration;
    
    moveAnimation.removedOnCompletion = NO;

    moveAnimation.fromValue = [self valueForKey:@"position"];
    moveAnimation.toValue = [NSValue valueWithCGPoint:position];

    moveAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    NSString* key = [NSString stringWithFormat:@"moveAnimation %@ %@", [NSDate date], self];
    [self addAnimation:moveAnimation forKey:key];
    self.position = position;
}

- (void)moveUsingPath:(CGPoint*)positionPath steps:(NSInteger)steps duration:(CGFloat)duration
{
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddLines(path, NULL, positionPath, steps);
    CGPathCloseSubpath(path);
    
    CAKeyframeAnimation* movePathAnimation = [CAKeyframeAnimation animation];
    movePathAnimation.path = path;
    movePathAnimation.duration = duration;
    movePathAnimation.repeatCount = HUGE_VAL;
    movePathAnimation.calculationMode = kCAAnimationPaced;
    movePathAnimation.removedOnCompletion = NO;
    
    [self addAnimation:movePathAnimation forKey:@"position"];
    CGPathRelease(path);
}




- (UIImage*)captureImage
{
	UIGraphicsBeginImageContext(self.frame.size);
    
	[self renderInContext:UIGraphicsGetCurrentContext()];
	
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	
    UIGraphicsEndImageContext();
    
    return image;
}


@end
