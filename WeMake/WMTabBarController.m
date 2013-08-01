//
//  WMTabBarController.m
//  WeMake
//
//  Created by Michael Scaria on 7/29/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import "WMTabBarController.h"
#import "WMUploadViewController.h"


@interface WMTabBarController ()

@end

@implementation WMTabBarController
- (void)presentLoginView {
    [self performSegueWithIdentifier:@"Login" sender:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)presentCameraView {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self setSelectedIndex:0];
    });
    
    [self performSegueWithIdentifier:@"Upload" sender:nil];
}

@end
