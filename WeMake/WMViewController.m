//
//  WMViewController.m
//  WeMake
//
//  Created by Michael Scaria on 8/16/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import "WMViewController.h"

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
    UIImageView *redCircle = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,20,20)];
    redCircle.image = [UIImage imageNamed:@"redCircle"];
    UIImageView *redCircle2 = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,20,20)];
    redCircle2.image = [UIImage imageNamed:@"redCircle"];
    UIImageView *redCircle3 = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,20,20)];
    redCircle3.image = [UIImage imageNamed:@"redCircle"];
    [_feedButton addSubview:redCircle];
    [_cameraButton addSubview:redCircle2];
    [_notificationButton addSubview:redCircle3];
    UILabel *feed = [[UILabel alloc] initWithFrame:CGRectMake(22, -2, 70, 20)];
    feed.font = [UIFont systemFontOfSize:12];
    feed.text = @"feed";
    [_feedButton addSubview:feed];
    UILabel *camera = [[UILabel alloc] initWithFrame:CGRectMake(22, -2, 70, 20)];
    camera.font = [UIFont systemFontOfSize:12];
    camera.text = @"camera";
    [_cameraButton addSubview:camera];
    UILabel *notifications = [[UILabel alloc] initWithFrame:CGRectMake(22, -2, 70, 20)];
    notifications.font = [UIFont systemFontOfSize:12];
    notifications.text = @"notifications";
    [_notificationButton addSubview:notifications];
    _feedButton.translatesAutoresizingMaskIntoConstraints = YES;
    _cameraButton.translatesAutoresizingMaskIntoConstraints = YES;
    _notificationButton.translatesAutoresizingMaskIntoConstraints = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

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
        [UIView animateWithDuration:.7 animations:^{
            sender.alpha = 0.0;
            _mainButton.alpha = 1.0;
        }completion:^(BOOL isCompleted){
            [sender removeFromSuperview];
        }];
        [UIView animateWithDuration:.5 animations:^{
            //_feedButton.center = CGPointMake(_feedButton.center.x - 110, _feedButton.center.y);
            //_cameraButton.center = CGPointMake(_cameraButton.center.x - 110, _cameraButton.center.y);
            _notificationButton.center = CGPointMake(_notificationButton.center.x - 110, _notificationButton.center.y);

            sender.alpha = 0.0;
            _mainButton.alpha = 1.0;
        }completion:^(BOOL isCompleted){
            [sender removeFromSuperview];
        }];
        [UIView animateWithDuration:.5 delay:.1 options:UIViewAnimationCurveLinear animations:<#^(void)animations#> completion:<#^(BOOL finished)completion#>
    }
    else {
        UIButton *overlay = [UIButton buttonWithType:UIButtonTypeCustom];
        overlay.backgroundColor = [UIColor colorWithWhite:.7 alpha:.5];
        overlay.frame = self.view.bounds;
        overlay.alpha = 0.0;
        overlay.tag = 100;
        [overlay addTarget:self action:@selector(mainTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.view insertSubview:overlay atIndex:0];
        NSLog(@"BC:%@", NSStringFromCGPoint(_feedButton.center));
        [UIView animateWithDuration:.5 animations:^{
            [_feedButton setCenter:CGPointMake(_feedButton.center.x + 110, _feedButton.center.y)];
            _cameraButton.center = CGPointMake(_cameraButton.center.x + 110, _cameraButton.center.y);
            _notificationButton.center = CGPointMake(_notificationButton.center.x + 110, _notificationButton.center.y);
            overlay.alpha = 1.0;
            _mainButton.alpha = 0.0;
        }completion:^(BOOL isCompleted){
            NSLog(@"C:%@", NSStringFromCGPoint(_feedButton.center));
            _mainButton.hidden = YES;
        }];
    }
    
    
}

- (IBAction)feedTapped:(id)sender {
}

- (IBAction)cameraTapped:(id)sender {
}

- (IBAction)notificationTapped:(id)sender {
}
@end
