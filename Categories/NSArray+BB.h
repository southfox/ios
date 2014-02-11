//
//  NSArray+BB.h
//  
//
//  Created by Javier Fuchs on 1/1/11.
//  Copyright (c) 2014 [your company name here]. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (BB)

- (NSArray*)arrayIfTrue:(BOOL(^)(id object))block;
- (id)firstObject;
- (BOOL)isFirst:(id)object;
- (id)firstIfTrue:(BOOL(^)(id object))trueBlock;

@end

