//
//  UIColor+SCLUtils.m
//  Schedule Guru
//
//  Created by Scott Lessans on 1/13/14.
//  Copyright (c) 2014 Scott Lessans. All rights reserved.
//

#import "UIColor+SCLUtils.h"

#define SCL_COLOR_WITH_INTEGERS(RED, GREEN, BLUE, ALPHA) \
    [[UIColor alloc] initWithRed:(RED / 255.0f) \
                           green:(GREEN / 255.0f) \
                            blue:(BLUE / 255.0f) \
                           alpha:ALPHA];

@implementation UIColor (SCLUtils)

+ (instancetype) scl_colorWithHex:(NSUInteger)hex
{
    return [self scl_colorWithHex:hex alpha:1.0f];
}

+ (instancetype) scl_colorWithHex:(NSUInteger)hex alpha:(CGFloat)alpha
{
    return SCL_COLOR_WITH_INTEGERS(((hex >> 16) & 0xFF),
                                   ((hex >> 8) & 0xFF),
                                   ((hex >> 0) & 0xFF),
                                   alpha);
}

+ (instancetype) scl_colorWithRedInteger:(NSInteger)red
                            greenInteger:(NSInteger)green
                             blueInteger:(NSInteger)blue
                                   alpha:(CGFloat)alpha
{

    return SCL_COLOR_WITH_INTEGERS(red, green, blue, alpha);
}

@end
