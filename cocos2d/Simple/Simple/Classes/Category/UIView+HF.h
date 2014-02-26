//
//  UIView+HF.h
//  
//
//  Created by Javier Fuchs on 1/1/11.
//  Copyright (c) 2014 Hungry and Foolish. All rights reserved.
//

@interface UIView (HF)

@property (nonatomic) CGPoint o;
@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGSize s;
@property (nonatomic) CGFloat w;
@property (nonatomic) CGFloat h;

- (void)updateSpinnerWithString:(NSString *)string tag:(NSInteger)tag;

- (void)stopSpinnerWithString:(NSString *)string tag:(NSInteger)tag;

- (void)stopSpinner:(NSInteger)tag;

- (void)startSpinnerWithString:(NSString *)string tag:(NSInteger)tag;

- (void)makeRoundingCorners:(UIRectCorner)corners corner:(CGFloat)corner;

- (void)makeRoundingCorners:(CGFloat)corner;

- (UIImage *)capture;

@end
