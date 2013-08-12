//
//  WMNotificationViewController.m
//  WeMake
//
//  Created by Michael Scaria on 7/31/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "WMNotificationViewController.h"
#import "WMTabBarController.h"
#import "WMNotificationCell.h"
#import "WMModel.h"
#import "WMRequest.h"
#import "WMInteraction.h"

#import "UIImageView+AFNetworking.h"


@interface WMNotificationViewController ()

@end

@implementation WMNotificationViewController

- (void)viewDidLoad
{
    
    selectedIndexes = [[NSMutableDictionary alloc] init];
//    [selectedIndexes setObject:@1 forKey:[NSIndexPath indexPathForRow:1 inSection:0]];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[WMModel sharedInstance] getNotificationsSuccess:^(NSArray *notifications){
        _notifications = notifications;
        dispatch_async(dispatch_get_main_queue(), ^{
            player = [[MPMoviePlayerController alloc] init];
            [player setRepeatMode:MPMovieRepeatModeOne];
            [player setFullscreen:NO];
            [player setControlStyle:MPMovieControlStyleNone];
            [player.view setFrame:CGRectMake(5, 45, 310, 310)];
            [player setScalingMode:MPMovieScalingModeAspectFill];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadStateChange:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
            [_tableView reloadData];
            
        });
    }failure:nil];
    
//    _notifications = @[
//                       [WMRequest requestWithDictionary:@{@"sent" : @{@"username" : @"robinjoseph", @"photo_url" : @"http://graph.facebook.com/580207324/picture?type=square&width=100&height=100&width=400&height=400"}, @"recipient" : @{@"username" : @"michaelscaria"}, @"status" : @0, @"created_at" : @1375928440, @"@video" : @{@"url" : @"https://s3.amazonaws.com/WeMake/users/1/2013-07-31%2023%3A04%3A11%20-0500/video-2.mov?AWSAccessKeyId=AKIAIAQUCYOECQCJOENA&Expires=2006481914&Signature=wyRbwYhgknxTKOnTD57zjjzzghM%3D"}}],
//                       [WMRequest requestWithDictionary:@{@"sent" : @{@"username" : @"robinjoseph", @"photo_url" : @"http://graph.facebook.com/580207324/picture?type=square&width=100&height=100&width=400&height=400"}, @"recipient" : @{@"username" : @"michaelscaria"}, @"status" : @0, @"created_at" : @1375928440, @"@video" : @{@"url" : @"https://s3.amazonaws.com/WeMake/users/1/2013-07-31%2023%3A04%3A11%20-0500/video-2.mov?AWSAccessKeyId=AKIAIAQUCYOECQCJOENA&Expires=2006481914&Signature=wyRbwYhgknxTKOnTD57zjjzzghM%3D"}}]
//                       ];
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    //dispatch_async(dispatch_get_main_queue(), ^{
//        player = [[MPMoviePlayerController alloc] init];
//        [player setRepeatMode:MPMovieRepeatModeOne];
//        [player setFullscreen:NO];
//        [player setControlStyle:MPMovieControlStyleNone];
//        [player.view setFrame:CGRectMake(5, 45, 310, 310)];
//        [player setScalingMode:MPMovieScalingModeAspectFill];
//    //});
//}

- (NSString *)simplifiedTimeWithEpochTime:(NSInteger)createdAt {
    NSString *time;
    NSDate *created = [NSDate dateWithTimeIntervalSince1970:createdAt];
    NSTimeInterval secondsElapsed = abs([created timeIntervalSinceNow]); //becuase we are looking at delta time
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    
    NSDate *date1 = [[NSDate alloc] init];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:secondsElapsed sinceDate:date1];
    
    // Get conversion to months, days, hours, minutes
    unsigned int unitFlags = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:date1  toDate:date2  options:0];
    
    if ([breakdownInfo day] > 0) {
        NSString *hour = ([breakdownInfo hour] > 0) ? [NSString stringWithFormat:@" %dh", [breakdownInfo hour]] : @"";
        time = [NSString stringWithFormat:@"%dd%@", [breakdownInfo day], hour];
    }
    else if ([breakdownInfo hour] > 0) {
        NSString *minute = ([breakdownInfo minute] > 0) ? [NSString stringWithFormat:@" %dm", [breakdownInfo minute]] : @"";
        time = [NSString stringWithFormat:@"%dh%@", [breakdownInfo hour], minute];
    }
    else if ([breakdownInfo minute] > 0) {
        NSString *second = ([breakdownInfo second] > 0) ? [NSString stringWithFormat:@" %ds", [breakdownInfo second]] : @"";
        time = [NSString stringWithFormat:@"%dm%@", [breakdownInfo minute], second];
    }
    else if ([breakdownInfo second] > 0) {
        time = [NSString stringWithFormat:@"%ds", [breakdownInfo second]];
    }
    else time = @"0s";
    return time;
}

- (BOOL)cellIsSelected:(NSIndexPath *)indexPath {
    NSLog(@"Row:%d", indexPath.row);
	// Return whether the cell at the specified index path is selected or not
	NSNumber *selectedIndex = [selectedIndexes objectForKey:[NSString stringWithFormat:@"%d-%d", indexPath.section, indexPath.row]];
	return !selectedIndex ? NO : [selectedIndex boolValue];
}

- (void)loadStateChange:(NSNotification *)n {
    //LATER - avoid flicker player.playbackState == 1 - http://stackoverflow.com/questions/6941734/putting-a-video-to-pause-state-before-playing
    MPMovieLoadState state = [(MPMoviePlayerController *)n.object loadState];
    if (state & (MPMovieLoadStatePlayable | MPMovieLoadStatePlaythroughOK)) {
        NSLog(@"%@", (state & MPMovieLoadStatePlayable) ? @"MPMovieLoadStatePlayable" : @"MPMovieLoadStatePlaythroughOK");
        UIActivityIndicatorView *aiv = (UIActivityIndicatorView *)[[(MPMoviePlayerController *)n.object view] viewWithTag:999];
        if (aiv) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [aiv stopAnimating];
                [aiv removeFromSuperview];
            });
        }
    }
    else if (state & MPMovieLoadStateStalled) {
        NSLog(@"MPMovieLoadStateStalled");
        if (![[(MPMoviePlayerController *)n.object view] viewWithTag:999]) {
            UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(135, 135, 40, 40)];
            //aiv.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
            aiv.tag = 999;
            [[(MPMoviePlayerController *)n.object view] addSubview:aiv];
            [aiv startAnimating];
        }
    }
}

- (void)accept:(UIButton *)accept {
    [player stop];
    WMRequest *request = [(WMNotificationCell *)accept.superview.superview request];
    [(WMTabBarController *)self.parentViewController presentCameraViewWithURL:request.video];
    NSLog(@"U:%@", request.sent.username);
}

- (void)reject:(UIButton *)reject {
    
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _notifications.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WMNotificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Notification"];
    if (cell == nil) {
        cell = [[WMNotificationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Notification"];
    }
    id notification = _notifications[indexPath.row];
    UIImageView *createdBy = (UIImageView*)[cell viewWithTag:1];
    createdBy.layer.cornerRadius = createdBy.frame.size.width/2;
    createdBy.layer.masksToBounds = YES;

    if ([notification isKindOfClass:[WMRequest class]]) {
        WMRequest *request = (WMRequest *)notification;
        cell.request = request;
        [createdBy setImageWithURL:[NSURL URLWithString:request.sent.photoURL] placeholderImage:[UIImage imageNamed:@"missingPhoto.png"]];
        UILabel *title = (UILabel*)[cell viewWithTag:2];
        title.frame = CGRectMake(title.frame.origin.x, title.frame.origin.y, title.frame.size.width + 50, title.frame.size.height);
        title.text = [NSString stringWithFormat:@"%@ wants to create a video with you.", request.sent.username];
        title.font = [UIFont systemFontOfSize:13];
        UILabel *time = (UILabel*)[cell viewWithTag:3];
        time.text = [self simplifiedTimeWithEpochTime:request.createdAt];
    }
    else {
        WMInteraction *interaction = (WMInteraction *)notification;
        [createdBy setImageWithURL:[NSURL URLWithString:interaction.createdBy.photoURL] placeholderImage:[UIImage imageNamed:@"missingPhoto.png"]];
        UILabel *title = (UILabel*)[cell viewWithTag:2];
        if (interaction.interactionType == WMFollow) {
            title.frame = CGRectMake(title.frame.origin.x, title.frame.origin.y, title.frame.size.width + 50, title.frame.size.height);
            title.text = [NSString stringWithFormat:@"%@ started following you.", interaction.createdBy.username];
        }
        UILabel *time = (UILabel*)[cell viewWithTag:3];
        time.text = [self simplifiedTimeWithEpochTime:interaction.createdAt];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // If our cell is selected, return double height
    if([self cellIsSelected:indexPath]) {
        return 410;
    }
    // Cell isn't selected so return single height
    return 48;
}

#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WMNotificationCell *cell = (WMNotificationCell *)[tableView cellForRowAtIndexPath:indexPath];
    id notification = _notifications[indexPath.row];
    if ([notification isKindOfClass:[WMRequest class]]) {
        //toggle selected state for cell
        BOOL isSelected = ![self cellIsSelected:indexPath];
        for (NSString *key in [selectedIndexes copy]) {
            [selectedIndexes setObject:@NO forKey:key];
        }
        NSNumber *selectedIndex = [NSNumber numberWithBool:isSelected];
        [selectedIndexes enumerateKeysAndObjectsUsingBlock:^(id key, id value, BOOL *stop) {
            NSLog(@"key:%@ value:%@", key, value);
        }];
        [selectedIndexes setObject:selectedIndex forKey:[NSString stringWithFormat:@"%d-%d", indexPath.section, indexPath.row]];
        
        //preview video
        if (isSelected) {
            cell.request = (WMRequest *)notification;
            [player setContentURL:[NSURL URLWithString:cell.request.video.url]];
            [player prepareToPlay];
            [player play];
            [player setShouldAutoplay:YES];
            [cell addSubview:player.view];
            UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(135, 135, 40, 40)];
            aiv.tag = 999;
            [player.view addSubview:aiv];
            [aiv startAnimating];
            [cell addAcceptButton];
            [cell.accept addTarget:self action:@selector(accept:)forControlEvents:UIControlEventTouchUpInside];
            [cell addRejectButton];
            [cell.reject addTarget:self action:@selector(reject:)forControlEvents:UIControlEventTouchUpInside];
        }
        else {
            [cell.accept removeFromSuperview];
            [cell.reject removeFromSuperview];
            [player stop];
            [player.view removeFromSuperview];
        }
        [tableView beginUpdates];
        [tableView endUpdates];
    }
    
}

@end
