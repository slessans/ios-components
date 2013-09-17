//
//  SCLThreadingUtils.h
//  SCL IOS Components
//
//  Created by Scott Lessans on 8/17/13.
//  Copyright (c) 2013 Scott Lessans. All rights reserved.
//

#import <Foundation/Foundation.h>

extern void SCLSafelyExecuteOnMainThread(void (^block)(void));
