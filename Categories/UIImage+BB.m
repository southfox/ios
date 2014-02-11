//
//  UIImage+BB.m
//  tripbook
//
//  Created by Javier Fuchs on 1/1/11.
//  Copyright (c) 2014 [your company name here]. All rights reserved.
//

#import "UIImage+BB.h"
#import "NSString+BB.h"

@implementation UIImage (BB)


+ (UIImage *)loadFromDisk:(NSString *)urlString;
{
    static NSString *documentPath = nil;
    if (!documentPath)
    {
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentPath = [paths objectAtIndex:0];
    }
    
    NSString *fullPath = [NSString stringWithFormat:@"%@/%@", documentPath, urlString];
    UIImage *image = [UIImage imageWithContentsOfFile:fullPath];
    BBAssert(image);
    return image;
}

+ (void)removeFromDisk:(NSString *)urlString;
{
    static NSString *documentPath = nil;
    if (!documentPath)
    {
        NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentPath = [paths objectAtIndex:0];
    }
    
    NSString *fullPath = [NSString stringWithFormat:@"%@/%@", documentPath, urlString];
    
    NSError *error = nil;
    if ([[NSFileManager defaultManager] fileExistsAtPath:fullPath])
    {
        [[NSFileManager defaultManager] removeItemAtPath:fullPath error:&error];
        if (error)
        {
            BBLog(@"error %@ removing file %@", error, fullPath);
            return;
        }
    }
}


- (void)saveToDisk:(NSString *)urlString;
{
    NSData *data = nil;
    NSString *extension = [urlString pathExtension];
    if ([extension isEqualToIgnorecase:@"png"])
    {
        data = UIImagePNGRepresentation(self);
    }
    else if ([extension isEqualToIgnorecase:@"jpg"] || [extension isEqualToIgnorecase:@"jpeg"])
    {
        data = UIImageJPEGRepresentation(self, 1.0);
    }
    else
    {
        BBAssert(NO);
    }
    if (data)
    {
        static NSString *documentPath = nil;
        if (!documentPath)
        {
            NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            documentPath = [paths objectAtIndex:0];
        }
        
        NSError *writeError = nil;
        NSString *fullPath = [NSString stringWithFormat:@"%@/%@", documentPath, urlString];
        [data writeToFile:fullPath options:NSDataWritingAtomic error:&writeError];
        BBLog(@"saving %@, error %@", urlString, writeError);
    }
}

- (UIImage *)thumbnailBySize:(CGSize)size;
{
    UIImage *originalImage = self;
    UIGraphicsBeginImageContext(size);
    [originalImage drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}





@end
