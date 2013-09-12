//
//  WMVideoInfoView.m
//  WeMake
//
//  Created by Michael Scaria on 9/11/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import "WMVideoInfoView.h"
#import "FXBlurView.h"

@implementation WMVideoInfoView

- (void)setUser:(WMUser *)user
{
    _coverPhoto.image = [[UIImage imageNamed:@"graffitti"] blurredImageWithRadius:15 iterations:3];
    photo = [[WMCreatorPhotoView alloc] initWithUser:user];
    photo.frame = CGRectMake(30, 20, 70, 70);
    [self addSubview:photo];
}

@end
