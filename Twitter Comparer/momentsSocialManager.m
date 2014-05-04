//
//  snapptSocialManager.m
//  Instant Social Camera
//
//  Created by Joshua Balfour on 15/05/2013.
//  Copyright (c) 2013 Josh Balfour. All rights reserved.
//

#import "momentsSocialManager.h"

@implementation momentsSocialManager
@synthesize accountStore;

-(id)init{
    self = [super init];
    accountStore = [[ACAccountStore alloc] init];
    return self;
}


+(void)requestTwitterPermissionsWithCallback:(void (^)(NSString*))callback{
    momentsSocialManager *this = [[self alloc] init];
    ACAccountType *twitterType =
    [this.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    ACAccountStoreRequestAccessCompletionHandler accountStoreHandler =
    ^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *accounts = [this.accountStore accountsWithAccountType:twitterType];
            callback([[accounts lastObject] username]);
        }
        else {
            NSLog(@"[ERROR] An error occurred while asking for user authorization: %@",
                  [error localizedDescription]);
        }
    };
    
    [this.accountStore requestAccessToAccountsWithType:twitterType
                                               options:NULL
                                            completion:accountStoreHandler];
}

+ (void)getUserInfoForUser:(NSString*)username withCallback:(void (^)(NSDictionary*))callback
{
    momentsSocialManager *sms = [[momentsSocialManager alloc] init];
    NSLog(@"posting to twitter");
    ACAccountType *twitterType =
    [sms.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    SLRequestHandler requestHandler =
    ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (responseData) {
            NSInteger statusCode = urlResponse.statusCode;
            if (statusCode >= 200 && statusCode < 300) {
                NSDictionary *postResponseData =
                [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingMutableContainers
                                                  error:NULL];
                callback(postResponseData);
                /* [tracker sendEventWithCategory:@"twitter"
                 withAction:@"post"
                 withLabel:postResponseData[@"id_str"]
                 withValue: nil];
                 */
                // remove tweet thing in queue
            }
            else {
                NSLog(@"[ERROR] Server responded: status code %ld %@", (long)statusCode,
                      [NSHTTPURLResponse localizedStringForStatusCode:statusCode]);
                // failure
            }
        }
        else {
            NSLog(@"[ERROR] An error occurred while posting: %@", [error localizedDescription] );
            // failure
        }
    };
    
    ACAccountStoreRequestAccessCompletionHandler accountStoreHandler =
    ^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *accounts = [sms.accountStore accountsWithAccountType:twitterType];
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"https://api.twitter.com/1.1/users/show.json?screen_name=",username]];
            SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                              requestMethod:SLRequestMethodGET
                                              URL:url
                                              parameters:nil];
            
            /*
             NSData *imageData = UIImageJPEGRepresentation(image, 0.1f);
             [request addMultipartData:imageData
             withName:@"media[]"
             type:@"image/jpeg"
             filename:@"snapptphoto.jpg"];
             */
            [request setAccount:[accounts lastObject]];
            
            [request performRequestWithHandler:requestHandler];
        }
        else {
            NSLog(@"[ERROR] An error occurred while asking for user authorization: %@",
                  [error localizedDescription]);
        }
    };
    
    [sms.accountStore requestAccessToAccountsWithType:twitterType
                                              options:NULL
                                           completion:accountStoreHandler];
}
@end
