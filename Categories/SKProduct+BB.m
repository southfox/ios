//
//  SKProduct+BB.m
//  tripbook
//
//  Created by Javier Fuchs on 1/1/11.
//  Copyright (c) 2014 [your company name here]. All rights reserved.
//

#import "SKProduct+BB.h"

@implementation SKProduct (BB)

- (NSString *)localizedPrice
{
    static NSNumberFormatter *numberFormatter = nil;
    if (nil == numberFormatter)
    {
        numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    }
    [numberFormatter setLocale:self.priceLocale];
    NSString *formattedString = [numberFormatter stringFromNumber:self.price];
    return formattedString;
}

@end

