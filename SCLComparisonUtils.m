//
//  SCLComparisonUtils.m
//  SCL IOS Components
//
//  Created by Scott Lessans on 9/2/13.
//  Copyright (c) 2013 Scott Lessans. All rights reserved.
//

#import "SCLComparisonUtils.h"

static const NSInteger SameDayDateComponents = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;

const NSComparisonResult (^SCLDoubleCompare)(double, double) = ^(double int1, double int2){
    if ( int1 < int2 ) return NSOrderedAscending;
    if ( int1 > int2 ) return NSOrderedDescending;
    return NSOrderedSame;
};

const NSComparisonResult (^SCLDayBasedDateCompare)(NSDate *, NSDate *) = ^(NSDate * date1, NSDate * date2){
    
    NSCalendar * currentCalendar = [NSCalendar currentCalendar];
    
    NSDateComponents * components1 = [currentCalendar components:SameDayDateComponents fromDate:date1];
    NSDateComponents * components2 = [currentCalendar components:SameDayDateComponents fromDate:date2];
    
    NSComparisonResult result = SCLDoubleCompare([components1 year], [components2 year]);
    if ( result == NSOrderedSame ) result = SCLDoubleCompare([components1 month], [components2 month]);
    if ( result == NSOrderedSame ) result = SCLDoubleCompare([components1 day], [components2 day]);
    
    return result;
};
