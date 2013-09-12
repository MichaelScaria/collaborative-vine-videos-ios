//
//  WMVideoInfoView.h
//  WeMake
//
//  Created by Michael Scaria on 9/11/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WMUser.h"

#import "WMCreatorPhotoView.h"

@interface WMVideoInfoView : UIView {
    WMCreatorPhotoView *photo;
}

@property (strong, nonatomic) IBOutlet UIImageView *coverPhoto;

- (void)setUser:(WMUser *)user;

@end
