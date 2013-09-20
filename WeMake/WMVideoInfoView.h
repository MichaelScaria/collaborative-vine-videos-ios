//
//  WMVideoInfoView.h
//  WeMake
//
//  Created by Michael Scaria on 9/11/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WMUser.h"
#import "WMVideo.h"

#import "WMCreatorPhotoView.h"

@interface WMVideoInfoView : UIView {
    WMCreatorPhotoView *photo;
    BOOL liked;
    UILabel *viewsLabel;
    UILabel *likesLabel;
    UILabel *commentLabel;
}

@property (strong, nonatomic) IBOutlet UIImageView *coverPhoto;
@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UILabel *othersLabel;
@property (strong, nonatomic) IBOutlet UIButton *viewsButton;
@property (strong, nonatomic) IBOutlet UIButton *likesButton;
@property (strong, nonatomic) IBOutlet UIButton *commentsButton;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;


- (void)setVideo:(WMVideo *)video;
- (void)like;
- (IBAction)like:(UIButton *)sender;
- (IBAction)comment:(UIButton *)sender;

@end
