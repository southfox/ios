//
//  UIImage+BB.h
//  tripbook
//
//  Created by Javier Fuchs on 1/1/11.
//  Copyright (c) 2014 [your company name here]. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BB)

+ (UIImage *)loadFromDisk:(NSString *)urlString;
+ (void)removeFromDisk:(NSString *)urlString;
- (void)saveToDisk:(NSString *)urlString;
- (UIImage *)thumbnailBySize:(CGSize)size;



@end
