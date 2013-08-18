//
//  SCLFacebookUserInfo.h
//  Marquee
//
//  Created by Scott Lessans on 8/18/13.
//  Copyright (c) 2013 Marquee Mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCLFacebookUserInfo : NSObject

@property (nonatomic, readonly) NSString * facebookUserId;
@property (nonatomic, readonly) NSString * link;
@property (nonatomic, readonly) NSString * username;
@property (nonatomic, readonly) NSString * location;
@property (nonatomic, readonly) NSString * hometown;
@property (nonatomic, readonly) NSString * firstName;
@property (nonatomic, readonly) NSString * middleName;
@property (nonatomic, readonly) NSString * lastName;
@property (nonatomic, readonly) NSString * email;
@property (nonatomic, readonly) NSDate * birthday;
@property (nonatomic, readonly) NSURL * profilePictureUrl;

@end
