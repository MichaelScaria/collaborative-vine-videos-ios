//
//  WMVideoCell.m
//  WeMake
//
//  Created by Michael Scaria on 8/17/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import "WMFeedCell.h"

#import "Constants.h"
#import "UIImage+WeMake.h"

#import "MSTextView.h"
#import "UIImageView+AFNetworking.h"



#define kTimeInterval .05
#define kDisclosurePadding 5

@implementation WMFeedCell

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
        _disclosureIndicator.translatesAutoresizingMaskIntoConstraints = YES;
        CGSize size = [@"michaelscaria" sizeWithAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:13]}];
        _posterLabel.frame = CGRectMake(_posterLabel.frame.origin.x, _posterLabel.frame.origin.y, size.width, _posterLabel.frame.size.height);
        //disclosure button has padding to remove
        _disclosureIndicator.frame = CGRectMake(_posterLabel.frame.origin.x + size.width - kDisclosurePadding, _disclosureIndicator.frame.origin.y, _disclosureIndicator.frame.size.width, _disclosureIndicator.frame.size.height);
        //add view for comments if present
        if (video.comments.count > 0 || YES) {
            int height = self.frame.size.height;
            NSArray *commentPreviews;
            int offset = 0;
            int startPointY = 430;
            NSArray *u = @[@"michaelscaria", @"robinjoseph", @"adityavis"];
            UIButton *viewComments;
            if (video.comments.count > 2 || YES) {
                viewComments = [UIButton buttonWithType:UIButtonTypeCustom];
                [viewComments setTitle:@"view all 101 comments" forState:UIControlStateNormal];
                [viewComments.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13]];
                [viewComments addTarget:self action:@selector(viewAllComments) forControlEvents:UIControlEventTouchUpInside];
                NSArray *b = @[@"b", @"Totally awesome, I'm going to write a really long text string just to mess with butts", @"This is cool!", @"I'm digging it."];
                NSRange lastThree = {b.count - 3, 3};
                commentPreviews = [b subarrayWithRange:lastThree];
            }
            else {
                commentPreviews = @[@"michaelscaria", @"robinjoseph"];
            }
            int index = 0;
            for (NSString *body in commentPreviews) {
                MSTextView *textView = [[MSTextView alloc] initWithFrame:CGRectMake(5, startPointY + offset, 310, 35)];
                NSRange range = {0, [(NSString *)u[index] length]};
                [textView setText:[NSString stringWithFormat:@"%@ %@", u[index], body] withLinkedRange:range];
                [self addSubview:textView];
//                UIButton *username = [UIButton buttonWithType:UIButtonTypeCustom];
//                username.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//                username.frame = CGRectMake(10, startPointY + offset, 80, 18);
//                [username setTitle:u[index] forState:UIControlStateNormal];
//                [username.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:13]];
//                [self addSubview:username];
//                CGRect bounds = [body boundingRectWithSize:CGSizeMake(240, 35) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue" size:13]} context:nil];
//                NSLog(@"Boubds:%@", NSStringFromCGRect(bounds));
//                UILabel *comment = [[UILabel alloc] initWithFrame:CGRectMake(95, startPointY + offset, 210, bounds.size.height)];
//                comment.numberOfLines = 10;
//                comment.lineBreakMode = NSLineBreakByCharWrapping;
//                comment.backgroundColor = [UIColor clearColor];
//                comment.textColor = [UIColor colorWithRed:212/255.0 green:212/255.0 blue:212/255.0 alpha:1];
//                comment.text = body;
//                comment.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
//                [self addSubview:comment];
//                
                offset += textView.frame.size.height - 11;
                index++;
                height += textView.frame.size.height - 11;
            }
            if (viewComments) {
                viewComments.frame = CGRectMake(20, startPointY + offset + 8, 280, 20);
                [self addSubview:viewComments];
                offset += 35;
                height += 35;
            }
            UIButton *likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            likeButton.frame = CGRectMake(100, startPointY + offset, 25, 25);
            [likeButton setImage:[UIImage ipMaskedImageNamed:@"Like-Small" color:kColorGray] forState:UIControlStateNormal];
            [likeButton setImage:[UIImage ipMaskedImageNamed:@"Like-Small" color:kColorDark] forState:UIControlStateHighlighted];
            [likeButton addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:likeButton];
             height += 30;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .25 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                _heightChanged(height);
            });
            
            
        }
        //get all users in video except poster
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

- (void)viewAllComments {
    
}

- (void)like:(UIButton *)sender {
    liked = !liked;
    UIColor *oldColor, *newColor;
    int i = 1;
    if (liked) {
        newColor = kColorDark; oldColor = kColorGray;
    }
    else {
        newColor = kColorGray; oldColor = kColorDark;
        i *= -1;
    }
    _likesIcon.image = [UIImage ipMaskedImageNamed:@"Like-Small" color:newColor];
    int likes = [_likesLabel.text intValue];
    _likesLabel.text = [NSString stringWithFormat:@"%d", likes + i];
    _likesLabel.textColor = newColor;
    [sender setImage:[UIImage ipMaskedImageNamed:@"Like-Small" color:newColor] forState:UIControlStateNormal];
    [sender setImage:[UIImage ipMaskedImageNamed:@"Like-Small" color:oldColor] forState:UIControlStateHighlighted];
    [UIView animateWithDuration: 0.15 delay: 0 options: UIViewAnimationOptionCurveEaseOut animations:^{
        sender.transform = CGAffineTransformScale(sender.transform, 1.4, 1.4);
    } completion:^(BOOL completed) {
        [UIView animateWithDuration: 0.15 delay: 0 options: UIViewAnimationOptionCurveEaseInOut animations:^{
            sender.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
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
        [UIView animateWithDuration: 0.25 delay: 0 options: UIViewAnimationOptionCurveEaseIn animations:^{
            _disclosureIndicator.transform = CGAffineTransformIdentity;
            _disclosureIndicator.center = CGPointMake(173 - kDisclosurePadding, _disclosureIndicator.center.y);
            _posterLabel.alpha = 1;
            _viewsIcon.alpha = 1;
            _viewsLabel.alpha = 1;
            _likesIcon.alpha = 1;
            _likesLabel.alpha = 1;
            _commentsIcon.alpha = 1;
            _commentsLabel.alpha = 1;
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
        [UIView animateWithDuration:.25 delay:0 options: UIViewAnimationOptionCurveLinear animations:^{
            _disclosureIndicator.transform = CGAffineTransformMakeRotation (M_PI * 90 / 180.0f);
            _disclosureIndicator.center = CGPointMake(MIN(offsetX + 5, 310), _disclosureIndicator.center.y);
            _posterLabel.alpha = 0.0;
            _viewsIcon.alpha = 0.0;
            _viewsLabel.alpha = 0.0;;
            _likesIcon.alpha = 0.0;
            _likesLabel.alpha = 0.0;
            _commentsIcon.alpha = 0.0;
            _commentsLabel.alpha = 0.0;
        } completion:nil];
    }
    creatorsShown = !creatorsShown;

}
@end
