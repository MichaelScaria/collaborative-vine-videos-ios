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

- (void)setUrl:(NSURL *)url {
    if (url != _url) {
        _url = url;
        player = [[MPMoviePlayerController alloc] initWithContentURL:url];
        [player setShouldAutoplay:YES];
        [player setRepeatMode:MPMovieRepeatModeOne];
        [player setFullscreen:NO];
        [player setControlStyle:MPMovieControlStyleNone];
        [player.view setFrame:CGRectMake(0, 100, 320, 320)];  // player's frame must match parent's
        [player setScalingMode:MPMovieScalingModeAspectFill];
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
