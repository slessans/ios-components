//
//  SCLFacebookUtils.m
//  FacebookLoginTest
//
//  Created by Scott Lessans on 8/6/13.
//  Copyright (c) 2013 Scott Lessans. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "SCLFacebookUtils.h"
#import "SCLThreadingUtils.h"

@implementation SCLFacebookUtils

+ (instancetype) sharedInstance
{
    static SCLFacebookUtils * sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SCLFacebookUtils alloc] init];
    });
    return sharedInstance;
}

- (id) init
{
    self = [super init];
    if ( self ) {
        self.session = [[FBSession alloc] init];
    }
    return self;
}

- (void) loginUserWithBlock:(SCLFacebookUtilsLoginBlock)callback
{
    
    if ( [self doesHaveLoggedInUser] ) {
        NSLog(@"Already open.");
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(self, SCLFacebookUtilsLoginStateAlreadyLoggedIn, nil);
        });
        return;
    }
    
    // if the session isn't open, let's open it now and present the login UX to the user
    [self.session openWithCompletionHandler:^(FBSession *session,
                                              FBSessionState status,
                                              NSError *error) {
        //SCLFacebookUtilsLoginState state = SCLFacebookUtilsLoginStateFailed;
        if ( FB_ISSESSIONOPENWITHSTATE(status) ) {
            NSLog(@"Facebook open session success (status %d) %@", status, session);
            SCLSafelyExecuteOnMainThread(^{
                callback(self, SCLFacebookUtilsLoginStateSuccess, nil);
            });
        } else {
            NSLog(@"Facebook open session FAIL (status %d): %@ %@", status, error, session);
            SCLSafelyExecuteOnMainThread(^{
                callback(self, SCLFacebookUtilsLoginStateFailed, error);
            });            
        }
    }];
    
}

- (BOOL) doesHaveLoggedInUser
{
    return self.session.isOpen;
}

- (BOOL) doesHaveCachedUser
{
    if ( [self doesHaveLoggedInUser] ) {
        return YES;
    }
    
    return (self.session.state == FBSessionStateCreatedTokenLoaded);
}

- (void) logoutFacebookUser
{
    [self.session closeAndClearTokenInformation];
    self.session = [[FBSession alloc] init];
}

// FBSample logic
// The native facebook application transitions back to an authenticating application when the user
// chooses to either log in, or cancel. The url passed to this method contains the token in the
// case of a successful login. By passing the url to the handleOpenURL method of FBAppCall the provided
// session object can parse the URL, and capture the token for use by the rest of the authenticating
// application; the return value of handleOpenURL indicates whether or not the URL was handled by the
// session object, and does not reflect whether or not the login was successful; the session object's
// state, as well as its arguments passed to the state completion handler indicate whether the login
// was successful; note that if the session is nil or closed when handleOpenURL is called, the expression
// will be boolean NO, meaning the URL was not handled by the authenticating application
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:self.session];
}

// FBSample logic
// It is possible for the user to switch back to your application, from the native Facebook application,
// when the user is part-way through a login; You can check for the FBSessionStateCreatedOpenening
// state in applicationDidBecomeActive, to identify this situation and close the session; a more sophisticated
// application may choose to notify the user that they switched away from the Facebook application without
// completely logging in
- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppEvents activateApp];
    
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    // FBSample logic
    // We need to properly handle activation of the application with regards to SSO
    //  (e.g., returning from iOS 6.0 authorization dialog or from fast app switching).
    [FBAppCall handleDidBecomeActiveWithSession:self.session];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // FBSample logic
    // if the app is going away, we close the session if it is open
    // this is a good idea because things may be hanging off the session, that need
    // releasing (completion block, etc.) and other components in the app may be awaiting
    // close notification in order to do cleanup
    [self.session close];
}

@end
