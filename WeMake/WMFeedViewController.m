//
//  WMFeedViewController.m
//  WeMake
//
//  Created by Michael Scaria on 8/15/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//
#import <MediaPlayer/MediaPlayer.h>


#import "WMFeedViewController.h"

#import "WMModel.h"
#import "WMVideo.h"
#import "UIImageView+AFNetworking.h"

#import "WMVideoCell.h"

@interface WMFeedViewController ()

@end

@implementation WMFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    players = [[NSMutableArray alloc] init];
    [[WMModel sharedInstance] getPostsSuccess:^(NSArray *videos) {
        _videos = videos;
        [_tableView reloadData];
    } failure:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    if (players.count > 0) {
//        MPMoviePlayerController *player = players[0];
//        [player play];
//    }
	
}

- (void)viewDidDisappear:(BOOL)animated {
    for (MPMoviePlayerController *player in players) {
        [player pause];
    }
    [super viewDidDisappear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    [players removeAllObjects];
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _videos.count + 1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 28;
    }
    return 421;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WMVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Video"];
    if (cell == nil) {
        cell = [[WMVideoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Video"];
    }
    if (indexPath.row == 0) {
        for (UIView *view in cell.subviews) {
            [view removeFromSuperview];
        }
    }
    else {
        WMVideo *video = _videos[indexPath.row - 1];
        cell.url = [NSURL URLWithString:video.url];
        [cell.thumbnailView setImageWithURL:[NSURL URLWithString:video.thumbnailUrl]];
        [players addObject:cell.player];
        [cell setCreators:video.creators];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
@end
