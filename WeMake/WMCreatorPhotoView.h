//
//  WMCreatorPhotoView.h
//  WeMake
//
//  Created by Michael Scaria on 8/19/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//
//  Easy user photo view with user instantiation

#import <UIKit/UIKit.h>

#import "WMUser.h"

@interface WMCreatorPhotoView : UIImageView
@property (nonatomic, strong) WMUser *user;

- (id)initWithUser:(WMUser *)user;
@end
