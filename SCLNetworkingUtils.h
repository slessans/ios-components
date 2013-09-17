//
//  SCLNetworkingUtils.h
//  SCL IOS Components
//
//  Created by Scott Lessans on 8/18/13.
//  Copyright (c) 2013 Scott Lessans. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SCLNetworkingUtils)

- (NSString *) stringByUrlEncodingString;

@end

@interface NSDictionary (SCLNetworkingUtils)

- (NSString *) generateQueryString;

@end
