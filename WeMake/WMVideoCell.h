//
//  WMVideoCell.h
//  WeMake
//
//  Created by Michael Scaria on 8/17/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

#import "WMCreatorView.h"
#import "WMCreatorPhotoView.h"

#import "WMVideo.h"
#import "WMCreator.h"



@interface WMVideoCell : UITableViewCell {
    NSTimer *timer;
    WMCreator *currentCreator;
    BOOL creatorsShown;
    //for disclosure
    NSArray *cleanedCreators;
}
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSArray *creators;
@property (strong, nonatomic) MPMoviePlayerController *player;
@property (nonatomic, strong) WMVideo *video;

@property (strong, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (strong, nonatomic) IBOutlet WMCreatorView *creatorView;
@property (strong, nonatomic) IBOutlet WMCreatorPhotoView *posterImageView;
@property (strong, nonatomic) IBOutlet UILabel *posterLabel;
@property (strong, nonatomic) IBOutlet UIButton *disclosureIndicator;
@property (strong, nonatomic) IBOutlet UIImageView *viewsIcon;
@property (strong, nonatomic) IBOutlet UILabel *viewsLabel;
@property (strong, nonatomic) IBOutlet UIImageView *likesIcon;
@property (strong, nonatomic) IBOutlet UILabel *likesLabel;
@property (strong, nonatomic) IBOutlet UIImageView *commentsIcon;
@property (strong, nonatomic) IBOutlet UILabel *commentsLabel;

- (IBAction)disclose:(id)sender;
@end
