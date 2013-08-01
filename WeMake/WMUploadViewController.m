//
//  WMUploadViewController.m
//  WeMake
//
//  Created by Michael Scaria on 7/24/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import "WMUploadViewController.h"
#import "WMModel.h"


@interface WMUploadViewController ()

@end

@implementation WMUploadViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
	cameraViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Camera"];
    cameraViewController.delegate = self;
	reviewViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Review"];
    reviewViewController.delegate = self;
    reviewViewController.view.frame = CGRectMake(screenSize.width, 0, reviewViewController.view.frame.size.width, reviewViewController.view.frame.size.height);

    UIScrollView *scrollView = (UIScrollView *)self.view;
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(screenSize.width*3, screenSize.height);
    scrollView.scrollEnabled = NO;
    scrollView.backgroundColor = [UIColor redColor];

    [scrollView addSubview:cameraViewController.view];
    [scrollView addSubview:reviewViewController.view];
    //NSString *mediaurl = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"mov"];

    //[self previewVideo:[NSURL fileURLWithPath:mediaurl]];
}

#pragma mark WMCameraViewControllerDelegate

- (void)previewVideo:(NSURL *)url {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        videoURL = url;
        UIScrollView *scrollView = (UIScrollView *)self.view;
        [scrollView scrollRectToVisible:CGRectMake(320, 0, 320, 1) animated:YES];
        reviewViewController.url = url;
        if (!requestViewController) {
            CGSize screenSize = [[UIScreen mainScreen] bounds].size;
            requestViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Request"];
            requestViewController.delegate = self;
            requestViewController.view.frame = CGRectMake(screenSize.width * 2, 0, requestViewController.view.frame.size.width, requestViewController.view.frame.size.height);
            [scrollView addSubview:requestViewController.view];
        }
        [[WMModel sharedInstance] fetchFollowersSuccess:^(NSArray *followers){
            NSLog(@"Followers:%@", followers);
            [requestViewController setFollowers:[followers mutableCopy]];
        }failure:nil];
    });
    
}

#pragma mark WMReviewViewControllerDelegate

- (void)approved {
    UIScrollView *scrollView = (UIScrollView *)self.view;
    [scrollView scrollRectToVisible:CGRectMake(640, 0, 320, 1) animated:YES];
}

- (void)back {
    UIScrollView *scrollView = (UIScrollView *)self.view;
    [scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

#pragma mark WMRequestViewControllerDelegate

- (void)sendToFollowers:(NSString *)followers {
    NSLog(@"F:%@", followers);
    [[WMModel sharedInstance] uploadURL:videoURL to:followers success:^{
        [self dismissViewControllerAnimated:YES completion:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Sent Request%@", (followers.length > 1) ? @"s" : @""] message:@"Success" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            });
        }];
    }failure:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
}

@end
