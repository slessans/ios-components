//
//  SCLValidation.h
//  SCL IOS Components
//
//  Created by Scott Lessans on 8/24/13.
//  Copyright (c) 2013 Scott Lessans. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SCLValidation : NSObject

// options should have keys from above
+ (BOOL) validateString:(NSString *)string
              minLength:(NSNumber *)minLength
              maxLength:(NSNumber *)maxLength
               canBeNil:(BOOL)canBeNil;

+ (BOOL) isValidEmail:(NSString *)emailString;

+ (BOOL) isValidPhoneNumber:(NSString *)phoneString;

@end

