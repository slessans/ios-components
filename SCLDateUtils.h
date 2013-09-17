//
//  NSDate+SCLComponents.h
//  SCL IOS Components
//
//  Created by Scott Lessans on 9/11/13.
//  Copyright (c) 2013 Scott Lessans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (SCLComponents)

+ (NSDate *) today;
+ (NSDate *) tomorrow;

- (NSString *) stringFromDefaultFormat;

- (BOOL) isOnSameDayAsDate:(NSDate *)date;

- (BOOL) isBeforeDate:(NSDate *)date;

- (BOOL) isAfterDate:(NSDate *)date;

- (BOOL) isBetweenStartDate:(NSDate*)beginDate
       startDateIsInclusive:(BOOL)startIsInclusive
                 andEndDate:(NSDate*)endDate
         endDateIsInclusive:(BOOL)endIsInclusive;

- (BOOL) isInclusiveBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate;

- (BOOL) isExclusiveBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate;


@end


@interface NSDateFormatter (MQUtils)

+ (NSDateFormatter *) simpleWordDateFormatter;

@end


@interface NSDateComponents (MQUtils)

// very specific use case -- when doin a lot of same day testing where one of the
// dates is the same, it can be helpful to extract the date components from the constant
// date object so you don't have to re extract every time. this should give a slight
// performance increase.
+ (NSDateComponents *) componentsForSameDayCompareFromDate:(NSDate *)date;

// if calendar is nil, uses current calendar
+ (NSDateComponents *) componentsForSameDayCompareFromDate:(NSDate *)date usingCalendar:(NSCalendar *)calender;

- (BOOL) areOnSameDayAsComponentsFromDate:(NSDate *)date;
- (BOOL) areOnSameDayAsComponents:(NSDateComponents *)components;

@end