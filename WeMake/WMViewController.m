//
//  WMViewController.m
//  WeMake
//
//  Created by Michael Scaria on 8/16/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import "WMViewController.h"

#import "Constants.h"
#import "UIImage+WeMake.h"


#define kAnimationTime .2
#define PULL_THRESHOLD 200

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
    
    [_chevron setImage:[UIImage ipMaskedImageNamed:@"Chevron" color:kColorDark] forState:UIControlStateNormal];
    UIImageView *redCircle = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,30,30)];
//    redCircle.image = [UIImage imageNamed:@"feed-menu"];
    redCircle.image = [UIImage ipMaskedImageNamed:@"feed-menu" color:[UIColor colorWithWhite:.65 alpha:1]];
    UIImageView *redCircle2 = [[UIImageView alloc] initWithFrame:CGRectMake(0,4,30,21)];
//    redCircle2.image = [UIImage imageNamed:@"camera-menu"];
    redCircle2.image = [UIImage ipMaskedImageNamed:@"camera-menu" color:[UIColor colorWithWhite:.65 alpha:1]];
    UIImageView *redCircle3 = [[UIImageView alloc] initWithFrame:CGRectMake(0,4,30,20)];
//    redCircle3.image = [UIImage imageNamed:@"notification-menu"];
    redCircle3.image = [UIImage ipMaskedImageNamed:@"notification-menu" color:[UIColor colorWithWhite:.65 alpha:1]];
    [_feedButton addSubview:redCircle];
    [_cameraButton addSubview:redCircle2];
    [_notificationButton addSubview:redCircle3];
    UILabel *feed = [[UILabel alloc] initWithFrame:CGRectMake(35, -2, 70, 30)];
    feed.font = [UIFont systemFontOfSize:13];
    feed.textColor = [UIColor blackColor];
    feed.text = @"feed";
    [_feedButton addSubview:feed];
    UILabel *camera = [[UILabel alloc] initWithFrame:CGRectMake(35, -2, 70, 30)];
    camera.font = [UIFont systemFontOfSize:13];
    camera.textColor = [UIColor blackColor];
    camera.text = @"camera";
    [_cameraButton addSubview:camera];
    UILabel *notifications = [[UILabel alloc] initWithFrame:CGRectMake(30, -2, 110, 30)];
    notifications.font = [UIFont systemFontOfSize:13];
    notifications.textColor = [UIColor blackColor];
    notifications.text = @"notifications";
    [_notificationButton addSubview:notifications];
    _feedButton.translatesAutoresizingMaskIntoConstraints = YES;
    _cameraButton.translatesAutoresizingMaskIntoConstraints = YES;
    _notificationButton.translatesAutoresizingMaskIntoConstraints = YES;
    _chevron.translatesAutoresizingMaskIntoConstraints = YES;
    
    UIPanGestureRecognizer *rightGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragging:)];
    [self.view addGestureRecognizer:rightGesture];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self feedTappedAnimated:NO];
    [_blurView setBlurRadius:10];
    _blurView.alpha = 0.0;
    [_blurView setDynamic:NO];
    //[_chevron removeFromSuperview];
    //[self.view addSubview:_chevron];
    //_scrollView.contentSize = CGSizeMake(_scrollView.frame.size.width + 1, _scrollView.frame.size.height);
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

- (void)dragging:(UIPanGestureRecognizer *)recognizer {
    CGPoint newPoint = [recognizer locationInView:_contentView];
    
    if(recognizer.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Received a pan gesture");
        _blurView.dynamic = YES;
        //check to see if swipe is somewhere near the chevron
        if (CGRectContainsPoint(CGRectMake(0, 200, MAX(100, _chevron.frame.origin.x + _chevron.frame.size.width + 20), 568 - 200), newPoint)) {
            initialPoint = newPoint;
            validPan = YES;
        }
        actionForTouch = NO;
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        if (validPan) {
            //if the chevron is swiped far enough or to remove the menu
            if ((menuDisplayed || newPoint.x > PULL_THRESHOLD) && !animatingChevron) {
                [self menu];
            }
            //if chevron not swiped far enough
            else if (newPoint.x < PULL_THRESHOLD) {
                [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    _chevron.center = CGPointMake(21, _chevron.center.y);
                    _blurView.alpha = 0;
                } completion:nil];
            }
            validPan = NO;
        }
    }
    else {
        if (validPan && !animatingChevron) {
            if ((newPoint.x > PULL_THRESHOLD || menuDisplayed) && !actionForTouch) {
                animatingChevron = YES;
                [self menu];
                actionForTouch = YES;
            }
            else {
                float delta = newPoint.x-initialPoint.x;
                if (_chevron.center.x + delta > 10) {
                    _chevron.center = CGPointMake(_chevron.center.x + delta, _chevron.center.y);
                }
                initialPoint = newPoint;
                _blurView.alpha = newPoint.x/PULL_THRESHOLD;
            }
        }
    }
}

- (void)menu {
    if (menuDisplayed) {
        [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _notificationButton.center = CGPointMake(-_notificationButton.frame.size.width, _notificationButton.center.y);
            _cameraButton.center = CGPointMake(-_notificationButton.frame.size.width, _cameraButton.center.y);
            _feedButton.center = CGPointMake(-_feedButton.frame.size.width, _feedButton.center.y);
            _chevron.transform = CGAffineTransformIdentity;
            _chevron.center = CGPointMake(21, _chevron.center.y);
        } completion:^(BOOL completed) {
            animatingChevron = NO;
            _blurView.alpha = 0;
            _blurView.dynamic = NO;
        }];
    }
    else {
        [UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            int center = 55;
            _notificationButton.center = CGPointMake(center, _notificationButton.center.y);
            _cameraButton.center = CGPointMake(center, _cameraButton.center.y);
            _feedButton.center = CGPointMake(center, _feedButton.center.y);
            _chevron.transform = CGAffineTransformMakeRotation(M_PI);
            _chevron.center = CGPointMake(290, _chevron.center.y);
        } completion:^(BOOL completed) {
            animatingChevron = NO;
            _blurView.alpha = 1;
        }];
    }
    menuDisplayed = !menuDisplayed;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)mainTapped:(UIButton *)sender {
    _blurView.dynamic = !menuDisplayed;
    [self menu];
//    if (sender.tag == 100) {
//        _mainButton.hidden = NO;
//        [UIView animateWithDuration:.4 animations:^{
//            sender.alpha = 0.0;
//            _mainButton.alpha = 1.0;
//        }completion:^(BOOL isCompleted){
//            [sender removeFromSuperview];
//        }];
//        
//        
//        [UIView animateWithDuration:kAnimationTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//            _notificationButton.center = CGPointMake(_notificationButton.center.x - 110, _notificationButton.center.y);
//        }completion:nil];
//        
//        [UIView animateWithDuration:kAnimationTime delay:.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
//            _cameraButton.center = CGPointMake(_cameraButton.center.x - 110, _cameraButton.center.y);
//        }completion:nil];
//        
//        [UIView animateWithDuration:kAnimationTime delay:.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
//            _feedButton.center = CGPointMake(_feedButton.center.x - 110, _feedButton.center.y);
//        }completion:nil];
//    }
//    else {
//        UIButton *overlay = [UIButton buttonWithType:UIButtonTypeCustom];
//        overlay.backgroundColor = [UIColor colorWithWhite:.7 alpha:.5];
//        overlay.frame = self.view.bounds;
//        overlay.alpha = 0.0;
//        overlay.tag = 100;
//        [overlay addTarget:self action:@selector(mainTapped:) forControlEvents:UIControlEventTouchUpInside];
//        [self.view insertSubview:overlay atIndex:1];
//
//        
//        [UIView animateWithDuration:.4 animations:^{
//            overlay.alpha = 1.0;
//            _mainButton.alpha = 0.0;
//        }completion:^(BOOL isCompleted){
//            _mainButton.hidden = YES;
//        }];
//        
//        int offset = 7;
//        [UIView animateWithDuration:kAnimationTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//            _feedButton.center = CGPointMake(_feedButton.center.x + 110 + offset, _feedButton.center.y);
//        }completion:^(BOOL complation){
//             [UIView animateWithDuration:kAnimationTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//                 _feedButton.center = CGPointMake(_feedButton.center.x - offset, _feedButton.center.y);
//             }completion:nil];
//         }];
//        
//        [UIView animateWithDuration:kAnimationTime delay:.1 options:UIViewAnimationOptionCurveEaseOut animations:^{
//            _cameraButton.center = CGPointMake(_cameraButton.center.x + 110 + offset, _cameraButton.center.y);
//        }completion:^(BOOL complation){
//            [UIView animateWithDuration:kAnimationTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//                _cameraButton.center = CGPointMake(_cameraButton.center.x - offset, _cameraButton.center.y);
//            }completion:nil];
//        }];
//        
//        [UIView animateWithDuration:kAnimationTime delay:.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
//            _notificationButton.center = CGPointMake(_notificationButton.center.x + 110 + offset, _notificationButton.center.y);
//        }completion:^(BOOL complation){
//            [UIView animateWithDuration:kAnimationTime delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//                _notificationButton.center = CGPointMake(_notificationButton.center.x - offset, _notificationButton.center.y);
//            }completion:nil];
//        }];
//    }
    
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark - ViewController Selection

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
    [self menu];
    [self feedTappedAnimated:YES];
}

- (void)feedTappedAnimated:(BOOL)animated {
    if (!feedViewController) {
        feedViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Feed"];
    }
    if (animated) {
        UIView *overlay = [self.view viewWithTag:100];
        _chevron.hidden = NO;
        [UIView animateWithDuration:.4 animations:^{
            overlay.alpha = 0.0;
            _chevron.alpha = 1.0;
        }completion:^(BOOL isCompleted){
            [overlay removeFromSuperview];
            [self check];
            [_contentView insertSubview:feedViewController.view atIndex:0];
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
        [_contentView insertSubview:feedViewController.view atIndex:0];
    }
}

- (IBAction)cameraTapped:(id)sender {
    [self menu];
    UIView *overlay = [self.view viewWithTag:100];
    _chevron.hidden = NO;
    [UIView animateWithDuration:.4 animations:^{
        overlay.alpha = 0.0;
        _chevron.alpha = 1.0;
    }completion:^(BOOL isCompleted){
        [overlay removeFromSuperview];
        if (!uploadViewController) {
            uploadViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Upload"];
        }
        [self check];
        [_contentView insertSubview:uploadViewController.view atIndex:0];
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
    [self menu];
    UIView *overlay = [self.view viewWithTag:100];
    _chevron.hidden = NO;
    [UIView animateWithDuration:.4 animations:^{
        overlay.alpha = 0.0;
        _chevron.alpha = 1.0;
    }completion:^(BOOL isCompleted){
        [overlay removeFromSuperview];
        if (!notificationViewController) {
            notificationViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Notification"];
        }
        [self check];
        [_contentView insertSubview:notificationViewController.view atIndex:0];
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

//#pragma mark - UIScrollViewDelegate
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"OFF%f", scrollView.contentOffset.x);
//    _blurView.alpha = scrollView.contentOffset.x/scrollView.frame.size.width;
//}
@end
