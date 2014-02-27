//
//  UIView+HF.m
//  
//
//  Created by Javier Fuchs on 1/1/11.
//  Copyright (c) 2014 Hungry and Foolish. All rights reserved.
//

#import "UIView+HF.h"

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

static const NSInteger kUIViewHFContainerTag = 271828;
static const NSInteger kUIViewHFMessageTag = 111;
static const NSInteger kUIViewHFSpinnerTag = 222;
static const CGRect kUIViewHFMessageFrame = {20.0, 0.0, 200, 100};
static const CGSize kUIViewHFContainerSize = {240.0, 124};
static const CGRect kUIViewHFSpinnerFrame = {100.0, 76.0, 40.0, 40.0};

@implementation UIView (HF)

- (CGPoint)o
{
    return self.frame.origin;
}

- (void)setO:(CGPoint)o
{
    CGRect frame = self.frame;
    frame.origin = o;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void) setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


- (CGSize)s
{
    return self.frame.size;
}

- (void)setS:(CGSize)s
{
    CGRect frame = self.frame;
    frame.size = s;
    self.frame = frame;
}

- (CGFloat)w
{
    return self.frame.size.width;
}

- (void) setW:(CGFloat)w
{
    CGRect frame = self.frame;
    frame.size.width = w;
    self.frame = frame;
}

- (CGFloat)h
{
    return self.frame.size.height;
}

- (void) setH:(CGFloat)h
{
    CGRect frame = self.frame;
    frame.size.height = h;
    self.frame = frame;
}


- (void)updateSpinnerWithString:(NSString *)string tag:(NSInteger)tag
{
    UIView *subView = [self viewWithTag:kUIViewHFContainerTag + tag];
    
    if (subView)
    {
        UILabel *textLabel = (UILabel *) [subView viewWithTag:kUIViewHFMessageTag];
        textLabel.text = string;
    }
}


- (void)stopSpinnerWithString:(NSString *)string tag:(NSInteger)tag
{
    self.userInteractionEnabled = YES;
    UIView *subView = [self viewWithTag:kUIViewHFContainerTag + tag];

    if (subView)
    {
        UIActivityIndicatorView *spinner = (UIActivityIndicatorView *) [subView viewWithTag:kUIViewHFSpinnerTag];
        [spinner stopAnimating];

        UILabel *textLabel = (UILabel *) [subView viewWithTag:kUIViewHFMessageTag];
        textLabel.text = string;
    }

    [NSTimer scheduledTimerWithTimeInterval:2.5 target:subView selector:@selector(removeFromSuperview) userInfo:nil repeats:NO];
}


- (void)stopSpinner:(NSInteger)tag
{
    self.userInteractionEnabled = YES;
    [[self viewWithTag:kUIViewHFContainerTag+tag] removeFromSuperview];
}


- (void)startSpinnerWithString:(NSString *)string tag:(NSInteger)tag
{
    [self stopSpinner:tag];

    self.userInteractionEnabled = NO;

    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, kUIViewHFContainerSize.width, kUIViewHFContainerSize.height)];
    containerView.x = self.w/2 - containerView.w/2;
    containerView.y = self.h/2 - containerView.h/2;
    [containerView makeRoundingCorners:6.0];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    containerView.tag = kUIViewHFContainerTag + tag;
    containerView.backgroundColor = [UIColor darkGrayColor];

    if (string)
    {
        UILabel *textLabel = [[UILabel alloc] initWithFrame:kUIViewHFMessageFrame];
        textLabel.tag = kUIViewHFMessageTag;
        textLabel.text = string;
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor = [UIColor whiteColor];
        textLabel.font = [UIFont boldSystemFontOfSize:18.0];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.adjustsFontSizeToFitWidth = YES;
        textLabel.minimumScaleFactor = 0.5;
        textLabel.numberOfLines = 2;
        [containerView addSubview:textLabel];
    }
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.frame = kUIViewHFSpinnerFrame;
    [spinner startAnimating];
    spinner.tag = kUIViewHFSpinnerTag;

    [containerView addSubview:spinner];
    [self addSubview:containerView];
}

- (void)makeRoundingCorners:(UIRectCorner)corners corner:(CGFloat)corner
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(corner, corner)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)makeRoundingCorners:(CGFloat)corner
{
    self.layer.cornerRadius = corner;
    self.layer.masksToBounds = YES;
}


- (UIImage *)capture
{
	UIGraphicsBeginImageContext(self.frame.size);

	[self.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

    return image;
}


@end
