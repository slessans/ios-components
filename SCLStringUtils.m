//
//  SCLStringUtils.m
//  Schedule Me
//
//  Created by Scott Lessans on 12/16/13.
//  Copyright (c) 2013 Scott Lessans. All rights reserved.
//

#import "SCLStringUtils.h"

@implementation NSString (SCLStringUtils)

- (NSString *) scl_stringByRemovingCharacterInSet:(NSCharacterSet *)characterSet
{
    const NSUInteger length = [self length];
    NSMutableString * string = [[NSMutableString alloc] init];
    
    for(NSUInteger i = 0; i < length; i++) {
        unichar c = [self characterAtIndex:i];
        
        if (![characterSet characterIsMember:c]) {
            [string appendFormat:@"%C", c];
        }
    }
    
    return string;
}

@end
