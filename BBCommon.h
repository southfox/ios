//
//  BBCommon.h
//  BB
//
//  Created by Javier Fuchs on 2/4/14.
//  Copyright (c) 2014 [your company here]. All rights reserved.
//

#ifndef BB_Common_h
#define BB_Common_h

// device screen type

#define DEVICE_IS_IPAD                              ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

#define DEVICE_IS_IPAD_HD                           (DEVICE_IS_IPAD && ([[UIScreen mainScreen] scale] == 2.0))


#define IOS_7    ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7)


#ifdef DEBUG
#define BBLog(__xx, ...)  NSLog(@"%s(%d): " __xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define BBLog(__xx, ...)  {}
#endif


#ifdef DEBUG
#define BBAssert(condition) {if(!(condition)) BBLog("%@", @"BB assert\n"); assert(condition); };
#else
#define BBAssert(condition) {};
#endif



#endif
