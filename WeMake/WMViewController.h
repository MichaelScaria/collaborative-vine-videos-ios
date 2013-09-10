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
    
    CGPoint initialPoint;
    BOOL validPan;
    BOOL menuDisplayed;
    BOOL animatingChevron;
    BOOL actionForTouch;//if the menu has been already presented for the touch, ignore future changes
}

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet FXBlurView *blurView;
@property (strong, nonatomic) IBOutlet UIButton *chevron;

@property (strong, nonatomic) IBOutlet UIButton *feedButton;
@property (strong, nonatomic) IBOutlet UIButton *cameraButton;
@property (strong, nonatomic) IBOutlet UIButton *notificationButton;

- (IBAction)mainTapped:(id)sender;
- (IBAction)feedTapped:(id)sender;
- (IBAction)cameraTapped:(id)sender;
- (IBAction)notificationTapped:(id)sender;
@end
