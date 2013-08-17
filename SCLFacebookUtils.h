//
//  SCLFacebookUtils.h
//  FacebookLoginTest
//
//  Created by Scott Lessans on 8/6/13.
//  Copyright (c) 2013 Scott Lessans. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const SCLFacebookUtilsErrorDomain;

typedef NS_ENUM(NSInteger, SCLFacebookUtilsErrorCodes) {
    SCLFacebookUtilsErrorCodeInvalidSession
};

@class SCLFacebookUtils;
@class FBSession;

typedef NS_ENUM(NSInteger, SCLFacebookUtilsLoginState) {
    SCLFacebookUtilsLoginStateSuccess,
    SCLFacebookUtilsLoginStateAlreadyLoggedIn,
    SCLFacebookUtilsLoginStateFailed
};

typedef void (^SCLFacebookUtilsLoginBlock)(SCLFacebookUtils * utils, SCLFacebookUtilsLoginState result, NSError * error);

@class SCLFacebookUserInfo;

typedef void (^SCLFacebookUserInfoCallback)(SCLFacebookUserInfo * info, NSError * error);

@interface SCLFacebookUtils : NSObject

@property (nonatomic, readonly) FBSession * session;
@property (nonatomic, readonly) SCLFacebookUserInfo * currentUserInfo;

#pragma mark constructing
+ (instancetype) sharedInstance;

#pragma mark methods to put in app delegate
- (void) applicationWillTerminate:(UIApplication *)application;
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation;
- (void) applicationDidBecomeActive:(UIApplication *)application;


#pragma mark logging in/out user
- (void) loginUserWithBlock:(SCLFacebookUtilsLoginBlock)callback;
- (BOOL) doesHaveLoggedInUser;
- (BOOL) doesHaveCachedUser;
- (void) logoutFacebookUser;

#pragma mark user info
- (void) refreshFacebookUserInfoInBackgroundWithBlock:(SCLFacebookUserInfoCallback)block;

@end


@interface SCLFacebookUserInfo : NSObject

@property (nonatomic, readonly) NSString * facebookAccessToken;
@property (nonatomic, readonly) NSString * facebookUserId;
@property (nonatomic, readonly) NSString * name;
@property (nonatomic, readonly) NSString * firstName;
@property (nonatomic, readonly) NSString * middleName;
@property (nonatomic, readonly) NSString * lastName;
@property (nonatomic, readonly) NSString * link;
@property (nonatomic, readonly) NSString * username;
@property (nonatomic, readonly) NSString * birthday;

@end


