//
//  WMViewController.m
//  WeMake
//
//  Created by Michael Scaria on 6/30/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import "WMViewController.h"
#import "WMModel.h"
#import "WMLoginViewController.h"
//#import "WMCameraViewController.h"

#define kCameraViewOffset 50.0

@interface WMViewController ()

@end

@implementation WMViewController

@synthesize posts, scrollView;

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

//    WMUploadViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"Upload"];
//    if (vc) {
//        self.delegate = vc;
//        [self.view insertSubview:vc.view atIndex:0];
//    }

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    screenSize = [[UIScreen mainScreen] bounds].size;
    [self setUpScrollView];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setUpScrollView {
    self.scrollView.contentSize = CGSizeMake(320, screenSize.height);
}

//- (IBAction)flipCameraView:(UIButton *)sender {
//    sender.enabled = NO;
//    if (recordingView) {
//        [UIView animateWithDuration:.5 animations:^{
//            [(UITabBarController *)[self parentViewController] tabBar].frame = CGRectMake(0, 0, 320, scrollView.frame.size.height);
//        } completion:nil];
//        
//        [self.delegate hide:^{
//            [UIView animateWithDuration:.2 animations:^{
//                self.scrollView.alpha = .85;
//            } completion:^(BOOL isCompleted){
//                recordingView = NO;
//                sender.enabled = YES;
//            }];
//        }];
//        [sender setTitle:@"Record" forState:UIControlStateNormal];
//    }
//    else {
//        NSLog(@"%@", NSStringFromClass([self.parentViewController class]));
//        if (!self.delegate) {
//            NSLog(@"nil");
//        }
//        [self.delegate display:^{
//            [UIView animateWithDuration:.65 animations:^{
//                [(UITabBarController *)[self parentViewController] tabBar].frame = CGRectMake(scrollView.frame.origin.x, scrollView.frame.size.height, 320, scrollView.frame.size.height);
//            }completion:^(BOOL isCompleted){
//                recordingView = YES;
//                sender.enabled = YES;
//            }];
//        }];
//        [sender setTitle:@"X" forState:UIControlStateNormal];
//        [UIView animateWithDuration:.2 animations:^{
//            self.scrollView.alpha = 0;
//        } completion:nil];
//        
//    }
//}




@end
