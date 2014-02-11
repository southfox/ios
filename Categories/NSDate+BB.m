//
//  NSDate+BB.h
//  BB
//
//  Created by Javier Fuchs on 1/1/11.
//  Copyright (c) 2014 [your company name here]. All rights reserved.
//

#import "NSDate+BB.h"

#define kDateFormat @"MMM d yyyy"
#define kDayOfTheWeek @"EEEE"
#define kDateTimeFormat @"M/dd@ H:mm"
#define kJsonFormat @"yyyy-MM-dd'T'HH:mm:ssZ"
#define kClockFormat @"HH:mm"

#define kSecond   1
#define kMinute   (60 * kSecond)
#define kHour     (60 * kMinute)
#define kDay      (24 * kHour)

#define kInterval 20

@implementation NSDate (BB)

- (NSDate *)yesterday
{
    return [NSDate dateWithTimeIntervalSince1970:[self timeIntervalSince1970] - kDay];
}

- (NSString *)jsonFormat
{
    static NSDateFormatter *jsonFormatter;
    if (nil == jsonFormatter)
    {
        jsonFormatter = [[NSDateFormatter alloc] init];
        jsonFormatter.dateFormat = kJsonFormat;
    }
    
    return [jsonFormatter stringFromDate:self];
}



- (NSString *)defaultFormat
{
    static NSDateFormatter *defaultFormatter;
    if (nil == defaultFormatter)
    {
        defaultFormatter = [[NSDateFormatter alloc] init];
        defaultFormatter.dateFormat = kDateFormat;
    }

    return [defaultFormatter stringFromDate:self];
}

- (NSString *)dateTimeFormat
{
    static NSDateFormatter *dateTimeFormatter;
    if (nil == dateTimeFormatter)
    {
        dateTimeFormatter = [[NSDateFormatter alloc] init];
        dateTimeFormatter.dateFormat = kDateTimeFormat;
    }
    
    return [dateTimeFormatter stringFromDate:self];
}

- (NSString *)dayOfTheWeekTimeFormat
{
    static NSDateFormatter *formatter = nil;
    if (nil == formatter)
    {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"EEE, d MMM yyyy HH:mm:ss zzz" options:0 locale:[NSLocale currentLocale]];

    }
    return [formatter stringFromDate:self];
}

- (NSString *)formattedClock
{
    static NSDateFormatter *clockFormatter = nil;
    if (nil == clockFormatter)
    {
        clockFormatter = [[NSDateFormatter alloc] init];
        clockFormatter.dateFormat = kClockFormat;
    }
    return [clockFormatter stringFromDate:self];
}


- (NSString *)formattedDate
{
    static NSDateFormatter *formatter = nil;
    if (nil == formatter)
    {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = kDateFormat;
    }
    return [formatter stringFromDate:self];
}

- (NSString *)formattedDateTime
{
    static NSDateFormatter *formatter = nil;
    if (nil == formatter)
    {
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = kDateTimeFormat;
    }
    return [formatter stringFromDate:self];
}

- (NSString *)formattedDayOfTheWeek
{
    static NSDateFormatter *weekday = nil;
    if (nil == weekday)
    {
        
        weekday = [[NSDateFormatter alloc] init];
        [weekday setDateFormat:kDayOfTheWeek];
    }
    return [weekday stringFromDate:self];
}



- (NSString *)formattedTime
{
    NSTimeInterval elapsed = abs((int) [self timeIntervalSinceNow]);

    if (elapsed < kMinute)
    {
        return [NSString stringWithFormat:@"within %d secs", (int) (elapsed)];
    }
    else if (elapsed < 2 * kMinute)
    {
        return @"within a min";
    }
    else if (elapsed < kHour)
    {
        int minutes = (int) (elapsed / kMinute);
        return [NSString stringWithFormat:@"within %d mins", minutes];

    }
    else if (elapsed < kHour * 1.5)
    {
        return @"within an hour";
    }
    else if (elapsed < kDay)
    {
        int hours = (int) ((elapsed + kHour / 2) / kHour);
        return [NSString stringWithFormat:@"within %d hours", hours];
    }
    else
    {
        return [self formattedDate];
    }
}




- (BOOL)isToday
{
    NSDate *todayStart = nil;
    [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit
                                    startDate:&todayStart
                                     interval:NULL forDate:[NSDate date]];
    return ([self timeIntervalSince1970] >= [todayStart timeIntervalSince1970]);
}

- (BOOL)isYesterday
{
    NSDate *todayStart = nil;
    [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit
                                    startDate:&todayStart
                                     interval:NULL forDate:[NSDate date]];
    return ([self timeIntervalSince1970] <= ([todayStart timeIntervalSince1970]));
}

- (BOOL)isTomorrow
{
    NSDate *todayStart = nil;
    [[NSCalendar currentCalendar] rangeOfUnit:NSDayCalendarUnit
                                    startDate:&todayStart
                                     interval:NULL forDate:[NSDate date]];
    return ([self timeIntervalSince1970] >= ([todayStart timeIntervalSince1970] + kDay));
}


- (BOOL)isThisWeek
{
    NSDate *beginningOfWeek = nil;
    NSCalendar *cal = [NSCalendar currentCalendar];
    [cal rangeOfUnit:NSWeekCalendarUnit startDate:&beginningOfWeek
            interval:NULL forDate:[NSDate date]];
    return ([beginningOfWeek compare:self] == NSOrderedAscending);

}


- (BOOL)isWeekend;
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components = [cal components:( NSCalendarUnitWeekday ) fromDate:self];
    return (components.weekday == 1 || components.weekday == 7);
}


+ (NSDate *)dateFromJsonString:(NSString *)string
{
    BBAssert(string && [string length] && [string isKindOfClass:[NSString class]])
    ;
    static NSDateFormatter *jsonFormatter;
    if (nil == jsonFormatter)
    {
        jsonFormatter = [[NSDateFormatter alloc] init];
        jsonFormatter.dateFormat = kJsonFormat;
    }
    NSString *dateString = [string stringByReplacingOccurrencesOfString:@"Z" withString:@"+0000"];
    __unused NSDate *date = [jsonFormatter dateFromString:dateString];
    BBAssert(date && [date isKindOfClass:[NSDate class]])
    
    return [jsonFormatter dateFromString:dateString];
}

// not time
- (BOOL)isBetweenDates:(NSDate *)date1 andDate:(NSDate *)date2
{
    NSDate *selfDateOnly = [NSDate dateForDay:[self day] month:[self month] year:[self year]];
    NSDate *dateOnly1 = [NSDate dateForDay:[date1 day] month:[date1 month] year:[date1 year]];
    NSDate *dateOnly2 = [NSDate dateForDay:[date2 day] month:[date2 month] year:[date2 year]];
    return [selfDateOnly isGreatherThanOrEqualTo:dateOnly1] && [selfDateOnly isLessThanOrEqualTo:dateOnly2];
}

- (BOOL)isBetween:(NSDate *)date1 andDate:(NSDate *)date2
{
    return [self isGreatherThanOrEqualTo:date1] && [self isLessThanOrEqualTo:date2];
}

- (BOOL)isEqualToDateWithoutTime:(NSDate *)otherDate
{
    return ([self day] == [otherDate day] && [self month] == [otherDate month] && [self year] == [otherDate year]);
}

- (BOOL)isGreatherThanOrEqualTo:(NSDate *)date
{
    return !([self compare:date] == NSOrderedAscending) ? YES : NO;
}

- (BOOL)isLessThanOrEqualTo:(NSDate *)date
{
    return !([self compare:date] == NSOrderedDescending) ? YES : NO;
}

- (BOOL)isGreatherThan:(NSDate *)date
{
    return ([self compare:date] == NSOrderedDescending) ? YES : NO;
    
}

- (BOOL)isLessThan:(NSDate *)date
{
    return ([self compare:date] == NSOrderedAscending) ? YES : NO;
}

- (BOOL)hasBeenADay
{
    return [self timeIntervalSinceNow] <= kDay ? YES : NO;
}


- (NSString *)rangeString:(NSDate *)otherDate;
{
    static NSDateFormatter *monthDayFormatter;
    if (nil == monthDayFormatter)
    {
        monthDayFormatter = [[NSDateFormatter alloc] init];
        monthDayFormatter.dateFormat = @"MMM d";
    }

    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *selfComponents = [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    
    NSDateComponents *otherComponents = [cal components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:otherDate];
    
    NSMutableString *result = [NSMutableString string];

    // TODO
    NSDate *currentDate = [NSDate date];
    NSDateComponents *currentComponents = [cal components:(NSCalendarUnitYear) fromDate:currentDate];

    if (selfComponents.year == otherComponents.year)
    {
        
        // @"Oct 6";
        [result appendString:[[monthDayFormatter stringFromDate:self] capitalizedStringWithLocale:[NSLocale localeWithLocaleIdentifier:@"en-US"]]];
        if (selfComponents.month == otherComponents.month)
        {

            if (selfComponents.day != otherComponents.day)
            {
                // @"Oct 6-14";
                [result appendFormat:@"-%ld", (long)otherComponents.day];
            }
        }
        else
        {
            // @"Oct 29 - Nov 14";
            [result appendFormat:@" - %@", [[monthDayFormatter stringFromDate:otherDate] capitalizedStringWithLocale:[NSLocale localeWithLocaleIdentifier:@"en-US"]]];
        }
        
        // @"Oct 6 2012
        if (selfComponents.year != currentComponents.year)
        {
            [result appendFormat:@" %d", (int)selfComponents.year];
        }
    }
    else
    {
        // @"Dec 29 2009 - Jan 14 2010"
        [result appendFormat:@"%@ - %@", [self defaultFormat], [otherDate defaultFormat]];
    }
    
    return result;
}

+ (NSDate *)dateForDay:(NSUInteger)day month:(NSUInteger)month year:(NSUInteger)year;
{
    
    static NSDateComponents *comps;
    if (nil == comps)
    {
        comps = [[NSDateComponents alloc] init];
    }
    
    [comps setDay:day];
    [comps setMonth:month];
    [comps setYear:year];
    [comps setHour:0];
    [comps setMinute:0];
    [comps setSecond:0];
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:comps];
    BBAssert(date && [date isKindOfClass:[NSDate class]])
    return date;
}

- (NSInteger)dayOfTheWeek;
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *selfComponents = [cal components:(NSCalendarUnitWeekday) fromDate:self];
    return selfComponents.weekday;
}

- (NSInteger)day;
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *selfComponents = [cal components:(NSCalendarUnitDay) fromDate:self];
    return selfComponents.day;
}

- (NSInteger)monthDays;
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *selfComponents = [cal components:(NSCalendarUnitDay | NSCalendarUnitMonth) fromDate:self];
    [selfComponents setMonth:selfComponents.month + 1];
    [selfComponents setDay:-1];
    return selfComponents.day;
}

- (NSInteger)month;
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *selfComponents = [cal components:(NSCalendarUnitMonth) fromDate:self];
    return selfComponents.month;
}

- (NSInteger)year;
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *selfComponents = [cal components:(NSCalendarUnitYear) fromDate:self];
    return selfComponents.year;
}


- (NSString *)strMonth;
{
    static NSDateFormatter *strMonthFormatter;
    if (nil == strMonthFormatter)
    {
        strMonthFormatter = [[NSDateFormatter alloc] init];
        strMonthFormatter.dateFormat = @"MMMM";
    }
    
    return [[strMonthFormatter stringFromDate:self] capitalizedStringWithLocale:[NSLocale localeWithLocaleIdentifier:@"en-US"]];

}

+ (NSInteger)yearStartAt
{
    return [[NSDate date] year] - kInterval;
}

+ (NSInteger)yearEndAt
{
    return [[NSDate date] year] + kInterval;
}

+ (NSArray *)years;
{
    static NSMutableArray *years = nil;
    if (nil == years)
    {
        years = [NSMutableArray array];
        for (int y = (int)[NSDate yearStartAt]; y < (int)[NSDate yearEndAt]; y++) {
            [years addObject:[NSString stringWithFormat:@"%d", y]];
        }
    }
    return years;
}


+ (NSArray *)months;
{
    static NSMutableArray *months = nil;
    if (nil == months)
    {
        months = [NSMutableArray array];
        for (int m = 1; m <= 12; m++)
        {
            NSDate *date = [NSDate dateForDay:1 month:m year:[[NSDate date] year]];
            [months addObject:[date strMonth]];
        }
    }
    return months;
}


@end
