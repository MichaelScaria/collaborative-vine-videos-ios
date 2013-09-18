//
//  WMVideoInfoView.m
//  WeMake
//
//  Created by Michael Scaria on 9/11/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import "WMVideoInfoView.h"

#import "UIImage+WeMake.h"
#import "FXBlurView.h"
#import "Constants.h"

@implementation WMVideoInfoView

- (void)setVideo:(WMVideo *)video
{
    _coverPhoto.image = [[UIImage imageNamed:@"graffitti"] blurredImageWithRadius:15 iterations:3];
    photo = [[WMCreatorPhotoView alloc] initWithUser:video.poster];
    photo.frame = CGRectMake(10, 10, 70, 70);
    [self addSubview:photo];
    
    _username.font = [UIFont fontWithName:@"Roboto-Light" size:26];
//    _username.backgroundColor = [UIColor greenColor];
//    _othersLabel.backgroundColor = [UIColor redColor];
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
    viewsLabel = [[UILabel alloc] initWithFrame:CGRectMake(_viewsButton.frame.origin.x + _viewsButton.frame.size.width + space, _likesButton.frame.origin.y, 30, 17)];
    likesLabel = [[UILabel alloc] initWithFrame:CGRectMake(_likesButton.frame.origin.x + _likesButton.frame.size.width + space, _likesButton.frame.origin.y, 30, 17)];
    commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_commentsButton.frame.origin.x + _commentsButton.frame.size.width + space, _likesButton.frame.origin.y, 30, 17)];
    viewsLabel.font = likesLabel.font = commentLabel.font = [UIFont fontWithName:@"Roboto-Light" size:12];
    viewsLabel.textColor = likesLabel.textColor = commentLabel.textColor = [UIColor whiteColor];
    viewsLabel.text = [NSString stringWithFormat:@"%d", video.views + 998];
    likesLabel.text = [NSString stringWithFormat:@"%d", video.likes.count];
    commentLabel.text = [NSString stringWithFormat:@"%d", video.comments.count];
    [self addSubview:viewsLabel];
    [self addSubview:likesLabel];
    [self addSubview:commentLabel];

//    [_likesButton addTarget:self action:@selector(like:) forControlEvents:UIControlEventTouchUpInside];
    if (video.liked) {
        liked = YES;
        [_likesButton setTitleColor:kColorLight forState:UIControlStateNormal];
        [_likesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    }
    
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
        _likesButton.transform = CGAffineTransformScale(_likesButton.transform, 1.4, 1.4);
    } completion:^(BOOL completed) {
        [UIView animateWithDuration: 0.15 delay: 0 options: UIViewAnimationOptionCurveEaseInOut animations:^{
            _likesButton.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}
@end
