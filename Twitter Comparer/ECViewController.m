//
//  ECViewController.m
//  Twitter Comparer
//
//  Created by Elliott Coleman on 04/05/2014.
//  Copyright (c) 2014 Elliott Coleman. All rights reserved.
//

#import "ECViewController.h"
#import "momentsSocialManager.h"

@interface ECViewController ()

@end

@implementation ECViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (IBAction)calculateButton:(id)sender {
    NSString *twitterHandleString = self.twitterHandle.text;
    [momentsSocialManager requestTwitterPermissionsWithCallback:^(NSString *username) {
        NSLog(@"%@",username);
        [momentsSocialManager getUserInfoForUser:twitterHandleString withCallback:^(NSDictionary *data) {
            float friendsCount = [data[@"friends_count"]floatValue];
            float followersCount = [data[@"followers_count"]floatValue];
            NSLog(@"%f", followersCount);
            NSLog(@"%f", friendsCount);
            NSString *answer = @"Begin!";
            if (followersCount > friendsCount){
                answer =  @"More followers than following!";
            }
            else {
                answer = @"More following than followers!";
            }
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{ self.outcomeAnswerLabel.text = [NSString stringWithFormat:@"%@", answer]; }];
        }];
    }];
}
@end
