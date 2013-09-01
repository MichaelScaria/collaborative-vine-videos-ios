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
#import "WMCommentBubble.h"


#import "WMVideo.h"
#import "WMCreator.h"

typedef void(^WMHeightChanged)(int, BOOL);
typedef void(^WMLiked)();
//typedef void(^WMComment)(NSString *);

@interface WMFeedCell : UITableViewCell <WMCommentBubbleDelegate> {
    NSTimer *timer;
    WMCreator *currentCreator;
    BOOL creatorsShown;
    BOOL liked;
    BOOL commentViewDisplayed;
    CAShapeLayer *commentBubble;
    CGRect commentFrame;
    //for disclosure
    NSArray *cleanedCreators;
}
@property (nonatomic, copy) WMHeightChanged heightChanged;
@property (nonatomic, copy) WMLiked liked;
//@property (nonatomic, copy) WMComment comment;

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSArray *creators;
@property (strong, nonatomic) MPMoviePlayerController *player;
@property (nonatomic, strong) WMVideo *video;
@property (nonatomic, strong) WMCommentBubble *bubble;
@property (nonatomic, strong) NSMutableArray *commentViews;

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
@property (strong, nonatomic) IBOutlet UITextView *caption;

- (IBAction)disclose:(id)sender;
@end
