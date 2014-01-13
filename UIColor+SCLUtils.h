//
//  UIColor+SCLUtils.h
//  Schedule Guru
//
//  Created by Scott Lessans on 1/13/14.
//  Copyright (c) 2014 Scott Lessans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (SCLUtils)

/**
 * Calls scl_colorWithHex:alpha: with alpha = 1.0f. See docs for
 * colorWithHex:alpha for more information.
 *
 * @param hex
 * @returns
 */
+ (instancetype) scl_colorWithHex:(NSUInteger)hex;

/**
 * Returns a UIColor object instantiated with the RGB values specified
 * by the input hex. The alpha may be specified by the alpha param which
 * is a float between 0 and 1.
 *
 * @param hex the hex RGB value only the last 6 hex digits are used
 * @param alpha the alpha value between 0 and 1
 * @returns a newly initialized color object
 */
+ (instancetype) scl_colorWithHex:(NSUInteger)hex alpha:(CGFloat)alpha;


/**
 * Created a new color object based on RGB values between 0 and 255.
 * Alpha value is float between 0 and 1.
 *
 * @param red red component (between 0 and 255)
 * @param green green component (between 0 and 255)
 * @param blue blue component (between 0 and 255)
 * @returns a newly initialized color object
 */
+ (instancetype) scl_colorWithRedInteger:(NSInteger)red
                            greenInteger:(NSInteger)green
                             blueInteger:(NSInteger)blue
                                   alpha:(CGFloat)alpha;

@end
