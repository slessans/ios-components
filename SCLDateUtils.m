//
//  NSDate+SCLComponents.m
//  SCL IOS Components
//
//  Created by Scott Lessans on 9/11/13.
//  Copyright (c) 2013 Scott Lessans. All rights reserved.
//

#import "SCLDateUtils.h"

static const NSInteger DateDayCompareComponents = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit);

@implementation NSDate (SCLComponents)

+ (NSDate *) today
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents * components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                                fromDate:[NSDate date]];
    return [calendar dateFromComponents:components];
}

- (NSDate *) dateByAddingDays:(NSInteger)numberOfDays
{
    return [self dateByAddingTimeInterval:60*60*24*numberOfDays];
}

+ (NSDate *) tomorrow
{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents * components = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit
                                                fromDate:[NSDate dateWithTimeIntervalSinceNow:60.0 * 60.0 * 24.0]];
    return [calendar dateFromComponents:components];
}

- (NSDate *) dateByAddingMonths:(NSInteger)numberOfMonths
{
    NSCalendar * calendar = [NSCalendar currentCalendar];

    NSDateComponents * offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setMonth:numberOfMonths];

    return [calendar dateByAddingComponents:offsetComponents toDate:self options:0];
}

- (BOOL) isOnSameDayAsDate:(NSDate *)date
{
    NSDateComponents * selfComponents = [NSDateComponents componentsForSameDayCompareFromDate:self];
    return [selfComponents areOnSameDayAsComponentsFromDate:date];
}

- (NSString *) stringFromDefaultFormat
{
    return [NSDateFormatter localizedStringFromDate:self
                                          dateStyle:NSDateFormatterShortStyle
                                          timeStyle:NSDateFormatterNoStyle];
}

- (BOOL) isBeforeDate:(NSDate *)date
{
    return [self compare:date] == NSOrderedAscending;
}

- (BOOL) isAfterDate:(NSDate *)date
{
    return [self compare:date] == NSOrderedDescending;
}

- (BOOL) isBetweenStartDate:(NSDate*)beginDate
       startDateIsInclusive:(BOOL)startIsInclusive
                 andEndDate:(NSDate*)endDate
         endDateIsInclusive:(BOOL)endIsInclusive
{
    NSComparisonResult comparison = [self compare:beginDate];
    if ( comparison == NSOrderedAscending || (!startIsInclusive && (comparison == NSOrderedSame)) ) {
    	return NO;
    }
    
    comparison = [self compare:endDate];
    if ( comparison == NSOrderedDescending || (!endIsInclusive && (comparison == NSOrderedSame))) {
    	return NO;
    }
    
    return YES;
}

- (BOOL) isInclusiveBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    return [self isBetweenStartDate:beginDate
               startDateIsInclusive:YES
                         andEndDate:endDate
                 endDateIsInclusive:YES];
}

- (BOOL) isExclusiveBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    return [self isBetweenStartDate:beginDate
               startDateIsInclusive:NO
                         andEndDate:endDate
                 endDateIsInclusive:NO];
}

@end

@implementation NSDateComponents (MQUtils)

+ (NSDateComponents *) componentsForSameDayCompareFromDate:(NSDate *)date
{
    return [self componentsForSameDayCompareFromDate:date
                                       usingCalendar:nil];
}

// if calendar is nil, uses current calendar
+ (NSDateComponents *) componentsForSameDayCompareFromDate:(NSDate *)date usingCalendar:(NSCalendar *)calender
{
    if ( ! calender ) calender = [NSCalendar currentCalendar];
    NSDateComponents * components = [calender components:DateDayCompareComponents
                                                fromDate:date];
    return components;
}

- (BOOL) areOnSameDayAsComponentsFromDate:(NSDate *)date
{
    NSDateComponents * components = [[self class] componentsForSameDayCompareFromDate:date
                                                                        usingCalendar:self.calendar];
    return [self areOnSameDayAsComponents:components];
}

- (BOOL) areOnSameDayAsComponents:(NSDateComponents *)components
{
    return ([self year] == [components year] &&
            [self month] == [components month] &&
            [self day] == [components day] );
}

@end


@implementation NSDateFormatter (MQUtils)

+ (NSDateFormatter *) simpleWordDateFormatter
{
    NSString * format = [NSDateFormatter dateFormatFromTemplate:@"EEEE, MMM d"
                                                        options:0
                                                         locale:[NSLocale currentLocale]];
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return formatter;
}

@end


