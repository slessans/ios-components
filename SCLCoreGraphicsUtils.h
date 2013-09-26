//
//  SCLCoreGraphicsUtils.h
//  Marquee
//
//  Created by Scott Lessans on 9/26/13.
//  Copyright (c) 2013 Marquee Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Core Graphic

// returns YES iff both dimensions of test are smaller than refereneSize
// if strict == YES, both dimensions must be smaller, if strict equals NO
// both dimensions must be smaller than or equal
CG_INLINE __attribute__((const)) BOOL CGSizeIsSmallerThanCGSize(CGSize test, CGSize referenceSize, BOOL strict)
{
    return (strict && ((test.width < referenceSize.width) && (test.height < referenceSize.height)))
    || ((test.width <= referenceSize.width) && (test.height <= referenceSize.height));
}

// returns YES iff both dimensions of test are smaller than refereneSize
// if strict == YES, both dimensions must be smaller, if strict equals NO
// both dimensions must be smaller than or equal
CG_INLINE __attribute__((const)) BOOL CGSizeHasSmallerDimensionThanCGSize(CGSize test, CGSize referenceSize, BOOL strict)
{
    return (strict && ((test.width < referenceSize.width) || (test.height < referenceSize.height)))
    || ((test.width <= referenceSize.width) || (test.height <= referenceSize.height));
}


@interface SCLCoreGraphicsUtils : NSObject
@end
