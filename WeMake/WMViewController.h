//
//  WMViewController.h
//  WeMake
//
//  Created by Michael Scaria on 8/16/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMFeedViewController.h"
#import "WMUploadViewController.h"
#import "WMNotificationViewController.h"

#import "FXBlurView.h"

@interface WMViewController : UIViewController <UIScrollViewDelegate> {
    WMFeedViewController *feedViewController;
    WMUploadViewController *uploadViewController;
    WMNotificationViewController *notificationViewController;
    
    FXBlurView *blurView;
    CGPoint initialPoint;
}

@property (strong, nonatomic) IBOutlet UIImageView *chevron;

@property (strong, nonatomic) IBOutlet UIButton *mainButton;
@property (strong, nonatomic) IBOutlet UIButton *feedButton;
@property (strong, nonatomic) IBOutlet UIButton *cameraButton;
@property (strong, nonatomic) IBOutlet UIButton *notificationButton;

- (IBAction)mainTapped:(id)sender;
- (IBAction)feedTapped:(id)sender;
- (IBAction)cameraTapped:(id)sender;
- (IBAction)notificationTapped:(id)sender;
@end
