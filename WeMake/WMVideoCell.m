//
//  WMVideoCell.m
//  WeMake
//
//  Created by Michael Scaria on 8/17/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import "WMVideoCell.h"


#define kTimeInterval .05

@implementation WMVideoCell

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    UIView *aView = [[UIView alloc] initWithFrame:_player.view.bounds];
    [aView addGestureRecognizer:tapGesture];
    [_player.view addSubview:aView];
}

- (void)tapped:(UIGestureRecognizer *)gestureRecognizer {
    
    if ((_player.playbackState & MPMoviePlaybackStatePlaying) == MPMoviePlaybackStatePlaying) {
        [_player pause];
        if ([timer isValid]) [timer invalidate];
    }
    else {
        [_player play];
        timer = [NSTimer scheduledTimerWithTimeInterval:kTimeInterval target:self selector:@selector(time) userInfo:nil repeats:YES];
        [timer fire];
    }
}

- (void)time {
    NSTimeInterval currentTime = _player.currentPlaybackTime;
    WMCreator *newCreator;
    for (WMCreator *creator in _creators) {
        if (creator.startTime <= currentTime && currentTime  <= creator.startTime + creator.length) {
            currentCreator = creator;
            break;
        }
    }
    if (currentCreator.photoURL) {
        [_creatorView setCreatorUrl:currentCreator.photoURL];
    }    
    
}

- (void)playerLoadStateDidChange:(NSNotification *)notification
{
    if ((_player.loadState & MPMovieLoadStatePlaythroughOK) == MPMovieLoadStatePlaythroughOK) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:nil];
        UIActivityIndicatorView *aiv = (UIActivityIndicatorView *)[self viewWithTag:10];
        if (aiv) {
            [aiv stopAnimating];
            [aiv removeFromSuperview];
        }
        NSMutableArray *times = [[NSMutableArray alloc] initWithCapacity:_player.duration/2];
        for (int i = 1; i < _player.duration; i += 2) {
            [times addObject:[NSNumber numberWithInt:i]];
        }
        [_player requestThumbnailImagesAtTimes:times timeOption:MPMovieTimeOptionNearestKeyFrame];
    }
    else if ((_player.loadState & MPMovieLoadStateStalled) == MPMovieLoadStateStalled) {
        UIActivityIndicatorView *aiv = (UIActivityIndicatorView *)[self viewWithTag:10];
        if (!aiv) {
            aiv = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(140, 190, 40, 40)];
            aiv.tag = 10;
            [self addSubview:aiv];
            [aiv startAnimating];
        }
    }
    if ((_player.playbackState & MPMoviePlaybackStatePlaying) == MPMoviePlaybackStatePlaying) {
        if ([_thumbnailView isDescendantOfView:self]) {
            [_thumbnailView removeFromSuperview];
        }
    }
    else if ((_player.playbackState & MPMoviePlaybackStatePaused) == MPMoviePlaybackStatePaused) {
        [self addSubview:_thumbnailView];
    }
}

- (void)imageRequestLoadFinished:(NSNotification *)notification {
//    UIImage *image = notification.userInfo[MPMoviePlayerThumbnailImageKey];
//    if (image) {
//        thumbnailImage = image;
//        UIActivityIndicatorView *aiv = (UIActivityIndicatorView *)[self.view viewWithTag:11];
//        if (aiv) {
//            [aiv stopAnimating];
//            [aiv removeFromSuperview];
//            [self next:nil];
//        }
//    }
}

- (void)setUrl:(NSURL *)url {
    if (url != _url) {
//        UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(140, 190, 40, 40)];
//        aiv.tag = 10;
//        [self addSubview:aiv];
//        [aiv startAnimating];
        
        _url = url;
        if (!_player) {
            _player = [[MPMoviePlayerController alloc] init];
            [_player setShouldAutoplay:YES];
            [_player setRepeatMode:MPMovieRepeatModeOne];
            [_player setFullscreen:NO];
            [_player setControlStyle:MPMovieControlStyleNone];
            [_player setScalingMode:MPMovieScalingModeAspectFill];
            _player.view.frame = _thumbnailView.frame;
            [self.contentView insertSubview:_player.view atIndex:0];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerLoadStateDidChange:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageRequestLoadFinished:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:nil];
        }
        [_player setContentURL:url];
        //[_player prepareToPlay];
    }
}

@end
