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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToCommentBubble:) name:@"ScrollToCommentBubble" object:nil];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ScrollToCommentBubble" object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    if (players.count > 0) {
//        MPMoviePlayerController *player = players[0];
//        [player play];
//    }
	
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (!commentScroll) {
//        //scrollView.scrollEnabled = NO;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveCommentView" object:nil];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//           // scrollView.scrollEnabled = YES;
//        });
//    }
//}
//
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
//    if (commentScroll) commentScroll = NO;
//}


- (void)viewDidDisappear:(BOOL)animated {
    for (MPMoviePlayerController *player in players) {
        [player pause];
    }
    [super viewDidDisappear:animated];
}

- (void)scrollToCommentBubble:(NSNotification *)notification {
    WMFeedCell *cell = (WMFeedCell *)notification.object;
    if (_tableView.contentOffset.y - cell.frame.origin.y < 225 ) {
        //get delta from how far the tableview has passed the origin.y of th cell, then subtract from 375 to get other half and add it to the current offset
        commentScroll = YES;
        [_tableView setContentOffset:CGPointMake(_tableView.contentOffset.x, _tableView.contentOffset.y + (225 - (_tableView.contentOffset.y - cell.frame.origin.y))) animated:YES];
    }
}

#pragma mark UITeableViewDataSource

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
        //set video last because  some objects need to be initialized i.e.^
        [cell setVideo:video];
        
        [players addObject:cell.player];
        //__weak WMFeedViewController *weakSelf = self;

    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
@end
