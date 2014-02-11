//
//  NSDate+BB.h
//  BB
//
//  Created by Javier Fuchs on 1/1/11.
//  Copyright (c) 2014 [your company name here]. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (BB)

- (NSString *)formattedClock;

- (NSString *)formattedDayOfTheWeek;

- (NSString *)formattedDateTime;

- (NSString *)formattedDate;

- (NSString *)formattedTime;

+ (NSDate *)dateFromJsonString:(NSString *)string;

- (NSDate *)yesterday;

// not time
- (BOOL)isBetweenDates:(NSDate *)date1 andDate:(NSDate *)date2;
- (BOOL)isBetween:(NSDate *)date1 andDate:(NSDate *)date2;
- (BOOL)isEqualToDateWithoutTime:(NSDate *)otherDate;
- (BOOL)isGreatherThanOrEqualTo:(NSDate *)date;
- (BOOL)isLessThanOrEqualTo:(NSDate *)date;
- (BOOL)isGreatherThan:(NSDate *)date;
- (BOOL)isLessThan:(NSDate *)date;

- (BOOL)hasBeenADay;
- (BOOL)isToday;
- (BOOL)isYesterday;
- (BOOL)isWeekend;

- (NSString *)rangeString:(NSDate *)otherDate;

+ (NSDate *)dateForDay:(NSUInteger)day month:(NSUInteger)month year:(NSUInteger)year;

- (NSInteger)dayOfTheWeek;
- (NSInteger)day;
- (NSInteger)monthDays;
- (NSInteger)month;
- (NSInteger)year;
- (NSString *)strMonth;

+ (NSArray *)months;

+ (NSInteger)yearStartAt;
+ (NSArray *)years;
@end
