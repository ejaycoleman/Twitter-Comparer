//
//  snapptSocialManager.h
//  Instant Social Camera
//
//  Created by Joshua Balfour on 15/05/2013.
//  Copyright (c) 2013 Josh Balfour. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Social/Social.h>
#import <Social/SLRequest.h>
#import <Accounts/Accounts.h>


@interface momentsSocialManager : NSObject;

+(void)requestTwitterPermissionsWithCallback:(void (^)(NSString*))callback;
+ (void)getUserInfoForUser:(NSString*)username withCallback:(void (^)(NSDictionary*))callback;

@property (nonatomic, strong) ACAccountStore *accountStore;

@end