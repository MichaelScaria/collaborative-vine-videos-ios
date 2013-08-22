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

#import "WMFeedCell.h"

@interface WMFeedViewController ()

@end

@implementation WMFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    indexes = [[NSMutableDictionary alloc] init];
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
    NSNumber *height = [indexes objectForKey:[NSString stringWithFormat:@"%d-%d", indexPath.section, indexPath.row]];
    if (height) return [height floatValue];
    return 500;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WMFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Feed"];
    if (cell == nil) {
        cell = [[WMFeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Feed"];
    }
    if (indexPath.row == 0) {
        for (UIView *view in cell.subviews) {
            [view removeFromSuperview];
        }
    }
    else {
        WMVideo *video = _videos[indexPath.row - 1];
        [cell setHeightChanged:^(int newHeight) {
            [indexes setObject:[NSNumber numberWithInt:newHeight] forKey:[NSString stringWithFormat:@"%d-%d", indexPath.section, indexPath.row]];
            [tableView beginUpdates];
            [tableView endUpdates];
        }];
        [cell setVideo:video];
        [players addObject:cell.player];
        //__weak WMFeedViewController *weakSelf = self;

    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
@end
