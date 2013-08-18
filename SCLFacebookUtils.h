//
//  SCLFacebookUtils.h
//  FacebookLoginTest
//
//  Created by Scott Lessans on 8/6/13.
//  Copyright (c) 2013 Scott Lessans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCLFacebookUserInfo.h"

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

typedef NS_ENUM(NSInteger, SCLFacebookUtilsPictureSize) {
    SCLFacebookUtilsPictureSizeDefault,
    SCLFacebookUtilsPictureSizeSquare = 1,
    SCLFacebookUtilsPictureSizeSmall,
    SCLFacebookUtilsPictureSizeNormal,
    SCLFacebookUtilsPictureSizeLarge
};

extern NSString * SCLFacebookUtilsStringFromPictureSize(SCLFacebookUtilsPictureSize);

typedef void (^SCLFacebookUtilsLoginBlock)(SCLFacebookUtils * utils, SCLFacebookUtilsLoginState result, NSError * error);

typedef void (^SCLFacebookUserInfoCallback)(SCLFacebookUserInfo * info, NSError * error);

@interface SCLFacebookUtils : NSObject

@property (nonatomic, readonly) FBSession * session;
@property (nonatomic, readonly) SCLFacebookUserInfo * currentUserInfo;
@property (nonatomic, readonly) NSString * currentUserFacebookAccessToken;

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

#pragma mark profile pictures
- (NSURL *) profilePictureUrlForUserWithId:(NSString *)userId;
- (NSURL *) profilePictureUrlForUserWithId:(NSString *)userId
                                      size:(SCLFacebookUtilsPictureSize)size;

#pragma mark user info
- (void) refreshFacebookUserInfoInBackgroundWithBlock:(SCLFacebookUserInfoCallback)block;

@end


