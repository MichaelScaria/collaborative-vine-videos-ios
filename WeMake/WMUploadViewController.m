//
//  WMUploadViewController.m
//  WeMake
//
//  Created by Michael Scaria on 7/24/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import "WMUploadViewController.h"



@interface WMUploadViewController ()

@end

@implementation WMUploadViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
	cameraViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Camera"];
    cameraViewController.delegate = self;
	reviewViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Review"];
    reviewViewController.delegate = self;
    reviewViewController.view.frame = CGRectMake(screenSize.width, 0, reviewViewController.view.frame.size.width, reviewViewController.view.frame.size.height);

    UIScrollView *scrollView = (UIScrollView *)self.view;
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(screenSize.width*2, screenSize.height);
    scrollView.scrollEnabled = NO;
    scrollView.backgroundColor = [UIColor redColor];

    [scrollView addSubview:cameraViewController.view];
    [scrollView addSubview:reviewViewController.view];
}

#pragma mark WMViewControllerDelegate

- (void)display:(void (^)(void))completion {
    [cameraViewController display:completion];
}

- (void)hide:(void (^)(void))completion {
    [cameraViewController hide:completion];
}

#pragma mark WMCameraViewControllerDelegate

- (void)previewVideo:(NSURL *)url {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIScrollView *scrollView = (UIScrollView *)self.view;
        [scrollView scrollRectToVisible:CGRectMake(320, 0, 320, 1) animated:YES];
        reviewViewController.url = url;
    });
}

#pragma mark WMReviewViewControllerDelegate

- (void)approved {
    
}

- (void)back {
    UIScrollView *scrollView = (UIScrollView *)self.view;
    [scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

@end
