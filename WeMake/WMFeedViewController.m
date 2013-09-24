//
//  WMFeedViewController.m
//  WeMake
//
//  Created by Michael Scaria on 8/15/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//
#import <MediaPlayer/MediaPlayer.h>
#import <QuartzCore/QuartzCore.h>


#import "WMFeedViewController.h"

#import "WMModel.h"
#import "WMVideo.h"


@interface WMFeedViewController ()

@end

@implementation WMFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    indexes = [[NSMutableDictionary alloc] init];
    players = [[NSMutableArray alloc] init];
    [[WMModel sharedInstance] getPostsSuccess:^(NSArray *videos) {
//        _videos = videos;
        _videos = @[videos[0], videos[0], videos[0]];
        [_tableView reloadData];
    } failure:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToCommentBubble:) name:@"ScrollToCommentBubble" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollForCommentContent:) name:@"ScrollForCommentContent" object:nil];
    _headerView.layer.shadowColor = [UIColor blackColor].CGColor;
    _headerView.layer.masksToBounds = NO;
    _headerView.layer.shadowOffset = CGSizeMake(0, 1);
    _headerView.layer.shadowRadius = 3;
    _headerView.layer.shadowOpacity = .5;;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 62)];
//    view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    view.backgroundColor = [UIColor clearColor];
    _tableView.tableHeaderView = view;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ScrollToCommentBubble" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ScrollForCommentContent" object:nil];
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
    if (_tableView.contentOffset.y - cell.frame.origin.y < 235 ) {
        //get delta from how far the tableview has passed the origin.y of the cell, then subtract from 375 to get other half and add it to the current offset
        commentScroll = YES;
        [_tableView setContentOffset:CGPointMake(_tableView.contentOffset.x, _tableView.contentOffset.y + cell.frame.size.height/2) animated:YES];
    }
}

- (void)scrollForCommentContent:(NSNotification *)notification {
    [_tableView setContentOffset:CGPointMake(_tableView.contentOffset.x, _tableView.contentOffset.y + [notification.object intValue]) animated:YES];
}



//- (void)centerTable {
//    NSIndexPath *pathForCenterCell = [self.tableView indexPathForRowAtPoint:CGPointMake(CGRectGetMidX(self.tableView.bounds), CGRectGetMidY(self.tableView.bounds))];
//    
//    [self.tableView scrollToRowAtIndexPath:pathForCenterCell atScrollPosition:UITableViewScrollPositionTop animated:YES];
////    [_tableView setContentOffset:CGPointMake(0, _tableView.contentOffset.y + 62) animated:YES];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//        [_tableView setContentOffset:CGPointMake(0, _tableView.contentOffset.y - 62) animated:YES];
//        if (displayedCell) {
//            [displayedCell hide];
//        }
//        displayedCell = (WMFeedCell *)[_tableView cellForRowAtIndexPath:pathForCenterCell];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//            [displayedCell view];
//        });
//    });
//}
//
//#pragma mark UIScrollViewDelegate
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    // if decelerating, let scrollViewDidEndDecelerating: handle it
//    if (decelerate == NO) {
//        [self centerTable];
//    }
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    [self centerTable];
//}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    [players removeAllObjects];
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _videos.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *height = [indexes objectForKey:[NSString stringWithFormat:@"%d-%d", indexPath.section, indexPath.row]];
    if (height) return [height floatValue];
    return 506;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WMFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Feed"];
    if (cell == nil) {
        cell = [[WMFeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Feed"];
    }
    if (indexPath.row == 0 && NO) {
        for (UIView *view in cell.subviews) {
            [view removeFromSuperview];
        }
    }
    else {
        WMVideo *video = _videos[indexPath.row];
        [cell setHeightChanged:^(int newHeight, BOOL animated) {
            [indexes setObject:[NSNumber numberWithInt:newHeight] forKey:[NSString stringWithFormat:@"%d-%d", indexPath.section, indexPath.row]];
            if (animated) {
                [tableView beginUpdates];
                [tableView endUpdates];
            }
        }];
        //set video last because  some objects need to be initialized i.e.^
        [cell setVideo:video];

//        [cell.bubble setComment:^(NSString *comment, WMCommentCompletion completion) {
//            [[WMModel sharedInstance] comment:comment onVideo:video.theID success:^(WMInteraction *interaction){
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    completion(YES, interaction);
//                });
//            }failure:^{
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    completion(NO, nil);
//                });
//            }];
//        }];
        
        [cell setLiked:^(BOOL like){
            [[WMModel sharedInstance] like:like video:video.theID success:nil failure:nil];
        }];
        [cell setViewed:^{
            [[WMModel sharedInstance] viewedVideo:video.theID success:nil failure:nil];
        }];
        
        [players addObject:cell.player];
        //__weak WMFeedViewController *weakSelf = self;

    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
@end
