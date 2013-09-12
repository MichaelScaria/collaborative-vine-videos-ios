//
//  WMCreatorPhotoView.m
//  WeMake
//
//  Created by Michael Scaria on 8/19/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import "WMCreatorPhotoView.h"

#import "UIImageView+AFNetworking.h"

@implementation WMCreatorPhotoView

- (id)initWithUser:(WMUser *)user {
    self = [super init];
    if (self) {
        self.user = user;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    self.layer.cornerRadius = self.frame.size.width/2;
    self.layer.masksToBounds = YES;
}

- (void)setUser:(WMUser *)user {
    if (user != _user) {
        _user = user;
        NSString *p = (_user) ? _user.photoURL : @"http://graph.facebook.com/1679449736/picture?type=square&width=100&height=100&width=400&height=400";
        [self setImageWithURL:[NSURL URLWithString:p] placeholderImage:[UIImage imageNamed:@"missingPhoto"]];

    }
    else {
        //HACK
        NSString *p = (_user) ? _user.photoURL : @"http://graph.facebook.com/1679449736/picture?type=square&width=100&height=100&width=400&height=400";
        [self setImageWithURL:[NSURL URLWithString:p] placeholderImage:[UIImage imageNamed:@"missingPhoto"]];
    }
}
@end
