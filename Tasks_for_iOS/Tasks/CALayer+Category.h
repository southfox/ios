//
//  CALayer+Category.h
//  Tasks
//
//  Created by Javier Fuchs on 5/16/13.
//  Copyright (c) 2013 Hungry And Foolish. All rights reserved.
//


#import <QuartzCore/QuartzCore.h>

@interface CALayer (Category)

- (void)rotate:(CGFloat)duration;
- (void)rotateAroundPoint:(CGPoint)rotationPoint duration:(NSTimeInterval)duration;
- (void)resize:(CGSize)size duration:(CGFloat)duration;
- (void)move:(CGPoint)position duration:(CGFloat)duration;
- (void)moveUsingPath:(CGPoint*)positionPath steps:(NSInteger)steps duration:(CGFloat)duration;
- (UIImage*)captureImage;

@end
