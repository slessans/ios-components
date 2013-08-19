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
#import "SCLFacebookUserInfo+Protected.h"
#import "SCLNetworkingUtils.h"

NSString * const SCLFacebookUtilsErrorDomain = @"com.scottlessans.facebookutils";

NSString * SCLFacebookUtilsStringFromPictureSize(SCLFacebookUtilsPictureSize pictureSize)
{
    switch ((NSInteger)pictureSize) {
        case SCLFacebookUtilsPictureSizeSquare:
            return @"square";
            break;
        case SCLFacebookUtilsPictureSizeSmall:
            return @"small";
            break;
        case SCLFacebookUtilsPictureSizeNormal:
            return @"normal";
            break;
        case SCLFacebookUtilsPictureSizeLarge:
            return @"large";
            break;
    }
    return nil;
}

NSString * SCLFacebookUtilsFriendName(NSDictionary * friendData)
{
    return friendData[@"name"];
}

NSString * SCLFacebookUtilsFriendId(NSDictionary * friendData)
{
    return friendData[@"id"];
}

NSURL * SCLFacebookUtilsFriendProfilePictureUrl(NSDictionary * friendData)
{
    return SCLFacebookUtilsFriendProfilePictureUrlWithSize(friendData, SCLFacebookUtilsPictureSizeDefault);
}

NSURL * SCLFacebookUtilsFriendProfilePictureUrlWithSize(NSDictionary * friendData, SCLFacebookUtilsPictureSize size)
{
    NSString * userId = SCLFacebookUtilsFriendId(friendData);
    if (!userId) return nil;
    return [[SCLFacebookUtils sharedInstance] profilePictureUrlForUserWithId:userId
                                                                        size:size];
}

@interface SCLFacebookUtils ()

@property (nonatomic, strong) FBSession * session;
@property (nonatomic, strong) SCLFacebookUserInfo * currentUserInfo;

@end

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

- (NSString *) currentUserFacebookAccessToken
{
    return self.session.accessTokenData.accessToken;
}

- (FBSession *) session
{
    return [FBSession activeSession];
}

- (NSURL *) profilePictureUrlForUserWithId:(NSString *)userId
{
    return [self profilePictureUrlForUserWithId:userId
                                           size:SCLFacebookUtilsPictureSizeDefault];
}

- (NSURL *) profilePictureUrlForUserWithId:(NSString *)userId
                                      size:(SCLFacebookUtilsPictureSize)size
{
    if ( ! userId || [userId isEqualToString:@""] ) {
        return nil;
    }
    
    NSMutableDictionary * dictionary = [[NSMutableDictionary alloc] init];
    
    NSString * pictureSizeStr = SCLFacebookUtilsStringFromPictureSize(size);
    if ( pictureSizeStr ) {
        dictionary[@"type"] = pictureSizeStr;
    }
    
    NSString * accessToken = [self currentUserFacebookAccessToken];
    if ( accessToken ) {
        dictionary[@"token"] = accessToken;
    }
    
    return [NSURL URLWithString:[NSString stringWithFormat:
                                 @"https://graph.facebook.com/%@/picture%@",
                                 userId, [dictionary generateQueryString]]];
}

- (void) setSession:(FBSession *)session
{
    if ( session == self.session ) return;
    [FBSession setActiveSession:session];
}

- (id) init
{
    self = [super init];
    if ( self ) {
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
    
    self.currentUserInfo = nil;
    
    if ( FB_ISSESSIONSTATETERMINAL(self.session.state) )
    {
        self.session = [[FBSession alloc] init];
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

- (void) refreshFacebookUserInfoInBackgroundWithBlock:(SCLFacebookUserInfoCallback)block
{
    
    if ( ! self.session || ! self.session.isOpen )
    {
        SCLSafelyExecuteOnMainThread(^{
            NSDictionary * userInfo = @{NSLocalizedDescriptionKey: @"Facebook session object is not existent or not open."};
            NSError * error = [NSError errorWithDomain:SCLFacebookUtilsErrorDomain
                                                  code:SCLFacebookUtilsErrorCodeInvalidSession
                                              userInfo:userInfo];
            block(nil, error);
        });
        return;
    }
    
    // Create request for user's Facebook data
    NSString * requestPath =
    @"me/?fields=id,username,first_name,middle_name,last_name,email,"
    @"hometown,location,gender,birthday,relationship_status";
    
    // Send request to Facebook
    FBRequest * request = [FBRequest requestForGraphPath:requestPath];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        SCLFacebookUserInfo * info = nil;
        
        if (!error) {
            NSDictionary *userData = (NSDictionary *)result; // The result is a dictionary
            
            /*details.gender = MQUserGenderUnknown;
             NSString * genderString = [[userData[@"gender"] stringByTrimmingCharactersInSet:
             [NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
             if ( [genderString isEqualToString:@"male"] ) {
             details.gender = MQUserGenderMale;
             } else if ( [genderString isEqualToString:@"female"] ) {
             details.gender = MQUserGenderFemale;
             }
             // details.relationshipStatus = userData[@"relationship_status"];
             */
            
            info = [[SCLFacebookUserInfo alloc] init];
            
            NSString * birthdayString = userData[@"birthday"];
            if ( birthdayString ) {
                NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"MM/dd/yyyy"];
                info.birthday = [formatter dateFromString:birthdayString];
            }
            
            info.facebookUserId = userData[@"id"];
            info.username = userData[@"username"];
            info.link = userData[@"link"];
            info.email = userData[@"email"];            
            info.firstName = userData[@"first_name"];
            info.middleName = userData[@"middle_name"];
            info.lastName = userData[@"last_name"];
            info.location = userData[@"location"][@"name"];
            info.hometown = userData[@"hometown"][@"name"];
            
        }
        
        SCLSafelyExecuteOnMainThread(^{
            if ( info ) {
                self.currentUserInfo = info;
            }
            if ( block != NULL ) {
                block(info, error);
            }
        });
    }];
    
}

- (void) fetchFriendsOfCurrentUserWithBlock:(SCLFacebookFriendsCallback)block
{
    [self fetchFriendsOfUser:@"me"
                   withBlock:block];
}

- (void) fetchFriendsOfUser:(NSString *)userFacebookId withBlock:(SCLFacebookFriendsCallback)block
{
    if ( block == NULL ) return;
    
    if ( ! self.session || ! self.session.isOpen )
    {
        SCLSafelyExecuteOnMainThread(^{
            NSDictionary * userInfo = @{NSLocalizedDescriptionKey: @"Facebook session object is not existent or not open."};
            NSError * error = [NSError errorWithDomain:SCLFacebookUtilsErrorDomain
                                                  code:SCLFacebookUtilsErrorCodeInvalidSession
                                              userInfo:userInfo];
            block(self, nil, error);
        });
        return;
    }        
    
    // Create request for user's Facebook data
    NSString * requestPath = [NSString stringWithFormat:@"%@/friends", userFacebookId];
    
    // Send request to Facebook
    FBRequest * request = [FBRequest requestForGraphPath:requestPath];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id data, NSError *error) {
        
        if ( error ) {
            SCLSafelyExecuteOnMainThread(^{
                block(self, nil, error);
            });
            return;
        }
        
        NSDictionary * result = data;
        SCLSafelyExecuteOnMainThread(^{
            block(self, result[@"data"], nil);
        });
        
    }];
    
}

@end


