//
//  CCNode+HF.h
//  
//
//  Created by Javier Fuchs on 1/1/11.
//  Copyright (c) 2014 Hungry and Foolish. All rights reserved.
//

#import "cocos2d.h"

@interface CCNode (HF)

@property (nonatomic) CGPoint o;
@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGSize s;
@property (nonatomic) CGFloat w;
@property (nonatomic) CGFloat h;
@property (nonatomic) CGPoint c;

- (CGRect)r; // rect
- (CGRect)b; // bounds
- (BOOL)contains:(CGPoint)p;

@end
