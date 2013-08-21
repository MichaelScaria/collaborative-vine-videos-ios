//
//  WMVideoCell.m
//  WeMake
//
//  Created by Michael Scaria on 8/17/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import "WMVideoCell.h"

#import "UIImageView+AFNetworking.h"



#define kTimeInterval .05
#define kDisclosurePadding 5

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
    if (_player.playbackState & MPMoviePlaybackStatePlaying) {
        NSTimeInterval currentTime = _player.currentPlaybackTime;
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

- (void)setCreators:(NSArray *)creators {
    if (![creators isEqualToArray:_creators]) {
        _creators = creators;
//        WMCreator *firstCreator = _creators[0];
//        [_creatorView setCreatorUrl:firstCreator.photoURL];
    }
}

- (void)setVideo:(WMVideo *)video {
    if (video != _video) {
        _video = video;
        self.url = [NSURL URLWithString:_video.url];
        
        [_thumbnailView setImageWithURL:[NSURL URLWithString:video.thumbnailUrl]];
        self.creators = video.creators;
        [_posterImageView setUser:video.poster];
        _posterLabel.translatesAutoresizingMaskIntoConstraints =
        _disclosureIndicator.translatesAutoresizingMaskIntoConstraints =
        _viewsIcon.translatesAutoresizingMaskIntoConstraints =
        _viewsLabel.translatesAutoresizingMaskIntoConstraints =
        _likesIcon.translatesAutoresizingMaskIntoConstraints =
        _likesLabel.translatesAutoresizingMaskIntoConstraints =
        _commentsIcon.translatesAutoresizingMaskIntoConstraints =
        _commentsLabel.translatesAutoresizingMaskIntoConstraints =YES;
        CGSize size = [@"michaelscaria" sizeWithAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:13], NSForegroundColorAttributeName : [UIColor colorWithRed:212/255.0 green:212/255.0 blue:212/255.0 alpha:1]}];
        NSLog(@"Size:%f", size.width);
        _posterLabel.frame = CGRectMake(_posterLabel.frame.origin.x, _posterLabel.frame.origin.y, size.width, _posterLabel.frame.size.height);
        //disclosure button has padding to remove
        _disclosureIndicator.frame = CGRectMake(_posterLabel.frame.origin.x + size.width - kDisclosurePadding, _disclosureIndicator.frame.origin.y, _disclosureIndicator.frame.size.width, _disclosureIndicator.frame.size.height);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (!cleanedCreators) {
                NSMutableArray *mutableCleanedCreators = [[NSMutableArray alloc] initWithArray:_creators copyItems:NO];
                NSMutableArray *usernames = [[NSMutableArray alloc] initWithCapacity:_creators.count];
                for (WMCreator *creator in _creators) {
                    if ([usernames containsObject:creator.username] || [creator.username isEqualToString:@"michaelscaria"]) {
                        [mutableCleanedCreators removeObject:creator];
                    }
                    else [usernames addObject:creator.username];
                }
                cleanedCreators = (NSArray *)mutableCleanedCreators;
            }
        });
    }
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

- (IBAction)disclose:(id)sender {
    NSLog(@"%f", self.center.x);
    if (creatorsShown) {
        float delay = 0.0;
        for (int i = 0; i < cleanedCreators.count; i++) {
            UIView *view = [self viewWithTag:i + 60];
            if (view) {
                [UIView animateWithDuration:.25 delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
                    view.center = CGPointMake(view.center.x, view.center.y + 50);
                    view.alpha = 0;
                }completion:^(BOOL completed) {
                    [view removeFromSuperview];
                }];
                delay += .15;
            }
        }
        int offset = 25;
        [UIView animateWithDuration: 0.25 delay: 0 options: UIViewAnimationOptionCurveEaseIn animations:^{
            _disclosureIndicator.transform = CGAffineTransformIdentity;
            _disclosureIndicator.center = CGPointMake(173 - kDisclosurePadding, _disclosureIndicator.center.y);
            _posterLabel.alpha = 1;
            _viewsIcon.center = CGPointMake(_viewsIcon.center.x , _viewsIcon.center.y - offset);
            _viewsLabel.center = CGPointMake(_viewsLabel.center.x, _viewsLabel.center.y - offset);
            _likesIcon.center = CGPointMake(_likesIcon.center.x, _likesIcon.center.y - offset);
            _likesLabel.center = CGPointMake(_likesLabel.center.x, _likesLabel.center.y - offset);
            _commentsIcon.center = CGPointMake(_commentsIcon.center.x, _commentsIcon.center.y - offset);
            _commentsLabel.center = CGPointMake(_commentsLabel.center.x, _commentsLabel.center.y - offset);
        } completion: nil];
        
    }
    else {
        float leftMargin = _posterImageView.frame.origin.x;
        float width =  _posterImageView.frame.size.width;
        float gutter = MIN(320 / (cleanedCreators.count + 1), 10);
        NSLog(@"Gutter:%f", gutter);
        float offsetX = leftMargin + width + gutter;
        float offsetY = _posterImageView.frame.origin.y;
        int tag = 60;
        float delay = 0.0;
        for (WMCreator *user in cleanedCreators) {
            WMCreatorPhotoView *photoView = [[WMCreatorPhotoView alloc] initWithUser:user];
            photoView.frame = CGRectMake(offsetX, offsetY + 50, width, width);
            photoView.tag = tag;
            photoView.alpha = 0;
            [self addSubview:photoView];
            offsetX += width + gutter;
            tag++;
            [UIView animateWithDuration:.25 delay:delay options:UIViewAnimationOptionCurveEaseOut animations:^{
                photoView.center = CGPointMake(photoView.center.x, photoView.center.y - 50);
                photoView.alpha = 1;
            }completion:nil];
            delay += .15;
        }
        int offset = 25;
        [UIView animateWithDuration:.25 delay:0 options: UIViewAnimationOptionCurveLinear animations:^{
            _disclosureIndicator.transform = CGAffineTransformMakeRotation (M_PI * 90 / 180.0f);
            _disclosureIndicator.center = CGPointMake(MIN(offsetX + 5, 310), _disclosureIndicator.center.y);
            _posterLabel.alpha = 0.0;
            _viewsIcon.center = CGPointMake(_viewsIcon.center.x, _viewsIcon.center.y + offset);
            _viewsLabel.center = CGPointMake(_viewsLabel.center.x, _viewsLabel.center.y + offset);
            _likesIcon.center = CGPointMake(_likesIcon.center.x, _likesIcon.center.y + offset);
            _likesLabel.center = CGPointMake(_likesLabel.center.x, _likesLabel.center.y + offset);
            _commentsIcon.center = CGPointMake(_commentsIcon.center.x, _commentsIcon.center.y + offset);
            _commentsLabel.center = CGPointMake(_commentsLabel.center.x, _commentsLabel.center.y + offset);
        } completion:nil];
    }
    creatorsShown = !creatorsShown;

}
@end
