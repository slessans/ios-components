//
//  SCLFacebookUtils.h
//  FacebookLoginTest
//
//  Created by Scott Lessans on 8/6/13.
//  Copyright (c) 2013 Scott Lessans. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SCLFacebookUtils;
@class FBSession;

typedef NS_ENUM(NSInteger, SCLFacebookUtilsLoginState) {
    SCLFacebookUtilsLoginStateSuccess,
    SCLFacebookUtilsLoginStateAlreadyLoggedIn,
    SCLFacebookUtilsLoginStateFailed
};

typedef void (^SCLFacebookUtilsLoginBlock)(SCLFacebookUtils * utils, SCLFacebookUtilsLoginState result, NSError * error);

@interface SCLFacebookUtils : NSObject

@property (nonatomic, strong) FBSession * session;

+ (instancetype) sharedInstance;

- (void) applicationWillTerminate:(UIApplication *)application;

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;

- (void)applicationDidBecomeActive:(UIApplication *)application;

- (void) loginUserWithBlock:(SCLFacebookUtilsLoginBlock)callback;

- (BOOL) doesHaveLoggedInUser;
- (BOOL) doesHaveCachedUser;

- (void) logoutFacebookUser;

@end
