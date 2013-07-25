//
//  WMLoginViewController.m
//  WeMake
//
//  Created by Michael Scaria on 7/4/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import "WMLoginViewController.h"

#import "WMModel.h"
@interface WMLoginViewController ()

@end

@implementation WMLoginViewController
@synthesize scrollView, loginUsernameField, loginPasswordField, nameField, signupUsernameField, signupPasswordField, signupConfirmPasswordField, slideButton;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.scrollView.contentSize = CGSizeMake(640, self.scrollView.frame.size.height);
}

- (IBAction)scroll:(id)sender {
    if (self.scrollView.contentOffset.x == 0) {
        [self.scrollView setContentOffset:CGPointMake(320, 0) animated:YES];
        [self.slideButton setTitle:@"Back" forState:UIControlStateNormal];
    }
    else {
        [self.scrollView setContentOffset:CGPointZero animated:YES];
        [self.slideButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    }
}

- (void)displayError:(NSString *)title message:(NSString *)message sender:(UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    if (sender) sender.enabled = YES;
}

- (IBAction)done:(UIButton *)sender {
    sender.enabled = NO;
    if (self.scrollView.contentOffset.x == 0) {
        if (loginUsernameField.text.length == 0 || loginPasswordField.text.length == 0) {
            NSString *message;
            if (loginUsernameField.text.length == 0 && loginPasswordField.text.length == 0) {
                message = @"Username and password cannot be blank";
            }
            else if (loginUsernameField.text.length == 0) {
                message = @"Username cannot be blank";
            }
            else if (loginPasswordField.text.length == 0) {
                message = @"Password cannot be blank";
            }
            [self displayError:@"Cannot be blank" message:message sender:sender];
            return;
        }
        [[WMModel sharedInstance] login:loginUsernameField.text password:loginPasswordField.text success:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        }failure:^{
            [self displayError:@"User not found" message:@"Please check your info again" sender:sender];
        }];
    }
    else {
        if (nameField.text.length == 0 || signupUsernameField.text.length == 0 || signupPasswordField.text.length == 0 || signupConfirmPasswordField.text.length == 0) {
            [self displayError:@"Cannot be blank" message:@"Please fill in all the blanks" sender:sender];
            return;
        }
        if (![signupPasswordField.text isEqualToString:signupConfirmPasswordField.text]) {
            [self displayError:@"Check Password" message:@"Passwords don't match" sender:sender];
            return;
        }
        [[WMModel sharedInstance] signUp:@{@"name": nameField.text, @"username" : signupUsernameField.text, @"password" : signupPasswordField.text} success:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        }failure:^(BOOL usernameTaken){
            if (usernameTaken) [self displayError:@"Username Taken" message:@"Please choose a new username" sender:sender];
            else [self displayError:@"Sign in failed" message:@"Please try again" sender:sender];
            
        }];
    }
}

- (void)resignTextfields {
    if ([loginUsernameField isFirstResponder]) [loginUsernameField resignFirstResponder];
    else if ([loginPasswordField isFirstResponder]) [loginPasswordField resignFirstResponder];
    else if ([nameField isFirstResponder]) [nameField resignFirstResponder];
    else if ([signupUsernameField isFirstResponder]) [signupUsernameField resignFirstResponder];
    else if ([signupPasswordField isFirstResponder]) [signupPasswordField resignFirstResponder];
    else if ([signupConfirmPasswordField isFirstResponder]) [signupConfirmPasswordField resignFirstResponder];

}
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self resignTextfields];
}

@end
