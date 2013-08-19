//
//  WMViewController.m
//  WeMake
//
//  Created by Michael Scaria on 8/16/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import "WMViewController.h"

#define kAnimationTime .2

@interface WMViewController ()

@end

@implementation WMViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *redCircle = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,30,30)];
    redCircle.image = [UIImage imageNamed:@"redCircle"];
    UIImageView *redCircle2 = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,30,30)];
    redCircle2.image = [UIImage imageNamed:@"redCircle"];
    UIImageView *redCircle3 = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,30,30)];
    redCircle3.image = [UIImage imageNamed:@"redCircle"];
    [_feedButton addSubview:redCircle];
    [_cameraButton addSubview:redCircle2];
    [_notificationButton addSubview:redCircle3];
    UILabel *feed = [[UILabel alloc] initWithFrame:CGRectMake(32, -2, 70, 30)];
    feed.font = [UIFont systemFontOfSize:13];
    feed.textColor = [UIColor whiteColor];
    feed.text = @"feed";
    [_feedButton addSubview:feed];
    UILabel *camera = [[UILabel alloc] initWithFrame:CGRectMake(32, -2, 70, 30)];
    camera.font = [UIFont systemFontOfSize:13];
    camera.textColor = [UIColor whiteColor];
    camera.text = @"camera";
    [_cameraButton addSubview:camera];
    UILabel *notifications = [[UILabel alloc] initWithFrame:CGRectMake(32, -2, 70, 30)];
    notifications.font = [UIFont systemFontOfSize:13];
    notifications.textColor = [UIColor whiteColor];
    notifications.text = @"notifications";
    [_notificationButton addSubview:notifications];
    _feedButton.translatesAutoresizingMaskIntoConstraints = YES;
    _cameraButton.translatesAutoresizingMaskIntoConstraints = YES;
    _notificationButton.translatesAutoresizingMaskIntoConstraints = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self feedTappedAnimated:NO];
//    NSLog(@"BC:%@", NSStringFromCGPoint(_feedButton.center));
//    [UIView animateWithDuration:.5 animations:^{
//        [_feedButton setCenter:CGPointMake(_feedButton.center.x + 110, _feedButton.center.y)];
//        _cameraButton.center = CGPointMake(_cameraButton.center.x + 110, _cameraButton.center.y);
//        _notificationButton.center = CGPointMake(_notificationButton.center.x + 110, _notificationButton.center.y);
//    }completion:^(BOOL isCompleted){
//        NSLog(@"C:%@", NSStringFromCGPoint(_feedButton.center));
//        _mainButton.hidden = YES;
//    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)mainTapped:(UIButton *)sender {
    if (sender.tag == 100) {
        _mainButton.hidden = NO;
        [UIView animateWithDuration:.4 animations:^{
            sender.alpha = 0.0;
            _mainButton.alpha = 1.0;
        }completion:^(BOOL isCompleted){
            [sender removeFromSuperview];
        }];
        
        
        [UIView animateWithDuration:kAnimationTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _notificationButton.center = CGPointMake(_notificationButton.center.x - 110, _notificationButton.center.y);
        }completion:nil];
        
        [UIView animateWithDuration:kAnimationTime delay:.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _cameraButton.center = CGPointMake(_cameraButton.center.x - 110, _cameraButton.center.y);
        }completion:nil];
        
        [UIView animateWithDuration:kAnimationTime delay:.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _feedButton.center = CGPointMake(_feedButton.center.x - 110, _feedButton.center.y);
        }completion:nil];
    }
    else {
        UIButton *overlay = [UIButton buttonWithType:UIButtonTypeCustom];
        overlay.backgroundColor = [UIColor colorWithWhite:.7 alpha:.5];
        overlay.frame = self.view.bounds;
        overlay.alpha = 0.0;
        overlay.tag = 100;
        [overlay addTarget:self action:@selector(mainTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view insertSubview:overlay atIndex:1];

        
        [UIView animateWithDuration:.4 animations:^{
            overlay.alpha = 1.0;
            _mainButton.alpha = 0.0;
        }completion:^(BOOL isCompleted){
            _mainButton.hidden = YES;
        }];
        
        int offset = 7;
        [UIView animateWithDuration:kAnimationTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _feedButton.center = CGPointMake(_feedButton.center.x + 110 + offset, _feedButton.center.y);
        }completion:^(BOOL complation){
             [UIView animateWithDuration:kAnimationTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                 _feedButton.center = CGPointMake(_feedButton.center.x - offset, _feedButton.center.y);
             }completion:nil];
         }];
        
        [UIView animateWithDuration:kAnimationTime delay:.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _cameraButton.center = CGPointMake(_cameraButton.center.x + 110 + offset, _cameraButton.center.y);
        }completion:^(BOOL complation){
            [UIView animateWithDuration:kAnimationTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                _cameraButton.center = CGPointMake(_cameraButton.center.x - offset, _cameraButton.center.y);
            }completion:nil];
        }];
        
        [UIView animateWithDuration:kAnimationTime delay:.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _notificationButton.center = CGPointMake(_notificationButton.center.x + 110 + offset, _notificationButton.center.y);
        }completion:^(BOOL complation){
            [UIView animateWithDuration:kAnimationTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                _notificationButton.center = CGPointMake(_notificationButton.center.x - offset, _notificationButton.center.y);
            }completion:nil];
        }];
    }
    
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)check {
    if ([feedViewController.view isDescendantOfView:self.view]) {
        [feedViewController.view removeFromSuperview];
    }
    if ([uploadViewController.view isDescendantOfView:self.view]) {
        [uploadViewController.view removeFromSuperview];
    }
    if ([notificationViewController.view isDescendantOfView:self.view]) {
        [notificationViewController.view removeFromSuperview];
    }
}

- (IBAction)feedTapped:(id)sender {
    [self feedTappedAnimated:YES];
}

- (void)feedTappedAnimated:(BOOL)animated {
    if (!feedViewController) {
        feedViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Feed"];
    }
    if (animated) {
        UIView *overlay = [self.view viewWithTag:100];
        _mainButton.hidden = NO;
        [UIView animateWithDuration:.4 animations:^{
            overlay.alpha = 0.0;
            _mainButton.alpha = 1.0;
        }completion:^(BOOL isCompleted){
            [overlay removeFromSuperview];
            [self check];
            [self.view insertSubview:feedViewController.view atIndex:0];
        }];
        
        
        [UIView animateWithDuration:kAnimationTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _notificationButton.center = CGPointMake(_notificationButton.center.x - 110, _notificationButton.center.y);
        }completion:nil];
        
        [UIView animateWithDuration:kAnimationTime delay:.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _cameraButton.center = CGPointMake(_cameraButton.center.x - 110, _cameraButton.center.y);
        }completion:nil];
        
        [UIView animateWithDuration:kAnimationTime delay:.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _feedButton.center = CGPointMake(_feedButton.center.x - 110, _feedButton.center.y);
        }completion:nil];
    }
    else {
        [self check];
        [self.view insertSubview:feedViewController.view atIndex:0];
    }
}

- (IBAction)cameraTapped:(id)sender {
    UIView *overlay = [self.view viewWithTag:100];
    _mainButton.hidden = NO;
    [UIView animateWithDuration:.4 animations:^{
        overlay.alpha = 0.0;
        _mainButton.alpha = 1.0;
    }completion:^(BOOL isCompleted){
        [overlay removeFromSuperview];
        if (!uploadViewController) {
            uploadViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Upload"];
        }
        [self check];
        [self.view insertSubview:uploadViewController.view atIndex:0];
    }];
    
    
    [UIView animateWithDuration:kAnimationTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _notificationButton.center = CGPointMake(_notificationButton.center.x - 110, _notificationButton.center.y);
    }completion:nil];
    
    [UIView animateWithDuration:kAnimationTime delay:.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _cameraButton.center = CGPointMake(_cameraButton.center.x - 110, _cameraButton.center.y);
    }completion:nil];
    
    [UIView animateWithDuration:kAnimationTime delay:.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _feedButton.center = CGPointMake(_feedButton.center.x - 110, _feedButton.center.y);
    }completion:nil];
}

- (IBAction)notificationTapped:(id)sender {
    UIView *overlay = [self.view viewWithTag:100];
    _mainButton.hidden = NO;
    [UIView animateWithDuration:.4 animations:^{
        overlay.alpha = 0.0;
        _mainButton.alpha = 1.0;
    }completion:^(BOOL isCompleted){
        [overlay removeFromSuperview];
        if (!notificationViewController) {
            notificationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Notification"];
        }
        [self check];
        [self.view insertSubview:notificationViewController.view atIndex:0];
    }];
    
    
    [UIView animateWithDuration:kAnimationTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _notificationButton.center = CGPointMake(_notificationButton.center.x - 110, _notificationButton.center.y);
    }completion:nil];
    
    [UIView animateWithDuration:kAnimationTime delay:.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _cameraButton.center = CGPointMake(_cameraButton.center.x - 110, _cameraButton.center.y);
    }completion:nil];
    
    [UIView animateWithDuration:kAnimationTime delay:.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _feedButton.center = CGPointMake(_feedButton.center.x - 110, _feedButton.center.y);
    }completion:nil];
}
@end
