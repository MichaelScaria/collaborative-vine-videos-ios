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

@interface WMViewController : UIViewController {
    WMFeedViewController *feedViewController;
    WMUploadViewController *uploadViewController;
    WMNotificationViewController *notificationViewController;
}

@property (strong, nonatomic) IBOutlet UIButton *mainButton;
@property (strong, nonatomic) IBOutlet UIButton *feedButton;
@property (strong, nonatomic) IBOutlet UIButton *cameraButton;
@property (strong, nonatomic) IBOutlet UIButton *notificationButton;

- (IBAction)mainTapped:(id)sender;
- (IBAction)feedTapped:(id)sender;
- (IBAction)cameraTapped:(id)sender;
- (IBAction)notificationTapped:(id)sender;
@end
