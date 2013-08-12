//
//  WMReviewViewController.m
//  WeMake
//
//  Created by Michael Scaria on 7/25/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import "WMReviewViewController.h"

@interface WMReviewViewController ()

@end

@implementation WMReviewViewController
@synthesize delegate, url = _url;

- (void)viewDidLoad {
    [super viewDidLoad];
    player = [[MPMoviePlayerController alloc] init];
    [player setShouldAutoplay:YES];
    [player setRepeatMode:MPMovieRepeatModeOne];
    [player setFullscreen:NO];
    [player setControlStyle:MPMovieControlStyleNone];
    [player.view setFrame:CGRectMake(0, 100, 320, 320)];
    [player setScalingMode:MPMovieScalingModeAspectFill];
    
    UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(140, 240, 40, 40)];
    aiv.tag = 10;
    [self.view addSubview:aiv];
    [aiv startAnimating];
}

- (void)setUrl:(NSURL *)url {
    if (url != _url) {
        UIActivityIndicatorView *aiv = (UIActivityIndicatorView *)[self.view viewWithTag:10];
        if (aiv) {
            [aiv stopAnimating];
            [aiv removeFromSuperview];
        }
        _url = url;
        [player setContentURL:url];
        [player prepareToPlay];
        [player play];
        [self.view addSubview:player.view];
    }
}

- (IBAction)next:(id)sender {
    [player stop];
    [player.view removeFromSuperview];
    [self.delegate approved];
}

- (IBAction)back:(id)sender {
    [player stop];
    [player.view removeFromSuperview];
    [self.delegate back];
}
@end
