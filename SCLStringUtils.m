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
    // NSMutableString only has appendString, but to avoid
    // creating a string object for each character, we'll use
    // a buffer instead
    const NSUInteger length = [self length];
    
    if (length == 0) {
        return [[NSString alloc] init];
    }
    
    unichar * characters = malloc(sizeof(unichar) * length);
    NSUInteger charactersSize = 0;
    
    for(NSUInteger i = 0; i < length; i++) {
        unichar c = [self characterAtIndex:i];
        
        if (![characterSet characterIsMember:c]) {
            characters[charactersSize] = c;
            charactersSize++;
        }
    }
    
    if ( charactersSize == 0 ) {
        free(characters);
        return [[NSString alloc] init];
    }
    
    NSString * output = [[NSString alloc] initWithCharactersNoCopy:characters
                                                            length:charactersSize
                                                      freeWhenDone:YES];
    if (!output) {
        // as per docs: If an error occurs during the creation of the string,
        // then bytes is not freed even if flag is YES
        free(characters);
    }
    
    return output;
}

@end
