//
//  WMCreatorView.h
//  WeMake
//
//  Created by Michael Scaria on 8/19/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//
//  this view is to animate in when the user's clip is playing in a video

#import <UIKit/UIKit.h>

@interface WMCreatorView : UIView {
    UIImageView *creatorView;
    CGPoint initialPoint;
}
@property (nonatomic, strong) NSString *creatorUrl;
@end
