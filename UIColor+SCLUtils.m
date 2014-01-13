//
//  UIColor+SCLUtils.m
//  Schedule Guru
//
//  Created by Scott Lessans on 1/13/14.
//  Copyright (c) 2014 Scott Lessans. All rights reserved.
//

#import "UIColor+SCLUtils.h"

@implementation UIColor (SCLUtils)

+ (instancetype) scl_colorWithHex:(NSUInteger)hex
{
    return [self scl_colorWithHex:hex alpha:1.0f];
}

+ (instancetype) scl_colorWithHex:(NSUInteger)hex alpha:(CGFloat)alpha
{
    return [UIColor scl_colorWithRedInteger:(hex >> 16) & 0xFF
                               greenInteger:(hex >> 8) & 0xFF
                                blueInteger:(hex >> 0) & 0xFF
                                      alpha:alpha];
}

+ (instancetype) scl_colorWithRedInteger:(NSInteger)red
                            greenInteger:(NSInteger)green
                             blueInteger:(NSInteger)blue
                                   alpha:(CGFloat)alpha
{
    return [[UIColor alloc] initWithRed:(red / 255.0f)
                                  green:(green / 255.0f)
                                   blue:(blue / 255.0f)
                                  alpha:alpha];
}

@end
