//
//  SCLComparisonUtils.h
//  SCL IOS Components
//
//  Created by Scott Lessans on 9/2/13.
//  Copyright (c) 2013 Scott Lessans. All rights reserved.
//

#import <Foundation/Foundation.h>

// compares two doubles
extern const NSComparisonResult (^SCLDoubleCompare)(double, double);

// compares two dates up to day-level granularity -- ie if two dates correspond
// to the same day, they are equal.
extern const NSComparisonResult (^SCLDayBasedDateCompare)(NSDate *, NSDate *);
