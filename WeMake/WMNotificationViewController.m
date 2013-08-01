//
//  WMNotificationViewController.m
//  WeMake
//
//  Created by Michael Scaria on 7/31/13.
//  Copyright (c) 2013 michaelscaria. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "WMNotificationViewController.h"
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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[WMModel sharedInstance] getNotificationsSuccess:^(NSArray *notifications){
        _notifications = @[notifications[0], notifications[0]];
        dispatch_async(dispatch_get_main_queue(), ^{
            player = [[MPMoviePlayerController alloc] init];
            [player setRepeatMode:MPMovieRepeatModeOne];
            [player setFullscreen:NO];
            [player setControlStyle:MPMovieControlStyleNone];
            [player.view setFrame:CGRectMake(5, 45, 310, 310)];
            [player setScalingMode:MPMovieScalingModeAspectFill];
            [_tableView reloadData];
        });
    }failure:nil];
}

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
	// Return whether the cell at the specified index path is selected or not
	NSNumber *selectedIndex = [selectedIndexes objectForKey:indexPath];
	return !selectedIndex ? NO : [selectedIndex boolValue];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _notifications.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Notification"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Notification"];
    }
    id notification = _notifications[indexPath.row];
    UIImageView *createdBy = (UIImageView*)[cell viewWithTag:1];
    createdBy.layer.cornerRadius = createdBy.frame.size.width/2;
    createdBy.layer.masksToBounds = YES;

    if ([notification isKindOfClass:[WMRequest class]]) {
        WMRequest *request = (WMRequest *)notification;
        [createdBy setImageWithURL:[NSURL URLWithString:request.sent.photoURL] placeholderImage:[UIImage imageNamed:@"missingPhoto.png"]];
        UILabel *title = (UILabel*)[cell viewWithTag:2];
        title.frame = CGRectMake(title.frame.origin.x, title.frame.origin.y, title.frame.size.width + 50, title.frame.size.height);
        title.text = [NSString stringWithFormat:@"%@ wants to create a video with you.", request.sent.username];
        title.font = [UIFont systemFontOfSize:14];
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
        return 360;
    }
    // Cell isn't selected so return single height
    return 48;
}

#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    id notification = _notifications[indexPath.row];
    if ([notification isKindOfClass:[WMRequest class]]) {
        //toggle selected state for cell
        BOOL isSelected = ![self cellIsSelected:indexPath];
        for (NSString *key in [selectedIndexes copy]) {
            [selectedIndexes setObject:@NO forKey:key];
        }
        NSNumber *selectedIndex = [NSNumber numberWithBool:isSelected];
        [selectedIndexes setObject:selectedIndex forKey:indexPath];
        
        //preview video
        if (isSelected) {
            WMRequest *request = (WMRequest *)notification;
            [player setContentURL:[NSURL URLWithString:request.video.url]];
            [player prepareToPlay];
            [player play];
            [player setShouldAutoplay:YES];
            [cell addSubview:player.view];
        }
        else {
            [player stop];
            [player.view removeFromSuperview];
        }
        [tableView beginUpdates];
        [tableView endUpdates];
    }
    
}

@end
