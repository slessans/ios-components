//
//  SCLNetworkingUtils.m
//  SCL IOS Components
//
//  Created by Scott Lessans on 8/18/13.
//  Copyright (c) 2013 Scott Lessans. All rights reserved.
//

#import "SCLNetworkingUtils.h"

@implementation NSString (SCLNetworkingUtils)

- (NSString *) stringByUrlEncodingString
{
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                       (CFStringRef)self,
                                                                       NULL,
                                                                       (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                       kCFStringEncodingUTF8));
}

@end


static NSString * URLEncodedValueFromObject(id object)
{
    NSString * strVal = nil;
    if ( [object isKindOfClass:[NSString class]] ) {
        strVal = object;
    } else {
        strVal = [NSString stringWithFormat:@"%@", strVal];
    }
    return [strVal stringByUrlEncodingString];
}

@implementation NSDictionary (SCLNetworkingUtils)

- (NSString *) generateQueryString
{
    NSMutableArray * keyValuePairs = [[NSMutableArray alloc] initWithCapacity:[self count]];
    
    for (id key in [self keyEnumerator]) {
        id value = self[key];
        
        if ( value == [NSNull null] ) {
            [keyValuePairs addObject:URLEncodedValueFromObject(key)];
        } else {
            [keyValuePairs addObject:[NSString stringWithFormat:@"%@=%@",
                                      URLEncodedValueFromObject(key),
                                      URLEncodedValueFromObject(value)]];
        }
    }
    
    NSString * queryString = @"";
    if ( [keyValuePairs count] > 0 ) {
        queryString = [[NSString alloc] initWithFormat:@"?%@",
                       [keyValuePairs componentsJoinedByString:@"&"]];
    }
    
    return queryString;
}

@end
