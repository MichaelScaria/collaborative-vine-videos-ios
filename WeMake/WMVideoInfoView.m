//
//  WMVideoInfoView.m
//  WeMake
//
//  Created by Michael Scaria on 9/11/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import "WMVideoInfoView.h"

#import "UIImage+WeMake.h"
#import "Constants.h"
#import "WMInteraction.h"

#import "FXBlurView.h"
#import "MSTextView.h"


@implementation WMVideoInfoView

- (void)setVideo:(WMVideo *)video
{
//    _coverPhoto.image = [[UIImage imageNamed:@"graffitti"] blurredImageWithRadius:20 iterations:3];
    photo = [[WMCreatorPhotoView alloc] initWithUser:video.poster];
    photo.frame = CGRectMake(8, 10, 70, 70);
    [_scrollView addSubview:photo];
    
    _username.font = [UIFont fontWithName:@"Roboto-Light" size:26];
    [_username sizeToFit];
    if (video.creators.count > 1) {
        _othersLabel.translatesAutoresizingMaskIntoConstraints = YES;
        _othersLabel.font = [UIFont fontWithName:@"Roboto-Light" size:12];
        _othersLabel.text = [NSString stringWithFormat:@"with %d other%@", video.creators.count - 1, video.creators.count > 2 ? @"s" : @""];
        [_othersLabel sizeToFit];
        _othersLabel.center = CGPointMake(_username.center.x, 60);
    }
    else {
        [_othersLabel removeFromSuperview];
    }
    int space = 5;
    viewsLabel = [[UILabel alloc] initWithFrame:CGRectMake(_viewsImage.frame.origin.x + _viewsImage.frame.size.width + space, _likesButton.frame.origin.y, 30, 17)];
    likesLabel = [[UILabel alloc] initWithFrame:CGRectMake(_likesButton.frame.origin.x + _likesButton.frame.size.width + space, _likesButton.frame.origin.y, 30, 17)];
    commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_commentsButton.frame.origin.x + _commentsButton.frame.size.width + space, _likesButton.frame.origin.y, 30, 17)];
    viewsLabel.font = likesLabel.font = commentLabel.font = [UIFont fontWithName:@"Roboto-Light" size:12];
    viewsLabel.textColor = likesLabel.textColor = commentLabel.textColor = [UIColor whiteColor];
    viewsLabel.text = [NSString stringWithFormat:@"%d", video.views + 998];
    likesLabel.text = [NSString stringWithFormat:@"%d", video.likes.count];
    commentLabel.text = [NSString stringWithFormat:@"%d", video.comments.count];
    [_scrollView addSubview:viewsLabel];
    [_scrollView addSubview:likesLabel];
    [_scrollView addSubview:commentLabel];

    if (video.liked) {
        liked = YES;
        [_likesButton setTitleColor:kColorLight forState:UIControlStateNormal];
        [_likesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    }
    
    _likesButton.translatesAutoresizingMaskIntoConstraints = YES;
    _commentsButton.translatesAutoresizingMaskIntoConstraints = YES;
    
    int offset = 115;
    int limit = 3;
    for (WMInteraction *comment in video.comments) {
        if (limit > 0) {
            MSTextView *textView = [[MSTextView alloc] initWithFrame:CGRectMake(70, offset, 240, 35)];
            NSRange range = {0, [(NSString *)comment.createdBy.username length]};
            [textView setText:[NSString stringWithFormat:@"%@ %@", comment.createdBy.username, comment.body] withLinkedRange:range];
            [_scrollView addSubview:textView];
            offset += textView.frame.size.height - 7;
            limit--;
        }
        else break;
        
    }
    _scrollView.contentSize = CGSizeMake(0, offset + 50);
    _scrollView.delegate = self;
    
}



- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    _scrollView.scrollEnabled = YES;
    
    UIView *clearView = [[UIView alloc] initWithFrame:self.bounds];
    clearView.backgroundColor = [UIColor clearColor];
    clearView.userInteractionEnabled = NO;
    [self addSubview:clearView];
    
    CAGradientLayer *l = [CAGradientLayer layer];
    l.frame = self.bounds;
    l.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor, (id)[UIColor clearColor].CGColor, nil];
    l.startPoint = CGPointMake(0.5f, 0.75f);
    l.endPoint = CGPointMake(0.5f, -0.25f);
    clearView.layer.mask = l;
}



- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
}

- (IBAction)like:(UIButton *)sender {
    liked = !liked;
    //_liked(liked);
    UIColor *newLabelColor, *oldLabelColor;
    int i = 1;
    if (liked) {
        newLabelColor = kColorLight; oldLabelColor = [UIColor whiteColor];
    }
    else {
        newLabelColor = [UIColor whiteColor]; oldLabelColor = kColorLight;
        i *= -1;
    }
    int likes = [likesLabel.text intValue];
    likesLabel.text = [NSString stringWithFormat:@"%d", likes + i];
    [_likesButton setTitleColor:newLabelColor forState:UIControlStateNormal];
    [_likesButton setTitleColor:oldLabelColor forState:UIControlStateHighlighted];
    [UIView animateWithDuration: 0.15 delay: 0 options: UIViewAnimationOptionCurveEaseOut animations:^{
        _likesButton.transform = CGAffineTransformScale(_likesButton.transform, 1.5, 1.5);
    } completion:^(BOOL completed) {
        [UIView animateWithDuration: 0.15 delay: 0 options: UIViewAnimationOptionCurveEaseInOut animations:^{
            _likesButton.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

- (IBAction)comment:(UIButton *)sender {
}
@end
