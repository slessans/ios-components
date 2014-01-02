//
//  SCLValidation.m
//  SCL IOS Components
//
//  Created by Scott Lessans on 8/24/13.
//  Copyright (c) 2013 Scott Lessans. All rights reserved.
//

#import "SCLValidation.h"
#import "SCLStringUtils.h"

static NSString * const EmailRegex =
@"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
@"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
@"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
@"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
@"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
@"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
@"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";

static NSArray * PhoneRegexes = nil;

@interface SCLValidation ()

@end

@implementation SCLValidation

+ (void) initialize
{
    if (self != [SCLValidation class]) {
        return;
    }
    
    PhoneRegexes =
  @[
    @"^[0-9]{10}$",
    @"^[0-9]{3}\\s*(-\\s*)?[0-9]{3}\\s*(-\\s*)?[0-9]{4}$",
    @"^\\([0-9]{3}\\)\\s*[0-9]{3}\\s*(-\\s*)?[0-9]{4}$"
    ];
}

+ (BOOL) validateString:(NSString *)string
              minLength:(NSNumber *)minLength
              maxLength:(NSNumber *)maxLength
               canBeNil:(BOOL)canBeNil
{
    if ( ! string ) {
        return canBeNil;
    }
    
    const NSUInteger strLen = [string length];
    
    if ( minLength && strLen < [minLength unsignedIntegerValue] ) {
        return NO;
    }
    
    if ( maxLength && strLen > [maxLength unsignedIntegerValue] ) {
        return NO;
    }
    
    return YES;
}

+ (BOOL) isValidEmail:(NSString *)emailString
{
    NSPredicate * emailFormatPredicate = [NSPredicate predicateWithFormat:
                                          @"SELF MATCHES %@",
                                          EmailRegex];
    return [emailFormatPredicate evaluateWithObject:emailString];
}

+ (BOOL) isValidPhoneNumber:(NSString *)phoneString
{
    return [self isValidPhoneNumber:phoneString santizedNumber:nil];
}

+ (BOOL) isValidPhoneNumber:(NSString *)phoneString santizedNumber:(NSString **)sanitizedNumberOut
{
    BOOL found = NO;
    
    for(NSString * phoneRegex in PhoneRegexes) {
        NSPredicate * phoneFormatPredicate = [NSPredicate predicateWithFormat:
                                              @"SELF MATCHES %@", phoneRegex];
        if ([phoneFormatPredicate evaluateWithObject:phoneString]) {
            found = YES;
            break;
        }
    }
    
    if (found && sanitizedNumberOut) {
        NSMutableCharacterSet * set = [NSMutableCharacterSet decimalDigitCharacterSet];
        [set invert];
        *sanitizedNumberOut = [phoneString scl_stringByRemovingCharactersInSet:set];
    }
    
    return found;
}

@end


