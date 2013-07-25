//
//  WMUploadViewController.m
//  WeMake
//
//  Created by Michael Scaria on 7/24/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import "WMUploadViewController.h"
#import "WMCameraViewController.h"

@interface WMUploadViewController ()

@end

@implementation WMUploadViewController
@synthesize delegate;

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
	WMCameraViewController *cameraViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Camera"];
    self.delegate = cameraViewController;
    if (!self.delegate) {
        NSLog(@"not");
    }
    UIScrollView *scrollView = (UIScrollView *)self.view;
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(640, 568);
    [scrollView addSubview:cameraViewController.view];
}

- (void)display:(void (^)(void))completion {
    if (!self.delegate) {
        NSLog(@"not");
    }
    [self.delegate display:completion];
}
- (void)hide:(void (^)(void))completion {
    [self.delegate hide:completion];
}
@end
