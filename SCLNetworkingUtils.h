//
//  SCLNetworkingUtils.h
//  Marquee
//
//  Created by Scott Lessans on 8/18/13.
//  Copyright (c) 2013 Marquee Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SCLNetworkingUtils)

- (NSString *) stringByUrlEncodingString;

@end

@interface NSDictionary (SCLNetworkingUtils)

- (NSString *) generateQueryString;

@end
