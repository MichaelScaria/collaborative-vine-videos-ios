//
//  WMLoginViewController.h
//  WeMake
//
//  Created by Michael Scaria on 7/4/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WMLoginViewController : UIViewController <UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextField *loginUsernameField;
@property (strong, nonatomic) IBOutlet UITextField *loginPasswordField;
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *signupUsernameField;
@property (strong, nonatomic) IBOutlet UITextField *signupPasswordField;
@property (strong, nonatomic) IBOutlet UITextField *signupConfirmPasswordField;
@property (strong, nonatomic) IBOutlet UIButton *slideButton;
- (IBAction)scroll:(id)sender;
- (IBAction)done:(UIButton *)sender;

@end
