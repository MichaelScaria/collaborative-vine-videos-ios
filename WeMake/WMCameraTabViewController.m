//
//  WMCameraTabViewController.m
//  WeMake
//
//  Created by Michael Scaria on 7/30/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import "WMCameraTabViewController.h"
#import "WMTabBarController.h"

@interface WMCameraTabViewController ()

@end

@implementation WMCameraTabViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	[(WMTabBarController *)self.parentViewController presentCameraView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
