//
//  SCLThreadingUtils.m
//  SCL IOS Components
//
//  Created by Scott Lessans on 8/17/13.
//  Copyright (c) 2013 Scott Lessans. All rights reserved.
//

#import "SCLThreadingUtils.h"

void SCLSafelyExecuteOnMainThread(void (^block)(void))
{
    if ( block == NULL ) {
        return;
    }
    
    if ( [NSThread isMainThread])
    {
        block();
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}
