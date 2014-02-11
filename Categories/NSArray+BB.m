//
//  NSArray+BB.m
//  
//
//  Created by Javier Fuchs on 1/1/11.
//  Copyright (c) 2014 [your company name here]. All rights reserved.
//

#import "NSArray+BB.h"


@implementation NSArray (BB)


- (NSArray*)arrayIfTrue:(BOOL(^)(id object))block {
	
    int numberOfObjects = (int)[self count];
    
	NSMutableArray* array = [NSMutableArray arrayWithCapacity:numberOfObjects];

	for (id object in self)
	{
		BOOL conditionIsTrue = block(object);
		if (conditionIsTrue) {
            // add object to the array
            BBAssert(object);
			[array addObject:object];
		}
	}
	
	return array;
}

- (id)firstObject
{
    BBAssert(self.count);
    return self[0];
}

- (BOOL)isFirst:(id)object
{
    return [self firstObject] == object;
}


- (id)firstIfTrue:(BOOL(^)(id object))trueBlock {
    id anObject = nil;
	for (id object in self) {
		BOOL conditionIsTrue = trueBlock(object);
		if (conditionIsTrue) {
			anObject = object;
            break;
		}
	}
    return anObject;

}


@end



