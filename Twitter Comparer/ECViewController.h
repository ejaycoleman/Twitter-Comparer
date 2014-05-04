//
//  ECViewController.h
//  Twitter Comparer
//
//  Created by Elliott Coleman on 04/05/2014.
//  Copyright (c) 2014 Elliott Coleman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *twitterHandle;
- (IBAction)calculateButton:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *outcomeAnswerLabel;



@end
