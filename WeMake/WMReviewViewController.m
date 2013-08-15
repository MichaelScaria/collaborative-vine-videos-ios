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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerLoadStateDidChange:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageRequestLoadFinished:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:nil];
    UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(140, 240, 40, 40)];
    aiv.tag = 10;
    [self.view addSubview:aiv];
    [aiv startAnimating];
}

- (void)playerLoadStateDidChange:(NSNotification *)notification
{
    if ((player.loadState & MPMovieLoadStatePlaythroughOK) == MPMovieLoadStatePlaythroughOK)
    {
        [player requestThumbnailImagesAtTimes:@[[NSNumber numberWithFloat:player.duration/2]] timeOption:MPMovieTimeOptionNearestKeyFrame];
    }
}

- (void)imageRequestLoadFinished:(NSNotification *)notification {
    UIImage *image = notification.userInfo[MPMoviePlayerThumbnailImageKey];
    if (image) {
        thumbnailImage = image;
        UIActivityIndicatorView *aiv = (UIActivityIndicatorView *)[self.view viewWithTag:11];
        if (aiv) {
            [aiv stopAnimating];
            [aiv removeFromSuperview];
            [self next:nil];
        }
    }
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
    if (thumbnailImage) {
        [player stop];
        [player.view removeFromSuperview];
        [self.delegate approvedWithThumbnail:thumbnailImage];
    }
    else {
        UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(140, 240, 40, 40)];
        aiv.tag = 11;
        [self.view addSubview:aiv];
        [aiv startAnimating];
    }
}

- (IBAction)back:(id)sender {
    [player stop];
    [player.view removeFromSuperview];
    [self.delegate back];
}
@end
