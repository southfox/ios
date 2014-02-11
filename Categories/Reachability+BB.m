//
//  Reachability+BB.m
//  
//
//  Created by Javier Fuchs on 1/1/11.
//  Copyright (c) 2014 [your company name here]. All rights reserved.
//

#import "Reachability+BB.h"
#import "Reachability.h"

@implementation Reachability (BB)

+ (BOOL)isNetworkAvailable
{
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}

@end
