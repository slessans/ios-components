//
//  SCLStringUtils.h
//  Schedule Me
//
//  Created by Scott Lessans on 12/16/13.
//  Copyright (c) 2013 Scott Lessans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SCLStringUtils)

- (NSString *) scl_stringByRemovingCharactersInSet:(NSCharacterSet *)characterSet;

@end
